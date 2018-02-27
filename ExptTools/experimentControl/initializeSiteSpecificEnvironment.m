function params = initializeSiteSpecificEnvironment(params)

switch params.site
    case 'NYU-MEG'
        
        % Initialize eye tracker
        
        PTBInitStimTracker;
        global PTBTriggerLength 
        PTBTriggerLength = 0.005;

        % Q do we need to initialize a trigger channel?
        
    case 'NYU-ECOG'
        % Set up triggers via audio cable
        fs = 16000;
        InitializePsychSound;
        
        AudPnt = PsychPortAudio('Open', [], [], 0, fs, 1);
        
        % creating the square wave (or appending it to an audio stimulus as the first channel in the stereo file)
        % To make trigger.wav:
        %       square = [ones(1,fs/1000*50) -1*ones(1,fs/1000*50)];
        %       audiowrite('trigger.wav',square,fs);        
        wavdata = audioread('trigger.wav');
        
        % play stimuli (one channel is a square wave)
        PsychPortAudio('FillBuffer', AudPnt,wavdata');
        params.siteSpecific.AudPnt = AudPnt;
        
    case {'UMC-7T' 'UMC-3T'}
        % Initialize the serial port for UMC
        
        % First, find the serial port
        portName = FindSerialPort([],1,1);
        
        % Open serial port 
        if ~isempty(portName)

            params.siteSpecific.port = deviceUMC('open',portName);
        
        else
            
            % For testing on a computer without a serial port, deviceUMC.m
            % can take a negative number as portname input and still run
            params.siteSpecific.port = -1; % deviceUMC('open',portName);
        
        end

    otherwise
        % do nothing
end