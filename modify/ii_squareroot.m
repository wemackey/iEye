function [ sqroot ] = ii_squareroot( chan )
%II_SQUAREROOT Summary of this function goes here
%   Detailed explanation goes here

if nargin ~= 1
    prompt = {'Enter channel:'};
    dlg_title = 'Square Root';
    num_lines = 1;
    answer = inputdlg(prompt,dlg_title,num_lines);
    chan = answer{1};
end

basevars = evalin('base','who');

if ismember(chan,basevars)
    ichan = evalin('base',chan);
    ivrt = sqrt(ichan);
    assignin('base',chan,ivrt);
    ii_replot;
else
    disp('Channel does not exist')
end
end

