function doExperiment(params)
% doExperiment - runs ECoG, MEG, EEG, or fMRI experiment
%
% doExperiment(params)

% Set rest of the params
params = setRetinotopyParams(params.experiment, params);

% Site-specific settings
params = initializeSiteSpecificEnvironment(params);

% defaults
if ~exist('params', 'var'), error('No parameters specified!'); end

% make/load stimulus
stimulus = makeRetinotopyStimulusFromFile(params);

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
    
    % THIS PART NOT WORKING ON DESKTOP FOR NYU-ECOG
    
    % Open the screen
    xy = params.display.numPixels; % store screen dimensions in case they change
    params.display                = openScreen(params.display);
    % Reset Fixation parameters if needed (ie if the dimensions of the
    % screen after opening do not match the dimensions specified in the
    % calibration file) 

    if isequal(xy, params.display.numPixels)
        % OK, nothing changed
    else
        params = retSetFixationParams(params);
    end
    
    % to allow blending
    Screen('BlendFunction', params.display.windowPtr, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    
    % Store the images in textures
    stimulus = createTextures(params.display,stimulus);
    
    % If necessary, flip the screen LR or UD  to account for mirrors
    % We now do a single screen flip before the experiment starts (instead
    % of flipping each image). This ensures that everything, including
    % fixation, stimulus, countdown text, etc, all get flipped.
    retScreenReverse(params, stimulus);
 
    for n = 1:params.repetitions
        
        % set priority
        Priority(params.runPriority);
        
        % reset colormap?
        retResetColorMap(params);
        
        % wait for go signal
        pressKey2Begin(params);

        % countdown + get start time (time0)
        [time0] = countDown(params.display,params.countdown,params.startScan,params.trigger);
        time0   = time0 + params.startScan; % we know we should be behind by that amount
                
        % go
        if isfield(params, 'modality') && strcmpi(params.modality, 'ecog')
            timeFromT0 = false;
        else, timeFromT0 = true;
        end        
        [response, timing, quitProg] = showScanStimulus(params,stimulus,time0, timeFromT0); %#ok<ASGLU>
        
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
        
        
        % don't keep going if quit signal is given
        if quitProg, break; end
        
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








