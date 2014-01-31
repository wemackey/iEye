function [ sqr ] = ii_square( chan )
%II_SQUARE Summary of this function goes here
%   Detailed explanation goes here

if nargin ~= 1
    prompt = {'Enter channel:'};
    dlg_title = 'Square';
    num_lines = 1;
    answer = inputdlg(prompt,dlg_title,num_lines);
    chan = answer{1};
end

basevars = evalin('base','who');

if ismember(chan,basevars)
    ichan = evalin('base',chan);
    sqr = ichan.*2;
    assignin('base',chan,sqr);
    ii_replot;
else
    disp('Channel does not exist')
end
end

