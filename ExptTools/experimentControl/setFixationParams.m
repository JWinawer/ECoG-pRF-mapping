function params = setFixationParams(params, stimulus)
% setParams - set parameters for different retinotopy scans 
%
% params = setFixationParams(params, stimulus)

params.display.fixX = (stimulus.dstRect(1)+stimulus.dstRect(3))/2;
params.display.fixY = (stimulus.dstRect(2)+stimulus.dstRect(4))/2;

params.display.fixSizeAngle  = 0.15;
params.display.fixSizePixels = round(angle2pix(params.display,params.display.fixSizeAngle));

params.fix.responseTime       = [.01 3]; % seconds

switch lower(params.display.fixType)
        
     case {'4 color dot'}
        params.display.fixColorRgb  = ...
            [200 0 0 192;
            200 0 0 128;
            0 145 0 192;
            0 145 0 128;
            ];        
        
    case {'disk','double disk'}
      
        params.display.fixColorRgb   = [255 0 0 255; 0 255 0 255]; 
   
    otherwise
        error('Unknown fixationType!');
end

