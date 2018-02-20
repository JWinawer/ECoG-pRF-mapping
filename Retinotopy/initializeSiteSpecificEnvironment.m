function params = initializeSiteSpecificEnvironment(params)

switch params.site
    case 'NYU-ECOG'
        % Set up triggers via audio cable
        fs = 16000;
        InitializePsychSound;
        
        AudPnt = PsychPortAudio('Open', [], [], 0, fs, 1);
        
        % creating the square wave (or appending it to an audio stimulus as the first channel in the stereo file)
        square = [ones(1,fs/1000*50) -1*ones(1,fs/1000*50)];
        audiowrite('trigger.wav',square,fs);
        
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
        
            % NOTE FROM UMC: The BaudRate needs to be adjustable, because
            % it's different for fMRI and ECoG
            box.port = IOPort('OpenSerialPort', portName, ['Terminator=0 ReceiveLatency=0.0001 BaudRate=9600']);
            % start it
            IOPort('ConfigureSerialPort', box.port, 'BlockingBackgroundRead=1');
            IOPort('ConfigureSerialPort', box.port, 'StartBackgroundRead=1');
            params.siteSpecific.port = box.port;  
            % Alternative: use code from Ben Harvey to open port?
            % params.siteSpecific.port = deviceUMC('open',portName);
        
        else
            % For testing on a computer without a serial port, deviceUMC.m
            % can take a negative number as portname input and still run
            % (presumably)
            params.siteSpecific.port = -1; % deviceUMC('open',portName);
        
        end

    otherwise
        % do nothing
end