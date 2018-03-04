function drawFixation(params, colIndex)
%
% drawFixation(params, [colIndex=1])
%
% Draws the fixation point specified in the display struct.
%
% HISTORY:
% 2005.02.23 RFD: wrote it.
% 2005.06.29 SOD: added colIndex for fixation dot task
%                 added largeCrosses options
% 2008.05.11 JW:  added 'dot and 'none' options 
%                 added 'lateraldots'

if nargin < 2, colIndex = 1; end

d = params.display;

switch lower(params.fixation)
    case 'none'
        %do nothing
 
    case  {'disk' '4 color dot'}
        % fixSizePixels is the disk radius
        Screen('glPoint', d.windowPtr, d.fixColorRgb(colIndex,:), d.fixX, d.fixY, d.fixSizePixels);
                    
    case 'cross'      
        % fixCoords are the points defining the two lines of the cross
        % fixSizePixels is the thickness of the two lines defining cross
        Screen('DrawDots', d.windowPtr, d.fixCoords, d.fixSizePixels, d.fixColorRgb(colIndex,:));
             
    otherwise
        error('Unknown fixationType!');
end
return