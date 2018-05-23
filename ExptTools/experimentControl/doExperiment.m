function quitProg = doExperiment(params)
% doExperiment - runs ECoG, MEG, EEG, or fMRI experiment
%
% quitProg = doExperiment(params)

% Set screen params
params = setScreenParams(params);

% Site-specific settings
params = initializeSiteSpecificEnvironment(params);

% Load stimulus
stimulus = makeStimulusFromFile(params);

% Set fixation params
params   = setFixationParams(params, stimulus);

% WARNING! ListChar(2) enables Matlab to record keypresses while disabling
% output to the command window or editor window. This is good for running
% experiments because it prevents buttonpresses from accidentally
% overwriting text in scripts. But it is dangerous because if the code
% quits prematurely, the user may be left unable to type in the command
% window. Command window access can be restored by control-C.
ListenChar(2);

% loading mex functions for the first time can be
% extremely slow (seconds!), so we want to make sure that
% the ones we are using are loaded.
KbCheck;GetSecs;WaitSecs(0.001);

try
    % Turn off screen warnings
    Screen('Preference','VisualDebugLevel', 0);
    
    % check for OpenGL
    AssertOpenGL;
    
    Screen('Preference','SkipSyncTests', params.skipSyncTests);
        
    % Open the screen
    params.display = openScreen(params.display);
    
    if params.useEyeTracker
          global PTBTheWindowPtr
          PTBTheWindowPtr = params.display.windowPtr;
     
          PTBInitEyeTracker;
          % paragraph = {'Eyetracker initialized.','Get ready to calibrate.'};
          % PTBDisplayParagraph(paragraph, {'center',30}, {'a'});
          PTBCalibrateEyeTracker;
    
          % actually starts the recording
          % name correponding to MEG file (can only be 8 characters!!, no extension)
          PTBStartEyeTrackerRecording('eyelink');
          % Q How is the path to the log files set?
    end
    
    % to allow blending
    Screen('BlendFunction', params.display.windowPtr, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    
    % Store the images in textures
    stimulus = createTextures(params.display,stimulus);
        
    % set priority
    Priority(params.runPriority);
    
    % wait for go signal
    [time0, quitProg] = pressKey2Begin(params); 
    
    if ~quitProg
        % Do the experiment!
        if isfield(params, 'modality') && strcmpi(params.modality, 'fMRI')
            timeFromT0 = true;
        else, timeFromT0 = false;
        end
        
        [response, timing, quitProg] = showScanStimulus(params,stimulus,time0, timeFromT0); %#ok<ASGLU> timing and quitProg key are saved (but not otherwise used)
        
        % After experiment
        
        % Reset priority
        Priority(0);
        
        % Get performance
        [pc,rc] = getFixationPerformance(params.fix,stimulus,response);
        
        fprintf('[%s]: percent correct: %.1f\nreaction time: %.1f secs\n',mfilename,pc,rc);
        
        % Save
        
        % Save path
        pth = fullfile(vistadispRootPath, 'Data');
       
        % Get current date and time
        params.experimentDateandTime = datestr(now,30); 
        % This used to be in the filename but was removed because of BIDS
        % requirements; now saving it along with the other variables 
        
        % Include a runNumber field to indicate if this is a repeat run
        params.runNumber = params.runID;
        % This number will be updated below if previous instantiations of
        % this run exist in the folder where the data is saved.
       
        % Generate save name using BIDS naming convention: exclude runNumber
        tempname = sprintf('sub-%s_ses-%s%s_task-%s_run-*.mat', ...
            params.subjID, params.site, params.sessionID, params.experiment);
        
        % Check if runNumber already exists
        D = dir(fullfile(pth, tempname));
        if length(D) >= params.runNumber
            % Update params.runNumber to not overwrite existing file [Note
            % that params.runID and the tsv stim_file will still refer to
            % the identity of the stimfile that was loaded for this run]
            params.runNumber = length(D)+1;
        end
        
        % Generate save name using BIDS naming convention:include runNumber
        fname = sprintf('sub-%s_ses-%s%s_task-%s_run-%d', ...
            params.subjID, params.site, params.sessionID, params.experiment, params.runNumber);
            
        % Everything in the workspace will be saved!
        save(fullfile(pth, sprintf('%s.mat', fname)));
        
        fprintf('[%s]:Saving in %s.\n', mfilename, fullfile(pth, fname));
        
        % Write out the tsv file
        if any(contains(fieldnames(stimulus), 'tsv'))
            % Replace pointer to input stimfile with output stimfile
            % NOTE: to comply with BIDS compatible file structure, the
            % output stimfiles (extension.mat) should be placed in a
            % 'stimuli' folder within the project folder (above the
            % subjects/session levels)
            numberOfEventsPerRun = size(stimulus.tsv,1);
            stimulus.tsv.stim_file = repmat(sprintf('%s.mat', fname), numberOfEventsPerRun,1);
            writetable(stimulus.tsv, fullfile(pth, sprintf('%s.tsv', fname)), ...
                'FileType','text', 'Delimiter', '\t')
        end
   
    end
    
    % Close the one on-screen and many off-screen windows
    closeScreen(params.display);
    ListenChar(1)
    
    % Close site-specific functionalities
    if params.useSerialPort
        switch params.site
            
            case {'UMC7T' 'UMC3T'}
                deviceUMC('close', params.siteSpecific.port);
                
            case 'UMCECOG'
                fclose(params.siteSpecific.port);
                
        end
    end
    if params.useEyeTracker
        PTBStopEyeTrackerRecording; % <----------- (can take a while)
        
        % move the file to the logs directory
        destination = 'eyelink';
        i = 0;
        while exist([destination num2str(i) '.edf'], 'file')
            i = i + 1;
        end
        %movefile('eyelink.edf', [destination num2str(i) '.edf'])
        movefile('eyelink.edf', fullfile(pth, [destination num2str(i) '.edf']));
    end

catch ME
    % Clean up if error occurred
    if params.useSerialPort
        switch params.site
            
            case {'UMC7T' 'UMC3T'}
                deviceUMC('close', params.siteSpecific.port);
                
            case 'UMCECOG'
                fclose(params.siteSpecific.port);
                
        end
    end
    if params.useEyeTracker
        PTBStopEyeTrackerRecording; 
    end
    Screen('CloseAll');
    ListenChar(1)
    setGamma(0); Priority(0); ShowCursor;    
    quitProg = true;
    rethrow(ME);
end

return;