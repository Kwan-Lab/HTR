function [ fps ] = CalculateFrameRate(vid, framesToAcquire)
% CalculateFrameRate Measure frame rate of a videoinput or gigecam camera object.
%
%   FPS = CalculateFrameRate(VID, FRAMESTOACQUIRE) measures frame rate FPS
%   (frames per second) of a videoinput or gigecam camera object VID.
%   VID should already be configured (exposure time, region of interest, etc.)
%   as required for the actual acquisition before measuring the frame rate.
%   FRAMESTOACQUIRE is the number of frames to acquire for measuring the frame rate.
%
%   Example:
%       
%       framesToAcquire = 10;
%       fps = CalculateFrameRate(vid, framesToAcquire)

%   Copyright (c) 2013 - 2015 The MathWorks, Inc.

if nargin < 2
    error('CalculateFrameRateFrameRate(vid, framesToAcquire) videoinput/gigecam object and number of frames to acquire are required.');
else
    if ~isnumeric(framesToAcquire)
        error('CalculateFrameRateFrameRate(vid, framesToAcquire) framesToAcquire must be a number');
    end
    if ~(isscalar(framesToAcquire) && isfinite(framesToAcquire) && (framesToAcquire >= 2))
        error('CalculateFrameRateFrameRate(vid, framesToAcquire) framesToAcquire must be >= 2 and finite to find a frame rate');
    end
end

if ~(isa(vid, 'videoinput') || isa(vid, 'gigecam')) || ~isvalid(vid) || ~isscalar(vid)
    error('CalculateFrameRate(vid, framesToAcquire) vid must be a valid videoinput or gigecam object');
end


switch class(vid)
    case 'videoinput'
        stop(vid);
        ov.FramesPerTrigger = vid.FramesPerTrigger;
        ov.FrameGrabInterval = vid.FrameGrabInterval;
        ov.TriggerRepeat = vid.TriggerRepeat;
        ov.LoggingMode = vid.LoggingMode;
        ov.Timeout = vid.Timeout;
        ov.triggerconfig = triggerconfig(vid);
              
        try
            ov.disablePacketResend = imaqmex('feature', '-gigeDisablePacketResend');
            imaqmex('feature', '-gigeDisablePacketResend', true);
        catch
            % gigeDisablePacketResend option not supported in this version
        end
        
        % On cleanup, restore original configuration for videoinput
        oc = onCleanup(@() restoreOriginalVideoinput(vid, ov));
        
        
        vid.FramesPerTrigger = framesToAcquire;
        vid.TriggerRepeat = 0;
        vid.FrameGrabInterval = 1;
        vid.LoggingMode = 'memory';
        triggerconfig(vid, 'immediate');
        vid.Timeout = 100;

        start(vid);
        
        wait(vid);
        
        % Calculate frame rate (fps) by doing a linear fit of BlockID vs 
        % relative timestamps
        [~, ts, metadata] = getdata(vid, vid.FramesAvailable);
        
        % BlockID metadata available as of MATLAB R2010b
        blockID = [metadata(:).BlockID]';

        p = polyfit(ts, blockID, 1);
        fps = p(1);       
        
        % dts = diff(ts);
        % disp(1 / mean( dts ));
        
        % x = linspace(min(ts), max(ts), 100);
        % y = p(1)*x + p(2);
        % figure;
        % plot(ts, blockID, '.', x, y);
        % xlabel('Relative timestamps (s)')
        % ylabel('Frame metadata BlockID')
        % legend({'Data', 'Linear fit used for fps calculation'})        
    case 'gigecam'
        for ii = 1:framesToAcquire
            [~, ts(ii)] = snapshot(vid); %#ok<AGROW>
        end
        % ts is an array of datetime objects
        dts = seconds(diff(ts));
        
        % Calculate fps (frames per second)
        fps =  1 / mean( dts );

    otherwise
        % Unexpected case
        error('CalculateFrameRate(v, framesToAcquire) v must be a valid videoinput or gigecam object');
end





    function restoreOriginalVideoinput(vid, ov)
        stop(vid);
        vid.FramesPerTrigger = ov.FramesPerTrigger;
        vid.FrameGrabInterval = ov.FrameGrabInterval;
        vid.TriggerRepeat = ov.TriggerRepeat;
        vid.LoggingMode = ov.LoggingMode;
        vid.Timeout = ov.Timeout;
        triggerconfig(vid, ov.triggerconfig);
        try
            imaqmex('feature', '-gigeDisablePacketResend', ov.disablePacketResend);
        catch
            % gigeDisablePacketResend option not supported in this version
        end

    end

end