function ii_hemifield(run)
%II_HEMIFIELD Summary of this function goes here
%   Detailed explanation goes here

%%%%%%%%%%%%%%%%%%%
%        |        %
%        |        %
%        |        %
%   1    |    2   %
%        |        %
%        |        %
%        |        %
%%%%%%%%%%%%%%%%%%%

if nargin ~= 1
    prompt = {'Subject Run #'};
    dlg_title = 'Subject Run #';
    num_lines = 1;
    answer = inputdlg(prompt,dlg_title,num_lines);
    run = str2num(answer{1});
end

ii_view_channels('X,Y,TarX,TarY,XDAT')

ii_selectempty;

ii_selectbyvalue('XDAT',1,5);
ii_selectstretch(-400,-100);

sel = evalin('base','sel');
tarx = evalin('base','TarX');
hemis = evalin('base','hemis');

vec_tx = tarx(sel==1);

tx = SplitVec(vec_tx,'equal','firstval');

xpos = find(tx>0);
xneg = find(tx<0);

for i = 1:length(tx)
    if (tx(i) > 0)
        hem(i) = 1;
    else
        hem(i) = 2;
    end
end

hemis(:,run) = hem;
putvar(hem,hemis,xpos,xneg);
end

