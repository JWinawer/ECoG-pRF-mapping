function stimulus = makeStimulusFromFile(params)
% Load a stimulus description from a file
%
% stimulus = makeStimulusFromFile(params)

% Check whether loadMatrix exists

stimPath = fullfile(vistadispRootPath, 'StimFiles', params.loadMatrix);

load(stimPath, 'stimulus');

% Adjust screen position
h = params.shiftDestRect(1);  % horizontal offset in pixels. positive is rightward shift
v = params.shiftDestRect(2);  % vertical offset in pixels. positive is upward shift

stimulus.dstRect = stimulus.dstRect + [h -v h -v]; %#ok<NODEF> %[l t r b]

fprintf('[%s]: Experiment duration (seconds): %6.3f\n', mfilename, stimulus.seqtiming(end)) 

end