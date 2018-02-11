function params = ret(params)
% [params] = ret(params)
%
% ret - program to start retinotopic mapping experiments (under OSX)
%     params:  input argument to specify experiment parameters.
%
% Example:
%   
%   params = retCreateDefaultGUIParams
%   % modify fields as you like, e.g.
%   params.fixation = 'dot';
%   ret(params)


% now set rest of the params
params = setRetinotopyParams(params.experiment, params);

% go
doRetinotopyScan(params);
