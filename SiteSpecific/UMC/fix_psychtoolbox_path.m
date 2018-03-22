function fix_psychtoolbox_path
%FIX_PSYCHTOOLBOX_PATH
%
% Function necessary to fix mex errors on windows, i.e. to fix this error:
%
% This mex file seems to be missing or inaccessible on your Matlab path or it is dysfunctional:
% 
%   Screen.mexw64
% 
% It is important that the folder which contains the Screen mex file is located *before*
% the PsychBasic folder on your Matlab path.
% On Matlab V7.4 (R2007a) or later versions, the folder
% C:\Users\subjects\Documents\MATLAB\toolboxes\Psychtoolbox-3\Psychtoolbox\PsychBasic\MatlabWindowsFilesR2007a\ must be before the folder
% C:\Users\subjects\Documents\MATLAB\toolboxes\Psychtoolbox-3\Psychtoolbox\PsychBasic\ 
% 
% type path to display the current path and check for this condition.

PATH = strsplit(path, pathsep);

% index of PsychBasic path
index_basic = find(contains(PATH, 'PsychBasic') & ~contains(PATH, ['PsychBasic' filesep]));
% index of PsychBasic/MatlabWindowsFilesR2007a
index_windows = find(contains(PATH, ['PsychBasic' filesep 'MatlabWindowsFilesR2007a']));

if index_basic < index_windows
    INDEX = 1:length(PATH);
    INDEX(index_basic) = index_windows;
    INDEX(index_windows) = index_basic;

    NEW_PATH = strjoin(PATH(INDEX), pathsep);
    path(NEW_PATH);
end