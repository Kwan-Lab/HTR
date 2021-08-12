% % head-twitch recording master code %%
% Requires:
%           Image Acquisition Toolbox, 
%           Image Acquisition Toolbox Support Package for Teledyne DALSA Sapera Hardware and "GigE Vision Hardware"
% support package for camera video recording.
% Check 'imaqhwinfo', should have '" InstalledAdaptors: {'gige'} '"
% Detailed help can be found 'Hardware-Triggered Acquisition with a GigE
% Vision Camera'


%% IMPORTANT! - added to the recording code
% The dropped packet / frame error :  This error can occur if the Ethernet
%       adapter,camera network connection, and camera GigE streaming 
%       parameters (PacketSize and PacketDelay) are not configured for 
%       optimum operation.
% 
% Here, stop errors and carry on recording with frame drops. 'imaqreset'
% will reset this option back to normal.
%
%imaqreset
%imaqmex('feature', '-gigeDisablePacketResend', true);
%% For preview:
head_twitch_preview  % press space bar to end the preview

%% For recording: 
save_path = 'C:\Users\md2373\Documents\MATLAB\Data';
% if binning = 2, max ROI: 640x512 ( change values accordingly)
% if binning = 4, max ROI: 320x256
% if binning = 1, max ROI: 1280x1024
params.binning     = 4; % first thing decide 
params.frameRate   = 180;
params.ROIposition  = [0 0 310 230]; %resolution 0,0,800,600 for LR box only.310 230 for binned=4
params.exposureTime = 1500;            % min 34ms
params.saveVideo_frameRate  = 180; % frame rate to save video (=1 for slowmo to see framdrop)
startPupilDataRecording_head_twitch(save_path, params)

%%
%Clara ntoes: For psilocybin HTR recordings, use parameters:
    %params.binning=4
    %params.frameRate   = 180;
    %params.ROIposition  = [0 0 300 200];
    %params.exposureTime = 1500;         
    %params.saveVideo_frameRate  = 180; 
