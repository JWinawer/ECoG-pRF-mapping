function doExperiment(params)
% doExperiment - runs ECoG, MEG, EEG, or fMRI experiment
%
% doExperiment(params)

% Set screen params
params = setScreenParams(params);

% Site-specific settings
params = initializeSiteSpecificEnvironment(params);

% defaults
if ~exist('params', 'var'), error('No parameters specified!'); end

% make/load stimulus
stimulus = makeStimulusFromFile(params);

fprintf('[%s]: Experiment duration (seconds): %6.3f\n', mfilename, stimulus.seqtiming(end))

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
    % check for OpenGL
    AssertOpenGL;
    
    Screen('Preference','SkipSyncTests', params.skipSyncTests);
        
    % Open the screen
    params.display = openScreen(params.display);
        
    % Reset Fixation parameters if needed (ie if the dimensions of the
    % screen after opening do not match the dimensions specified in the
    % calibration file)
    params = setFixationParams(params);
    
    % to allow blending
    Screen('BlendFunction', params.display.windowPtr, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    
    % Store the images in textures
    stimulus = createTextures(params.display,stimulus);
        
    % set priority
    Priority(params.runPriority);
    
    % wait for go signal
    time0 = pressKey2Begin(params);
        
    %% Do the experiment!
    if isfield(params, 'modality') && strcmpi(params.modality, 'ecog')
        timeFromT0 = false;
    else, timeFromT0 = true;
    end
    [response, timing, quitProg] = showScanStimulus(params,stimulus,time0, timeFromT0); %#ok<ASGLU>
    
    %% After experiment
    
    % reset priority
    Priority(0);
    
    % get performance
    [pc,rc] = getFixationPerformance(params.fix,stimulus,response);
    fprintf('[%s]: percent correct: %.1f\nreaction time: %.1f secs\n',mfilename,pc,rc);
    
    % save
    pth = fullfile(vistadispRootPath, 'Data');
    
    fname = sprintf('%s_%s_%s_%s', params.subjID, params.experiment, params.site, datestr(now,30));
    
    save(fullfile(pth, sprintf('%s.mat', fname)));
    
    fprintf('[%s]:Saving in %s.\n', mfilename, fullfile(pth, fname));
    
    if any(contains(fieldnames(stimulus), 'tsv'))
        writetable(stimulus.tsv, fullfile(pth, sprintf('%s.tsv', fname)), ...
            'FileType','text', 'Delimiter', '\t')
    end
    
    
    % Close the one on-screen and many off-screen windows
    closeScreen(params.display);
    ListenChar(1)
    if params.useSerialPort
        deviceUMC('close', params.siteSpecific.port);
    end
    
catch ME
    % clean up if error occurred
    if params.useSerialPort
        deviceUMC('close', params.siteSpecific.port);
    end
    Screen('CloseAll');
    ListenChar(1)
    setGamma(0); Priority(0); ShowCursor;
    warning(ME.identifier, '%s', ME.message);
end

return;








