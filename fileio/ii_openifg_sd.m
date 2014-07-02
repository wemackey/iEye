function [nchan,lchan,schan,cfg] = ii_openifg_sd(filename,pathname)
%II_OPENIFG Summary of this function goes here
%   Detailed explanation goes here
if nargin ~= 1
%     [filename, pathname] = uigetfile('*.ifg', 'Select *.ifg file');
    
    if isequal(filename,0)
        disp('User selected Cancel');
    else
        disp(['User selected', fullfile(pathname, filename)]);
        fil = fullfile(pathname, filename);
    end
end

str = fopen(fil);
cfg = fil;

C = textscan(str,'%s');
nchan = C{1}{1};
lchan = C{1}{2};
schan = C{1}{3};

end

