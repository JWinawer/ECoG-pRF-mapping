
% Which subject and session?
[subjID, sessionID, ssDefined] = whichSubjectandSession();
if ~ssDefined, return; end


% Set parameters for this experiment
params.experiment       = 'prf';
params.subjID           = subjID;
params.runID            = 1;
params.sessionID        = sessionID;
params.modality         = 'ECoG';
params.site             = 'Stanford';
params.calibration      = 'SoMMacBook';
params.loadMatrix       = 'pRF_experiment';
params.triggerKey       = '5';
params.fixation         = 'cross';
params.runPriority      = 2;
params.prescanDuration  = 0;
params.startScan        = 0;

% Debug mode?
params.skipSyncTests = 0;

% Go!
doExperiment(params);
