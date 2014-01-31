function ii_scorem()
%Score Memory-Guided TopoTMS data
%   This function creates a velocity channel, calibrates x and y, and
%   automatically makes SRT selections and stores the SRT calculations in
%   SRTm variable the workspace. It then makes XDAT selections and leaves
%   you to make primary and secondary saccade selections.YOU MUST THEN RUN
%   "ii_scoremcontinue" to complete the ACCm calculations and store them in
%   the workspace.

x = evalin('base','X');
y = evalin('base','Y');

% ii_velocity('x','y');

ii_selectbyvalue('XDAT',1,5);
ii_selectstretch(-400,-100);
ii_calibrateto('X','TarX',3);
ii_calibrateto('Y','TarY',3);

% ii_selectempty;

% ii_selectbyvalue('xdat',1,4);
% ii_selectstretch(0,-750);
% ii_selectuntil('vel',4,2,.2);

cursel = evalin('base','cursel');
% SRTm = cursel(:,2) - cursel(:,1);
% putvar(SRTm)

% [filename, pathname] = uiputfile('*.txt', 'Select ASCII txt file');

% if isequal(filename,0)
%    disp('User selected Cancel');
% else
%    disp(['User selected', fullfile(pathname, filename)]);
%    fil = fullfile(pathname, filename);

%    dlmwrite(fil, SRTm, 'delimiter', '\t', 'precision', '%.2f');
% end

ii_selectempty;

ii_selectbyvalue('XDAT',1,5);
ii_selectstretch(-400,-100);
ii_quadrant;

numt = size(cursel,1);
disp(numt);

for g = 1:numt
    sel = x*0;
    qq = cursel(g,:);
    rng = qq(2) - qq(1);
    selstrt = qq(1);
    selend = qq(2);
    
    for z=1:rng
        sel(selstrt:selend) = 1;
    end
    
    tACCx(g,1) = mean(x(sel==1));
    tACCy(g,1) = mean(y(sel==1));
end

putvar(tACCx,tACCy);

ii_selectempty;
disp('Make primary and secondary saccade selections')

end

