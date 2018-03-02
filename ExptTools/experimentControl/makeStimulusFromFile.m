function stimulus = makeStimulusFromFile(params)
% Load a stimulus description from a file
%
% stimulus = makeStimulusFromFile(params)

% Check whether loadMatrix exists
if ~isfield(params, 'loadMatrix'), error('No loadMatrix to load'); end
    stimPath = fullfile(vistadispRootPath, 'StimFiles', params.loadMatrix);
if ~exist(stimPath, 'file'), error('Cannot locate stim file %s.', stimPath); end

% Load the stimulus from a stored file
tmp = load(stimPath, 'stimulus');

if isfield(tmp, 'stimulus'),  stimulus = tmp.stimulus;    
else,                         stimulus = tmp;  end

% clear textures field if it exists. textures will be remade later
if isfield(stimulus, 'textures'), stimulus = rmfield(stimulus, 'textures'); end

%% fixation dot sequence

if isfield(stimulus, 'fixSeq') && ~isempty(stimulus.fixSeq)
    % Check that fixation length is at least as long as stimulus length,
    % otherwise we will have an error
    if length(stimulus.fixSeq) < length(stimulus.seq)
        error('Fixation sequence in file %s is shorter than stimulus sequence.', ...
            params.loadMatrix)
    end
    % use it
else
    
    % Generate a fixation sequence
    minDurationInSeconds = 1;
    maxDurationInSeconds = 5;
    dwellTimePerImage    = median(diff(stimulus.seqtiming)); % temporal resolution in seq timing
    fixSeq = createFixationSequence(stimulus, dwellTimePerImage, minDurationInSeconds, maxDurationInSeconds);
    stimulus.fixSeq = fixSeq;
    
%     % change on the fastest every 6 seconds
%     duration.stimframe  = median(diff(stimulus.seqtiming));
%     minsec = round(6./duration.stimframe);
%     
%     fixSeq = ones(minsec,1)*round(rand(1,ceil(length(stimulus.seq)/minsec)));
%     fixSeq = fixSeq(:)+1;
%     
%     % force binary
%     fixSeq(fixSeq>2)=2;
%     fixSeq(fixSeq<1)=1;
% 
%     stimulus.fixSeq = fixSeq;

end