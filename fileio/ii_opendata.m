function ii_opendata(data_file)
%ii_opendata Summary of this function goes here
%   Detailed explanation goes here

if nargin ~= 1
    [filename, pathname] = uigetfile('*.mat', 'Select data file');
    data_file = fullfile(pathname, filename);
end

if isequal(filename,0)
    disp('User selected Cancel');
else
    % Import the file
    newData1 = load('-mat', data_file);
    
    % Create new variables in the base workspace from those fields.
    vars = fieldnames(newData1);
    for i = 1:length(vars)
        assignin('base', vars{i}, newData1.(vars{i}));
    end
    
    ii_replot;
end
end
