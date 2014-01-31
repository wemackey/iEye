function ii_mSRT(run)
%II_MSRT Summary of this function goes here
%   Detailed explanation goes here

if nargin ~= 1
    prompt = {'Subject Run #'};
    dlg_title = 'Subject Run #';
    num_lines = 1;
    answer = inputdlg(prompt,dlg_title,num_lines);
    run = str2num(answer{1});
end
ii_view_channels('X,Y,TarX,TarY,XDAT')

ii_selectempty;

ii_velocity('X','Y');

ii_selectempty;

ii_selectbyvalue('XDAT',1,4);
ii_selectstretch(0,-750);
ii_selectuntil('vel',4,2,.2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RERUN IF SELECTIONS NEEDED CORRECTIONS %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cursel = evalin('base','cursel');
SRTm = evalin('base','SRTm');
SRT = cursel(:,2) - cursel(:,1);
SRTm(:,run) = SRT;

putvar(SRT,SRTm,run);

end


