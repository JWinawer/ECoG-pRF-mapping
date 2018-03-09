function checkforSiteSpecificRequest(experimentSpecs,whichSite)

switch experimentSpecs.sites{whichSite}
    case 'NYUECOG'
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
