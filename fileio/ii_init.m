function ii_init()
% initializes path for ii_import_edf
% TCS for GH 8/25/2016
%
% TODO: have a settings file or equivalent for location of edf2asc?
% TODO: somehow do an automatic git pull from master at init?

path1 = getenv('PATH');
path1 = [path1 ':/Volumes/hyper/spacebin'];
setenv('PATH', path1);
clear path1;

return