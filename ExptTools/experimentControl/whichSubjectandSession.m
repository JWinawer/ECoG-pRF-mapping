function [subjID, sessionID, ssDefined] = bairWhichSubjectandSession

prompt = {'Enter subject ID', 'Enter session number'};
defaults = {'test', '01'};
[answer] = inputdlg(prompt, 'Subject and Session Number', 1, defaults);

if ~isempty(answer)
    subjID = answer{1,:};
    sessionID = answer{2,:};
    ssDefined = 1;
else
    subjID = [];
    sessionID = [];
    ssDefined = 0;
end

end
