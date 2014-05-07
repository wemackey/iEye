function ii_mACC(run)
%II_MACC Summary of this function goes here
%   Detailed explanation goes here

% cursel = evalin('base','cursel');
% x = evalin('base','X');
% y = evalin('base','Y');
% tACCx = evalin('base','tACCx');
% tACCy = evalin('base','tACCy');
%
% mACCx = [ ];
% mACCy = [ ];
%
% numt = size(cursel,1);
% disp(numt);
%
% for g = 1:numt
%     sel = x*0;
%     qq = cursel(g,:);
%     rng = qq(2) - qq(1);
%     selstrt = qq(1);
%     selend = qq(2);
%
%     for z=1:rng
%         sel(selstrt:selend) = 1;
%     end
%
%     mACCx(g,1) = mean(x(sel==1));
%     mACCy(g,1) = mean(y(sel==1));
% end
%
% % error
% ACCx = tACCx - mACCx;
% ACCy = tACCy - mACCy;
% z = (ACCx.^2) + (ACCy.^2);
% ACCz = sqrt(z);
%
% % gain
% Gx = (tACCx+ACCx)./tACCx;
% Gy = (tACCy+ACCy)./tACCy;
% z = (Gx.^2) + (Gy.^2);
% Gz = sqrt(z);
%
% A1 = mean(ACCz(quad==1));
% A2 = mean(ACCz(quad==2));
% A3 = mean(ACCz(quad==3));
% A4 = mean(ACCz(quad==4));
%
% putvar(mACCx,mACCy,ACCx,ACCy,ACCz,Gx,Gy,Gz,A1,A2,A3,A4)

if nargin ~= 1
    prompt = {'Subject Run #'};
    dlg_title = 'Subject Run #';
    num_lines = 1;
    answer = inputdlg(prompt,dlg_title,num_lines);
    run = str2num(answer{1});
end

x = evalin('base','X');
y = evalin('base','Y');
tarx = evalin('base','TarX');
tary = evalin('base','TarY');
cursel = evalin('base','cursel');
sel = evalin('base','sel');
ACCx = evalin('base','ACCx');
ACCy = evalin('base','ACCy');

nsel = size(cursel);

if nsel(1) == 90
    for g = 1:nsel
        sel = x*0;
        qq = cursel(g,:);
        rng = qq(2) - qq(1);
        selstrt = qq(1);
        selend = qq(2);
        
        for z=1:rng
            sel(selstrt:selend) = 1;
        end
        ACCx(g,run) = mean(x(sel==1));
        ACCy(g,run) = mean(y(sel==1));
        
        putvar(ACCx,ACCy)
    end
else
    disp('Not enough selections');
end


end

