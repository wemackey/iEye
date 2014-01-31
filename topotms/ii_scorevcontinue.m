function ii_scorevcontinue()
%II_SCOREVCONTINUE Summary of this function goes here
%   Detailed explanation goes here

cursel = evalin('base','cursel');
sel = evalin('base','sel');
x = evalin('base','X');
y = evalin('base','Y');

vACCx = [ ];
vACCy = [ ];

numt = size(cursel,1);
disp(numt);

for g = 1:numt
    qq = cursel(g,:);
    rng = qq(2) - qq(1);
    selstrt = qq(1);
    selend = qq(2);
    
    for w = 1:rng
        sm{w,1} = selstrt;
        sm{w,2} = x(selstrt);
        sm{w,3} = y(selstrt);
        selstrt = selstrt + 1;
    end
    
    smm = cell2mat(sm);
    vACCx(g,1) = mean(smm(:,2));
    vACCy(g,1) = mean(smm(:,3));
end

putvar(vACCx, vACCy)

%[filename, pathname] = uiputfile('*.txt', 'Select ASCII txt file');

%if isequal(filename,0)
%   disp('User selected Cancel');
%else
%   disp(['User selected', fullfile(pathname, filename)]);
%   fil = fullfile(pathname, filename);

%   dlmwrite(fil, SRTm, 'delimiter', '\t', 'precision', '%.2f');
%end
end

