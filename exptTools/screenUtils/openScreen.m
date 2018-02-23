function displayID = openScreen(displayID, hideCursorFlag)
% openScreen - open screen for psychtoolbox
% 
% Usage: displayID = openScreen(displayID, [hideCursorFlag=true])
% 
% openScreen takes a displayID structure (e.g., from running
% loadDisplayParams), and does the following:
% 1. opens a PTB window with a background color (defaults to 1/2 of
% maxRgbValue) (using Screen in PTB)
% 2. draws a fixation dot (using drawFixation in exptTools)
% 3. hides the cursor
% 4. store the original gamma table in the displayID structure
% 
% After you are done with the opened PTB window, use closeScreen to revert
% back to the original state.
% 
% History:
% ##/##/## rfd & sod wrote it.
% 04/12/06 shc (shcheung@stanford.edu) cleaned it and added the help
% comments.

frameRate = displayID.frameRate;

if(~exist('hideCursorFlag','var')||isempty(hideCursorFlag))
    hideCursorFlag = true;
end

displayID.oldGamma = Screen('ReadNormalizedGammaTable', displayID.screenNumber);

Screen('LoadNormalizedGammaTable', displayID.screenNumber,displayID.gamma);

% Force the resolution indicated in the display parameter file.  Let the
% user know if this fails, storing the actual resolution and hz within
% displayID and proceeding.
try
    % First try to set spatial resolution, then spatial and temporal. We
    % try this sequentially because if we fail to set the correct temporal
    % resolution, we would still like to get the screen size right.
    Screen('Resolution', displayID.screenNumber, displayID.numPixels(1), displayID.numPixels(2));
    Screen('Resolution', displayID.screenNumber, displayID.numPixels(1), displayID.numPixels(2), displayID.frameRate);
catch ME
    warning(ME.identifier, ME.message)
end

params = Screen('Resolution', displayID.screenNumber);
if (params.width~=displayID.numPixels(1) || params.height~=displayID.numPixels(2) || params.hz~=displayID.frameRate)
  
    displayID.numPixels     = [params.width params.height];
    displayID.frameRate     = params.hz;

    beep;
    disp('WARNING: Failed to set indicated resolution and refresh rate.');
    disp('Saving current resolution and refresh rate to display structure...');
else
    disp('Resolution and refresh rate successfully set.');
end
        
% Open the screen and save the window pointer and rect
numBuffers = 2;
[displayID.windowPtr,displayID.rect] = Screen('OpenWindow',displayID.screenNumber,...
    displayID.backColorRgb, [], displayID.bitsPerPixel, numBuffers);
        

if hideCursorFlag, HideCursor; end

if ~(displayID.frameRate > 0), displayID.frameRate = frameRate; end

return;