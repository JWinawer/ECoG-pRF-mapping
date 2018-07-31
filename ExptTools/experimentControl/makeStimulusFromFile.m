function stimulus = makeStimulusFromFile(params)
% Load a stimulus description from a file
%
% stimulus = makeStimulusFromFile(params)

% Check whether loadMatrix exists

stimPath = fullfile(ecogPRFRootPath, 'StimFiles', params.loadMatrix);

load(stimPath, 'stimulus');

fprintf('[%s]: Experiment duration (seconds): %6.3f\n', mfilename, stimulus.seqtiming(end)) 

end