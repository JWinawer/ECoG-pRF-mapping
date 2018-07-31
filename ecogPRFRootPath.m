function rootPath=ecogPRFRootPath()
% Return the path to the root ECoG-pRF-mapping directory
%
% This function must reside in the directory at the base of the
% ECoG-pRF-mapping directory structure.  It is used to determine the
% location of various sub-directories.
% 
% Example:
%   fullfile(ecogPRFRootPath)

rootPath=which('ecogPRFRootPath');

rootPath=fileparts(rootPath);

return
