function stimulus = makeStimulusFromFile(params)
% Load a stimulus description from a file
%
% stimulus = makeStimulusFromFile(params)

% Check whether loadMatrix exists

stimPath = fullfile(ecogPRFRootPath, 'StimFiles', params.loadMatrix);

load(stimPath, 'stimulus');

% randomize fixations
duration.stimframe  = median(diff(stimulus.seqtiming));
minsec = round(4./duration.stimframe);

fixSeq = ones(minsec,1)*round(rand(1,ceil(length(stimulus.seq)/minsec)));
fixSeq = fixSeq(:)+1;


% force binary
fixSeq(fixSeq>2)=2;
fixSeq(fixSeq<1)=1;

stimulus.fixSeq = fixSeq;

fprintf('[%s]: Experiment duration (seconds): %6.3f\n', mfilename, stimulus.seqtiming(end)) 

end