function GetPupilVideo_head_twitch (v,filename,foldername,params)
% %GetPupilVideo_head_twitch (v,filename,foldername,params) %%
% records all frames without any trigger.
% INPUT: 
%       params: added as an editable options.Defaults;
%              params.frameRate =90Hz,
%              params.ROIposition = [0 0 600 600];
%
% H Atilgan, 06/11/2020

%%
if nargin<4
    frameRate = 30; 
    ROIposition  = [0 0 1008 1000];
    exposureTime = 100;
    saveVideo_frameRate = 30;
    binning = 1;
else
    frameRate   = params.frameRate; 
    ROIposition = params.ROIposition;
    exposureTime = params.exposureTime;
    saveVideo_frameRate = params.saveVideo_frameRate;
    binning = params.binning;
end

% Connect to Camera
cam = getselectedsource(v);
cam.BinningHorizontal = binning;
cam.BinningVertical = binning;
v.ROIPosition = ROIposition;

cam.ExposureMode = 'Timed';              %Set exposure time and mode
cam.ExposureTime = exposureTime;         %Default is 15K 

%% Start Trials / Experiment
cd(foldername)
videoRecording = VideoWriter(filename, 'Grayscale AVI');
% fix block/frame issue
cam.AcquisitionFrameRate = frameRate;    %Frame Rate per second
cam.PacketSize = 9000;                   %Max avaliable/optimum value.
frameToAcquire = frameRate; 
framesPerSecond = CalculateFrameRate(v,frameToAcquire);
packetDelay = CalculatePacketDelay(v, framesPerSecond);
cam.PacketDelay = packetDelay;
%
videoRecording.FrameRate = saveVideo_frameRate;
v.LoggingMode = 'disk';
v.DiskLogger =  videoRecording;
triggerconfig(v,'immediate');
v.FramesPerTrigger = inf; 

recordingEnd = 0;
progression = UpdatableText; % UpdatableText is the actual class
FS = stoploop({'Pupil Recording is running', 'Click OK to finish recording'}) ; % Set up the stop box
start(v); % start recording
tic
while recordingEnd==0
    recordingEnd = 0;
    recordingTime = toc;
    progression.print(sprintf('Recording time: %f',recordingTime));
    if FS.Stop()
        recordingEnd = 1;
    end
end
recordingTime = toc;
stop(v)
fprintf ('Recording for %s stopped. \nRecording time: %f sec \nSaved: %s\n', filename, recordingTime,foldername)


end