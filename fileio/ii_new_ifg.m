function ii_new_ifg()
%Create new configuration file
%   Opens a GUI to create a new *.ifg configuration file. This
%   configuration file is used when importing eyetracker files (i.e. *.edf)
%   into iEye/MATLAB

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

