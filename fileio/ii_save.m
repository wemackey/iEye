function ii_save(path)
% Save iEye dataset

if nargin ~= 1
    [filename, pathname] = uigetfile('*.mat', 'Select *.mat file');
    
    if isequal(filename,0)
        disp('User selected Cancel');
    else
        disp(['User selected', fullfile(pathname, filename)]);
        path = fullfile(pathname, filename);
    end
end

ii_data = evalin('base','ii_data');
save(path, 'ii_data');

end

