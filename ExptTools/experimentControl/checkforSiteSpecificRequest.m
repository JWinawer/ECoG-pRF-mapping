function checkforSiteSpecificRequest(experimentSpecs,whichSite)

switch lower(experimentSpecs.sites{whichSite})
    case 'nyuecog'
        % calibrate display
        NYU_ECOG_Cal();        
        % Check paths
        if isempty(which('PsychtoolboxVersion'))
            error('Please add Psychtoolbox to path before running')
        end
    otherwise
        % for now, do nothing
end

end
