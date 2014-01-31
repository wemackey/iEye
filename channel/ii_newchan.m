function ii_newchan(chan, chancopy)
%New Channel
%   This command creates a new channel in the base workspace by copying an
%   existing channel

if nargin ~= 2
    prompt = {'New channel:', 'As copy of:'};
    dlg_title = 'New Channel';
    num_lines = 1;
    answer = inputdlg(prompt,dlg_title,num_lines);
    chan = answer{1};
    chancopy = answer{2};
end

basevars = evalin('base','who');

if ismember(chancopy,basevars)
    cc = evalin('base',chancopy);
    assignin('base',chan,cc);
else
    disp('Channel does not exist')
end
end

