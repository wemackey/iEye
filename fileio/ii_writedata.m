function ii_writedata(data_file)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

% SAVE FILE
if nargin ~= 1
    [filename, pathname] = uiputfile('*.mat', 'Create data file');
    
    if isequal(filename,0)
        disp('User selected Cancel');
    else
        data_file = fullfile(pathname, filename);
        save(data_file);
    end
else
    save(data_file);
end
end


