function [getgo] = ii_getgo(chan)
%II_GETGO Summary of this function goes here
%   Detailed explanation goes here

if nargin ~= 1
    prompt = {'Enter channel:'};
    dlg_title = 'Get Trial Start';
    num_lines = 1;
    answer = inputdlg(prompt,dlg_title,num_lines);
    chan = answer{1};
end

basevars = evalin('base','who');

if ismember(chan,basevars)
    ichan = evalin('base',chan);
    getgo = diff(ichan);
    getgo = abs(getgo);
    assignin('base','t_go',getgo);
%     figure;
%     plot(getgo);
else
    disp('Channel does not exist')
end

end

