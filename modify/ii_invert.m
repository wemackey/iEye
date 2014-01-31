function ii_invert(chan)
%II_INVERT Summary of this function goes here
%   Detailed explanation goes here

if nargin ~= 1
    prompt = {'Enter channel to invert:'};
    dlg_title = 'Invert Channel';
    num_lines = 1;
    answer = inputdlg(prompt,dlg_title,num_lines);
    chan = answer{1};
end

basevars = evalin('base','who');

if ismember(chan,basevars)
    ichan = evalin('base',chan);
    ivrt = ichan * -1;
    assignin('base',chan,ivrt);
    ii_replot;
else
    disp('Channel does not exist')
end
end

