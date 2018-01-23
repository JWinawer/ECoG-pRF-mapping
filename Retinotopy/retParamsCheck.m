function retParamsCheck(params)
% retParamsCheck - sanity checks of parameters
%
% SOD 10/2005: wrote it.

% some checks -- there should be an integer number of temporal frames for
% the start scan countdown, the prescan duration, and the main stimulus
% period.  (I use the 1e-5 threshold, because differences in numeric class 
% may cause tiny roundoff errors which may make things not exactly zero.)
ratio = params.startScan/params.framePeriod;
if abs(ratio - round(ratio)) > 1e-5
	error('start scan period (%.1f) is not an integer multiple of frame period (%.1f)!',...
        params.startScan,params.frameperiod);
end

ratio = params.prescanDuration/params.framePeriod;
if abs(ratio - round(ratio)) > 1e-5
	error('Pre scan period (%.1f) is not an integer multiple of frame period (%.1f)!',...
        params.prescanDuration, params.framePeriod);
end

ratio = params.period/params.framePeriod;
if abs(ratio - round(ratio)) > 1e-5
	error('Scan period (%.1f) is not an integer multiple of frame period (%.1f)!',...
        params.period, params.framePeriod);
end

% priority check
if params.runPriority==0
	bn = questdlg('Warning: runPriority is 0!','warning','OK','Make it 7','Make it 1','OK');
	if strcmp(bn,'Make it 7')
		params.runPriority = 7;
	elseif strcmp(bn, 'Make it 1') 
		params.runPriority = 1;
	end
end


