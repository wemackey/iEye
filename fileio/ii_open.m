function ii_open(path)
% Open a previously created iEye dataset

if nargin ~= 1
    [filename, pathname] = uigetfile('*.mat', 'Select *.mat file');
    
    if isequal(filename,0)
        disp('User selected Cancel');
    else
        disp(['User selected', fullfile(pathname, filename)]);
        path = fullfile(pathname, filename);
    end
end

fil = load(path, 'ii_data');
ii_data = fil.ii_data;
putvar(ii_data)

end

