function stimulus = createTextures(display, stimulus)
%stimulus = createTextures(display, stimulus);
%
%Replace images within stimulus (stimulus.image) with textures
%(stimulus.textures).
%
%Stimulus can be a 1xn array of stimuli.  It creates the textures
%(like loading in off-screen memory in OS9).
% If the removeImages flag is set to 1 [default value], the code
% destroys the original image field (freeing up the memory and speeding up
% pass-by-copy calls of stimulus). For stimuli with many images, this is
% strongly recommended; however, for a small number of images, the field
% may not slow things too much; setting the flag to 0 keeps the images.
%
%If you're trying to create an texture starting at something
%other than the first image, use addTextures.

%2005/06/09   SOD: ported from createImagePointers
%31102005    fwc:	changed display.screenNumber into display.windowPtr


% number of images
nImages = size(stimulus.images,3);
stimulus.textures = zeros(nImages, 1);

% make textures
for imgNum = 1:nImages
    
    % fwc:	changed display.screenNumber into display.windowPtr
    stimulus.textures(imgNum) = ...
        Screen('MakeTexture',display.windowPtr, ...
        double(squeeze(stimulus.images(:,:,imgNum,:))));
end

% call/load 'DrawTexture' prior to actual use (clears overhead)
Screen('DrawTexture', display.windowPtr, stimulus(1).textures(1), ...
    stimulus(1).srcRect, stimulus(1).dstRect);

return
