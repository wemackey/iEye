function ii_scoremcontinue()
%II_SCOREMCONTINUE Summary of this function goes here
%   Detailed explanation goes here

cursel = evalin('base','cursel');
sel = evalin('base','sel');
x = evalin('base','X');
y = evalin('base','Y');
tACCx = evalin('base','tACCx');
tACCy = evalin('base','tACCy');

mACCx = [ ];
mACCy = [ ];

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
    
    mACCx(g,1) = mean(x(sel==1));
    mACCy(g,1) = mean(y(sel==1));
end

% error
ACCx = tACCx - mACCx;
ACCy = tACCy - mACCy;
z = (ACCx.^2) + (ACCy.^2);
ACCz = sqrt(z);

% gain
Gx = mACCx./tACCx;
Gy = mACCy./tACCy;
z = (Gx.^2) + (Gy.^2);
Gz = sqrt(z);

%for i = 1:30
%    t = i*2;
%    a = t - 1;
%    ACCx(i) = mACCx(t) - mACCx(a);
%    ACCy(i) = mACCy(t) - mACCy(a);
%end

%ACCx = ACCx';tACCy
%ACCy = ACCy';

A1 = mean(ACCz(quad==1));
A2 = mean(ACCz(quad==2));
A3 = mean(ACCz(quad==3));
A4 = mean(ACCz(quad==4));

putvar(mACCx,mACCy,ACCx,ACCy,ACCz,A1,A2,A3,A4)

%[filename, pathname] = uiputfile('*.txt', 'Select ASCII txt file');

%if isequal(filename,0)
%   disp('User selected Cancel');
%else
%   disp(['User selected', fullfile(pathname, filename)]);
%   fil = fullfile(pathname, filename);

%   dlmwrite(fil, SRTm, 'delimiter', '\t', 'precision', '%.2f');
%end
end

