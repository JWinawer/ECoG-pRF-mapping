
% Which subject and session?
[subjID, sessionID, ssDefined] = whichSubjectandSession();
if ~ssDefined, return; end


% Set parameters for this experiment
params.experiment       = 'prf';
params.subjID           = subjID;
params.runID            = 1;
params.sessionID        = sessionID;
params.loadMatrix       = 'pRF_experiment';
params.modality         = 'ECoG';
params.site             = 'Stanford';
params.calibration      = 'SoMMacBook';
params.triggerKey       = '5';
params.fixation         = 'cross';

% Additional parameters 
params.prescanDuration  = 0;
params.startScan        = 0;

% Set priority (depends on operating system)
if ispc
    params.runPriority  = 2;
elseif ismac
    params.runPriority  = 7;
end

% Debug mode?
params.skipSyncTests = 1;

% Go!
quitProg = doExperiment(params);

