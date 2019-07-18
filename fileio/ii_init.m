function ii_init()
% initializes path for ii_import_edf
% TCS for GH 8/25/2016
%
% If no preferences set, loads from CURTIS LAB default.
% NOTE: this WILL NOT work outside Curtis lab.
%
% To set a new default edf2asc path, do:
% setpref('iEye_ts','edf2asc_path','/path/to/your/binary');
%
% TODO: somehow do an automatic git pull from master at init?

if ~ispref('iEye','edf2asc_path')
    edf2asc_path = '/Volumes/hyper/spacebin';
   %edf2asc_path = '/d/DATA/hyper/spacebin';
else
    edf2asc_path = getpref('iEye','edf2asc_path');
end

path1 = getenv('PATH');
%path1 = [path1 ':/Volumes/hyper/spacebin'];
path1 = [path1 ':' edf2asc_path];
setenv('PATH', path1);
clear path1;

return