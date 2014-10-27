function [difd] = ii_diff(chan)
%Differentiate channel
%   Differentiate channel

if nargin ~= 1
    prompt = {'Enter channel:'};
    dlg_title = 'Differentiate';
    num_lines = 1;
    answer = inputdlg(prompt,dlg_title,num_lines);
    chan = answer{1};
end

basevars = evalin('base','who');

if ismember(chan,basevars)
    ichan = evalin('base',chan);
    difd = diff(ichan);
    assignin('base',chan,difd);
    ii_replot;
else
    disp('Channel does not exist')
end
end

