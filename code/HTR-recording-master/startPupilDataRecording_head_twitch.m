function startPupilDataRecording_head_twitch (data_path, params)
% %startPupilDataRecording_head_twitch %%
% This code records at high frame rate for head-twitch behaviour without
% any trigger. It will check camera connection, and ask for subject ID -
% then will start recording until stop clicked. 
% INPUT: 
%       params: added as an editable options.Defaults;
%              params.frameRate =90Hz,
%              params.ROIposition = 
[0 0 600 600];


%% Check Camera connection
% disable frame drop error
%imaqreset
%imaqmex('feature', '-gigeDisablePacketResend', true);

fprintf('\nNow, setting up camera might take a minute or so.\nProcessing...\n');

v = videoinput('gige', 1, 'Mono8');
if isempty(v)
    error('Camera is not properly connected/ check adapter.');
    % check details in 'GetPupilVideo.m'
else
    disp('Camera is working correctly.');
end

%% Create fileName & Ask for the subject number - Matched to NBS
prompt = {'Subject Name/ID:';'Experiment'};
title = 'Enter subject ID';
dims = [1 35];
definput = {'2000';'control'};
temp = newid(prompt,title,dims,definput);   %modified version of 'inputdlg'
subj  = temp{1};
experiment = temp{2};
[c] = clock;

session_name = ['HTR_',experiment,'_', subj,'_',...
    num2str(c(1)-2000,'%.2d'),num2str(c(2),'%.2d'),num2str(c(3),'%.2d'),...
    num2str(c(4),'%.2d'),num2str(c(5),'%.2d')];

if ~exist(data_path,'dir')
    mkdir(data_path)
end

GetPupilVideo_head_twitch(v,session_name,data_path,params);

delete(v);
close all hidden
clear global
%jheapcl
