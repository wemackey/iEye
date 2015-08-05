function [abso] = ii_abs(chan)
%Absolute value
%   Take the absolute value of a channel
if nargin ~= 1
    prompt = {'Enter channel:'};
    dlg_title = 'Absolute Value';
    num_lines = 1;
    answer = inputdlg(prompt,dlg_title,num_lines);
    chan = answer{1};
end

basevars = evalin('base','who');

if ismember(chan,basevars)
    ichan = evalin('base',chan);
    abso = abs(ichan);
    assignin('base',chan,abso);
    ii_replot;
    
    dt = datestr(now,'mmmm dd, yyyy HH:MM:SS.FFF AM');
    ii_cfg = evalin('base','ii_cfg');
    ii_cfg.history{end+1,1} = sprintf('Took absolute value of %s on %s', chan, dt);
    putvar(ii_cfg);
else
    disp('Channel does not exist')
end
end

