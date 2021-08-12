%% Overview
    % This code creates a  NI USB-6001 DAQ session in order to track
    % voltage for a specified period of time. It then filters the data,
    % institutes a threshold value, and determines the number of HTR events
    % that were detected during the session. It posts in the command window
    % the time points of these HTR events. 

%% Creating DAQ session tracking running voltage for specified period of time
    s=daq.createSession('ni'); % In order to begin a NI DAQ session
    addAnalogInputChannel(s,'Dev1',0,'Voltage'); % Adding analog input channel "0"
    s.DurationInSeconds=600; % This is the duration of the recording in seconds.
    data=s.startForeground(); % The data set we will use in this code is called "data."
%% Defining processing and detection parameters
    % The next part of the code is adapted from Revenga et. al (2019)
    Fs = 1000; % Sampling frequency of the recorded session, i.e. 1000 data points per second

    % Band-pass filter parameters
    bpL = 70; % Lower limit of the band-pass filter (Hz)
    bpH = 110; % Higher limit of the band-pass filter (Hz)

    % HTR detection parameters
    nSD = 70; % Number of standard deviations (SD) for threshold (multiplier)
    Ttv = 0.225; % Top threshold value (V)
    mpd = 3000; % Minimum distance between events (ms)
    Mpw = 1000; % Maximum width of an event (ms)
%% Applying a Butterworth band-pass filter to the raw data

    f_high = designfilt('bandpassiir','FilterOrder',20, ...
        'HalfPowerFrequency1',bpL,'HalfPowerFrequency2',bpH, ...
        'SampleRate',Fs); % Butterworth band-pass filter
    data_h = filtfilt(f_high,data); % Band-passing the raw data

%% Baseline correction and tranformation to absolute values

    Mh = mean(data_h); % Mean of filtered data
    data_h = data_h - Mh; % Approaching the baseline to an average of 0
    absh = abs(data_h); % Absolute value transformation

%% Setting the threshold

    sd = std(data_h); % SD of the band-passed data

    if sd * nSD > Ttv % Conditional for setting the value of the threshold
        threshold = Ttv; % Top threshold value for datasets with higher SD
    else
        threshold = sd * nSD; % Threshold set to n-fold SD (datasets with lower SD)
    end

%% Unconditional detection of local maxima

    [pksh,loch] = findpeaks(absh); % Prominence of local maxima stored in "pksh", their time indices are stored in "loch"

%% Conditional detection of local maxima for identification of HTR events

    [pksh2,loch2,wh2] = findpeaks(pksh,loch,'MinPeakHeight',threshold,'MinPeakDist',mpd,'MaxPeakWidth',Mpw); % Prominence, time position and width of local maxima --applied over the previous local maxima detection-- stored if the detection parameters are met. In other words, if a HTR event is detected.
    % "pksh2" contains the prominence (V) of each HTR event detected
    % "loch2" contains the time (ms) of occurrence of each HTR event detected.
    % This are the timestamps used for matching visually identified events.
    % "wh2" contains the width (ms) of each HTR event detected
    figure();
    findpeaks(pksh,loch,'MinPeakHeight',threshold,'MinPeakDist',mpd,'MaxPeakWidth',Mpw);
    txt=['Number of peaks is ',num2str(size(loch2,1))]; % Pastes in words on the graph the number of peaks (HTR events) detected by the code
    text(1,0.3,txt);
    xlabel('Time (ms)');
    ylabel('Signal (|V|)');
    s=milliseconds(loch2);
    s.Format='mm:ss.SSS';
    X='The time points of the head twitches are:';
    disp(X);
    disp(s);
    save data.mat data
    % To load the data on a different computer, type load('data.mat').
    % Make sure not to overwrite the data.mat file (i.e., don't re-run the
    % DAQ until the data.mat file has been exported).
