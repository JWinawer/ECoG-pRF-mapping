% For the NYU ECoG site, we may want to calibrate the display for each
% patient, since the ambient illumination varies from room to room.

% Calibrate display?
prompt = {'y/n'};
defaults = {'n'};
answer = inputdlg(prompt, 'Calibrate display?', 1, defaults);
if strcmpi(answer, 'y')
    numMeasures = 17; % ideally, 2^n+1 acc to PTB
    gammaTable1 = nyuCalibrateMonitorPhotometer(numMeasures, 0);
    
    % use gammaTable 1, which is the powerlaw fit to the measurements
    g = gammaTable1;
    
    % replicate to 256 x 3 for RGB (asqqqqsuming 8 bits)
    gamma = [g g g];
    
    % integers for lookup table
    gammaTable = round(gamma * 255);
    
    % where to save?
    pth = fullfile(getDisplayPath, 'SoMMacBook', sprintf('gamma_%s', datestr(now, 30)));
    save(pth, 'gamma', 'gammaTable');
    pth = fullfile(getDisplayPath, 'SoMMacBook', 'gamma');
    save(pth, 'gamma', 'gammaTable');
else
    disp('Not calibrating...')
end