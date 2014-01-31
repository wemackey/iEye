function [ difd ] = ii_diff( chan )
%II_DIFF Summary of this function goes here
%   Detailed explanation goes here

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

