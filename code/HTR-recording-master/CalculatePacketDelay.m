function [delay] = CalculatePacketDelay(vid, fps)
% CalculatePacketDelay Calculates recommended packet delay for a GigE Vision camera.
%
%    DELAY = CalculatePacketDelay(VID, FPS) calculates recommended packet 
%    delay DELAY for a GigE Vision camera, represented by an image
%    acquisition videoinput or gigecam object VID.
%    Camera framerate FPS (frames per second) is required and is specific
%    to the camera configuration. The companion CalculateFrameRate function
%    can be used to measure the camera framerate, if unknown.
%
%    Example with videoinput vid:
%       vid = videoinput('gige', 1);
%       src = vid.Source;
%       src.PacketSize = 9000;
%       fps = CalculateFrameRate(vid, 20);
%       delay = CalculatePacketDelay(vid, fps);
%       src.PacketDelay = delay;
%
%    Example with gigecam g:
%       g = gigecam;
%       g.GevSCPSPacketSize = 9000;
%       fps = CalculateFrameRate(g, 20);
%       delay = CalculatePacketDelay(g, fps);
%       g.GevSCPD = delay;

%   Copyright (c) 2013 - 2015 The MathWorks, Inc.

if nargin < 2
    error('CalculatePacketDelay(vid, fps) videoinput/gigecam object and framerate are required arguments to run this utility.');
else            
    if ~isnumeric(fps)
        error('CalculatePacketDelay(vid, fps) fps must be a number');
    end
    if ~(isscalar(fps) && isfinite(fps) && (fps > 0))
        error('CalculatePacketDelay(vid, fps) fps must finite and > 0 to find a frame rate');
    end
end

if ~(isa(vid, 'videoinput') || isa(vid, 'gigecam')) || ~isvalid(vid) || ~isscalar(vid)
    error('CalculatePacketDelay(vid, fps) vid must be a valid videoinput or gigecam object');
end

% get  - packetSize (GevSCPSPacketSize)
%      - TickFreq (GevTimestampTickFrequency)
%      - video format (PixelFormat)
%      - frame height
%      - frame width

switch class(vid)
    case 'videoinput'
        src = getselectedsource(vid);
        
        % get packet size (depending on MATLAB release PacketSize is int32 or char)
        if isnumeric(src.PacketSize)
            packetSize = double(src.PacketSize);
        else
            packetSize = str2double(src.PacketSize);
        end

        try
            TickFreq = src.TimestampTickFrequency;
        catch e
            if strcmp(e.identifier,'MATLAB:noSuchMethodOrField') || strcmp(e.identifier,'testmeas:getset:invalidProperty')
                 error('Packet delay is not supported on the device');
            end
        end
        pixelFormat = vid.videoFormat;
        roi = vid.ROIPosition;
        height = roi(1,4);
        width = roi(1,3);
    case 'gigecam'
        packetSize = double(vid.GevSCPSPacketSize);
        TickFreq = double(vid.GevTimestampTickFrequency);
        pixelFormat = vid.PixelFormat;
        height = double(vid.Height);
        width = double(vid.Width);
   otherwise
        % unexpected case
        error('CalculatePacketDelay(vid, fps) vid must be a valid videoinput or gigecam object');
end

switch (pixelFormat)
    case {'Mono8' ,'BayerGR8','BayerRG8','BayerGB8','BayerBG8'}
        BytesPerPixel = 1;
    case {'Mono10Packed' ,'YUV411Packed'}
        BytesPerPixel = 1.5;
    case {'Mono10','Mono12','Mono14' ,'Mono16','BayerGR10','BayerRG10','BayerGB10','BayerBG10','BayerGR12','BayerRG12','BayerGB12','BayerBG12','BayerGR16','BayerRG16','BayerGB16','BayerBG16','YUV422Packed',''}
        BytesPerPixel =2;
    case {'RGB8Packed','BGR8Packed','YUV444Packed','RGB8Planar',}
        BytesPerPixel=3;
    case {'RGBA8Packed','BGRA8Packed'}
        BytesPerPixel = 4;
    case {'RGB10Packed','BGR10Packed','RGB12Packed','BGR12Packed','RGB10Planar','RGB12Planar','RGB16Planar'}
        BytesPerPixel = 6;
end


% calculate packet delay
fprintf('Calculating packet delay for:\n frame rate = %d fps,\tPacketSize (GevSCPSPacketSize) = %d,\tframe height = %d,\tframe width = %d,\tpixel format = %s, \n',... 
    fps, packetSize, height, width, pixelFormat);
fprintf(1, 'camera time stamp tick frequency (ticks/s) = %.1f \n', TickFreq);

numOfBytes_EthernetHeader = 14;
numOfBytes_IPHeader  = 20;
numOfBytes_UDPHeader = 8;
numOfBytes_GVSPHeader = 8;
numOfBytes_EthernetFooter = 2;

numOfBytes_overheadPerPacket = numOfBytes_EthernetHeader+numOfBytes_IPHeader+numOfBytes_UDPHeader+numOfBytes_GVSPHeader;
numOfBytes_GVSP_Leader = numOfBytes_overheadPerPacket+36;
numOfBytes_GVSP_Trailer = numOfBytes_overheadPerPacket+numOfBytes_EthernetFooter+numOfBytes_GVSPHeader; %Ethernet Footer+GVSP Header

actual_packetSize = packetSize-numOfBytes_overheadPerPacket;

numOfBytes_perFrame = height  *  width  *  BytesPerPixel;

numOfPackets_perFrame = ceil(numOfBytes_perFrame/actual_packetSize)+2 ; 

total_OverHead_Bytes = ceil(numOfPackets_perFrame) * numOfBytes_overheadPerPacket;

full_packets = floor(numOfPackets_perFrame ) * actual_packetSize;

numOfBytes_perImage = numOfBytes_GVSP_Leader+(floor(numOfPackets_perFrame ) * actual_packetSize)+(numOfBytes_perFrame-(full_packets))+total_OverHead_Bytes + numOfBytes_GVSP_Trailer;

numOfBytes_perSec  = fps * numOfBytes_perImage;

bits_perSecond = numOfBytes_perSec  * 8;

ratio_GigeUtilized= bits_perSecond/10^9;

ratio_GigeNotUtilized = 1 - ratio_GigeUtilized;

pauseTime_between_Packets = ratio_GigeNotUtilized/(numOfPackets_perFrame * fps);

PacketDelay = TickFreq * pauseTime_between_Packets;

delay = round(0.9 * PacketDelay);
fprintf(1, '\nUsed gigabit bandwitdh: %.1f %%\n', 100 * ratio_GigeUtilized);
fprintf(1, 'PacketDelay (GevSCPD): %d (ticks)\n', delay);


end

