function params = setScreenAndFixationParams(expName, params)
% setParams - set parameters for different retinotopy scans 
%
% params = setScreenAndFixationParams([expName], [params])
%
% Sets parameter values for the specified expName.  
%
% params is a struct with at least the following fields:
%  period, numCycles, tr, interleaves, framePeriod, startScan, prescanDuration
%
% Returns the parameter values in the struct params.
%
% 99.08.12 RFD rewrote WAP's code with a cleaner wrapper.
% 05.07.04 SOD ported to OSX; several changes
% 05.2010  JW  moved code into subroutines to imrprove readability

disp(['[' mfilename ']:Setting stimulus parameters for ' expName '.']);

% ************************
% Screen / Calibration
% ************************
params.display = loadDisplayParams('displayName',params.calibration);
fprintf('[%s]:loading calibration from: %s.\n',mfilename,params.calibration);

if max(Screen('screens')) < params.display.screenNumber
    fprintf('[%s]:resetting screenNumber %d -> %d.\n',mfilename,...
        params.display.screenNumber,max(Screen('screens')));
    params.display.screenNumber   = max(Screen('screens'));
end

params.quitProgKey          = 'q';
params.display.quitProgKey  = params.quitProgKey;


% ************************
% Fixation
% ************************
dim.x = params.display.numPixels(1);
dim.y = params.display.numPixels(2);

params.display.fixSizeAngle  = 0.15;
params.display.fixSizePixels = round(angle2pix(params.display,params.display.fixSizeAngle));

params.fix.responseTime       = [.01 3]; % seconds

switch(lower(params.display.fixType))
        
     case {'4 color dot'}
        params.display.fixX = round(dim.x./2);
        params.display.fixY = round(dim.y./2);
        params.display.fixColorRgb  = ...
            [200 0 0 192;
            200 0 0 128;
            0 145 0 192;
            0 145 0 128;
            ];        
        
    case {'disk','double disk'}
        params.display.fixX          = round(dim.x./2);
        params.display.fixY          = round(dim.y./2);        
        params.display.fixColorRgb   = [255 0 0 255; 0 255 0 255]; 
   
    otherwise
        error('Unknown fixationType!');
end

