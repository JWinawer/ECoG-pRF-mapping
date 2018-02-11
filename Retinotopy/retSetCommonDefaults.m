function params = retSetCommonDefaults(params, expName)
%
% params = retSetCommonDefaults(params, expName)
%
% April, 2010, JW: split off from setRetinopyParams
%
% Still a little hard to read. Main parameter categories set here are:
%
%   - Timing
%   - Screen / Calibration
%   - Stimulus dimensions
%   - Blanks
%   - Quit key
%
% Some of these may be overwritten by experiment-specific settings or
% fixation-specific settings.
%
% See also
%       setRetinotopyParams.m
%       retSetFixationParams.m
%       retSetExperimentParams.m
%       retSetCommonDefaults.m

% ************************
% Screen / Calibration
% ************************
if ~isempty(params.calibration)
    params.display = loadDisplayParams('displayName',params.calibration);
    fprintf('[%s]:loading calibration from: %s.\n',mfilename,params.calibration);
else
    params.display = setDefaultDisplay;
    fprintf('[%s]:no calibration.\n',mfilename);
end


if max(Screen('screens')) < params.display.screenNumber
    fprintf('[%s]:resetting screenNumber %d -> %d.\n',mfilename,...
        params.display.screenNumber,max(Screen('screens')));
    params.display.screenNumber   = max(Screen('screens'));
end

params.dispString           = [expName '.  Please watch the fixation square.'];

% Color parameters

params.backRGB.dir          = [1 1 1]';	% These two values are your
params.backRGB.scale        = 0.5;		% standard default gray.
params.stimLMS.dir          = [1 1 1]';
params.stimLMS.scale        = 1.0;
%bk = findName(params.display.reservedColor,'background');
%params.display.reservedColor(bk).gunVal = (params.display.numColors-1) * ...
%								params.backRGB.scale*params.backRGB.dir';

% ************************
% Stimulus dimensions
% ************************
if ischar(params.stimSize)
    params.radius = pix2angle(params.display,floor(min(params.display.numPixels)/2));
else
    params.radius = params.stimSize;
end

fprintf('[%s]: Stimulus size: %.1f degrees / %d pixels.\n',...
    mfilename,params.radius,angle2pix(params.display,2*params.radius));


% ************************
% Quit key
% ************************

params.quitProgKey          = 'q';
params.display.quitProgKey  = params.quitProgKey;


