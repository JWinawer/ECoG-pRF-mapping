function params = retSetExperimentParams(params, expName)
%
% expNames = retSetExperimentParams(params, expName)
%
%
% Use this function to set any parameters that are specific to a particular
% kind of retinotopy experiment.
%
% If called with no arguments, return a cell array listing
% all the experiment names that it is configured to do. This call is made
% from retMenu.m. It is a kind of hack, but it is useful to have the list
% of experiment names and the switch statement for experiment in the same
% function, so that if we add a new experiment, we need only modify this
% function:
%
% If a new experiment  is added, then the experiment name must be added
% both to the variable 'expNames' and to the switch / case statement below.
%
% April, 2010, JW: Split off from setRetinotopyParams.
%
%   See also setRetinotopyParams.m  retSetFixationParams.m




return
