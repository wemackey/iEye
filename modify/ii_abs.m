function [ abso ] = ii_abs( chan )
%II_ABS Summary of this function goes here
%   Detailed explanation goes here
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
else
    disp('Channel does not exist')
end

end

