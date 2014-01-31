function ii_scorev()
%II_SCOREV Summary of this function goes here
%   Detailed explanation goes here

ii_getgo('X');

t_go = evalin('base','t_go');

ii_selectbyvalue('t_go',4,0.1);
ii_selectstretch(200,0);
ii_calibrateto('X','TarX',3);
ii_calibrateto('Y','TarY',3);

ii_selectempty;

ii_selectbyvalue('t_go',4,0.1);
ii_selectuntil('vel',4,2,.3);

cursel = evalin('base','cursel');
SRTv = cursel(:,2) - cursel(:,1);
putvar(SRTv);

%[filename, pathname] = uiputfile('*.txt', 'Select ASCII txt file');

%if isequal(filename,0)
%   disp('User selected Cancel');
%else
%   disp(['User selected', fullfile(pathname, filename)]);
%   fil = fullfile(pathname, filename);

%   dlmwrite(fil, SRTm, 'delimiter', '\t', 'precision', '%.2f');
%end


disp('Make primary and secondary saccade selections')
end

