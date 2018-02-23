function params = setScreenParams(params)
% params = setScreenParams(params)
%
% Load and set display parameters

params.display = loadDisplayParams('displayName',params.calibration);
fprintf('[%s]:loading calibration from: %s.\n',mfilename,params.calibration);

if max(Screen('screens')) < params.display.screenNumber
    fprintf('[%s]:resetting screenNumber %d -> %d.\n',mfilename,...
        params.display.screenNumber,max(Screen('screens')));
    params.display.screenNumber   = max(Screen('screens'));
end

params.quitProgKey          = 'q';
params.display.quitProgKey  = params.quitProgKey;

end

