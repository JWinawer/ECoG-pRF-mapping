function  params = retSetDerivedParams(params)
% params = retSetDerivedParams(params)
%
% April, 2010, JW: Split off from setRetinotopyParameters

% ************************
% Fixation dimensions
% ************************
params.fix.task               = 'Detect fixation change';
params.fix.colorRgb           = params.display.fixColorRgb;
params.fix.responseTime       = [.01 3]; % seconds

return