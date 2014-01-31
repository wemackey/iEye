function ii_new_ifg()
%II_NEW_IFG Create new configuration file
%   Detailed explanation goes here

prompt = {'# of Channels', 'Channel Names', 'Sampling rate in Hz'};
dlg_title = 'Configuration File';
num_lines = 1;
answer = inputdlg(prompt,dlg_title,num_lines);
nchan = str2num(answer{1});
lchan = answer{2};
schan = str2num(answer{3});

[filename, pathname] = uiputfile('*.ifg', 'Create *.ifg file');

if isequal(filename,0)
    disp('User selected Cancel');
else
    disp(['User selected', fullfile(pathname, filename)]);
    fil = fullfile(pathname, filename);
    
    ii_writefile(fil,nchan,lchan,schan);
end
end

