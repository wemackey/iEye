function ii_append(c)
%II_APPEND Summary of this function goes here
%   Detailed explanation goes here

basevars = evalin('base','who');
if ismember(c,basevars)
    chan = evalin('base',c);
    [filename, pathname] = uiputfile('*.txt', 'Select ASCII txt file');
    
    if isequal(filename,0)
        disp('User selected Cancel');
    else
        disp(['User selected', fullfile(pathname, filename)]);
        fil = fullfile(pathname, filename);
        
        dlmwrite(fil, chan, 'delimiter', '\t', 'precision', '%.2f','-append');
    end
else
    disp('Channel to calibrate does not exist in worksapce');
end
end

