function [output, t0] = deviceUMC(command,port)
% deviceUMC - read UMC scanner trigger and subject response box
%
% [output, t0] = deviceUMC(command)
%
% commands: 'open'  - opens the communication line
%           'check' - open, report on and close all available ports
%                     useful for finding your device port
%           'read'  - read all that came in (and flush)
%                     output = read, t0 = time of reading.
%           'trigger' - binary output whether trigger occurred (flush
%                       everything else)
%                       output = boolean, t0 = time of trigger.
%           'wait for trigger' - wait untill trigger is recieved before
%                                continuing
%           'button' - buttons that were pushed (all, triggers are flushed)
%                      output = buttons, t0 = time of reading.
%                      (idem: 'response')
%           'close'  - close the communication line
% port:     device port to be checked (see /dev/cu.*)
%           A negative device port does not check serial device but will
%           check the internal keyboard instead. This is useful for the
%           avoiding the command 'wait for trigger' and 'response' etc, 
%           during testing of the stimulus without the serial device.
%
% Device button-to-number configuration:
%     [65]
% [66]    [67]
%     [68]
%      |
%      |
%      V
%     wire
%
% MR trigger = 49
%
% 2009/05 SOD: wrote it as a wrapper for the UMC device using comm.m serial
%              port interface by Tom Davis (http://www.mathworks.com/matlabcentral/fileexchange/4952).
% 2009/11 BMH & SOD: rewrote wrapper for intel mac, using Tom Davis' other
%              function, SerialComm, which is now integrated into matlab.
%              Commands for SerialComm are the same as for comm.
%              Inserted switch for intel macs to choose the right port (2)
%              or port 3 for G4 macs

% default


% %THIS PART DEPENDS ON YOUR COMPUTER
% if ~exist('port','var') || isempty(port) || port==2
%     if strcmp(computer('arch'), 'maci64')
%         port = '/dev/cu.KeySerial1'; % for macbook pro
%     else
%         port = 3; % for G4 powerbook
%     end
% end

% parameters
id.device = port;
id.trigger = 49;
id.response = 65:68;

% for testing and debugging without UMC device (needs psychtoolbox)
if port<0
    [output, t0]=keyboardCheck(command);
%     if ismember(button, id.response)
%         output=button;
%     end
    return
end

% initiate output
output = [];
t0 = [];

% execute command
switch(lower(command))
    case {'check'} % useful for finding your device id/port
        ndevices = dir('/dev/cu.*');
        for n=1:numel(ndevices)
            fprintf(1,'[%s]:Probing device %d: ',mfilename,n);
            try
                deviceUMC('open',n);
                deviceUMC('close',n);
            catch ME
                rethrow(ME);
            end
        end

    case {'open','start'}
        fprintf(1,'[%s]:Opening device %d: ',mfilename,id.device);
        portSettings='BaudRate=9600 InputBufferSize=8';% Terminator=1';
        output=IOPort('OpenSerialPort',id.device, portSettings);%,'9600,n,8,1');

    case {'read'}
        output = IOPort('Read',id.device);

    case {'trigger'}
        t = IOPort('Read',id.device);
        if ~isempty(t) && any(t==id.trigger)
            output = true;
            t0 = GetSecs;
        end

    case {'waitfortrigger','wait for trigger'}
        % load mex file for more accuracy
        GetSecs;
        % keep checking for trigger while also releasing some CPU
        while(1)
            t = IOPort('Read',id.device);
            if ~isempty(t) && any(t==id.trigger)
                output = true;
                t0 = GetSecs;
                break;
            else
                % give some time back to OS
                WaitSecs(0.01);
            end
        end

    case {'button','response','responses'}
        % everything that is not a trigger
        t = IOPort('Read',id.device);
        if ~isempty(t)
            t = t(t~=id.trigger);
            output = t;
            t0 = GetSecs;
        end
        
    case {'response_and_trigger','r_and_t'}
        output = [0 0];
        t = IOPort('Read',id.device);
        if ~isempty(t) 
            ii = t==id.trigger;
            t = t(~ii);
            if ~isempty(t), output(1) = t(1); end;            
            output(2) = any(ii);
            t0 = GetSecs;
        end
        

    case {'close'}
        fprintf(1,'[%s]:Closing device %d.\n',mfilename,id.device);
        IOPort('CloseAll');%,id.device);

    otherwise
        error('[%s]:Unknown command %s',mfilename,lower(command));
end

if isempty(output)
    output = false;
end

return
%------------------------------------------

%------------------------------------------
function [output, t0, button]=keyboardCheck(command)
% simulate device output

switch(lower(command))
    case {'read','trigger','button','response','responses'}
        [output, t0, button] = KbCheck;
       
    case {'response_and_trigger'}
        output = [0 0];
        [output(1), t0] = KbCheck;

    case {'waitfortrigger','wait for trigger'}
        while(1)
            [output, t0] = KbCheck;
            if output
                break;
            else
                % give some time back to OS
                WaitSecs(0.01);
            end
        end

    otherwise
        output = [];
        t0 = [];
        % do nothing

end

return
%------------------------------------------


