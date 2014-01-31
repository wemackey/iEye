function ii_deletechan(chan)
%Delete Channel
%   This command will delete a particular channel from the base workspace.

if nargin ~= 1
    prompt = {'Enter channel:'};
    dlg_title = 'Delete Channel';
    num_lines = 1;
    answer = inputdlg(prompt,dlg_title,num_lines);
    chan = answer{1};
end

basevars = evalin('base','who');

if ismember(chan,basevars)
    evalin('caller',['clear ',chan])
else
    disp('Channel does not exist')
end
end

