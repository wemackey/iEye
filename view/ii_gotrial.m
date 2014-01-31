function ii_gotrial(newt)
%II_GOTRIAL Summary of this function goes here
%   Detailed explanation goes here

if nargin ~= 1
    prompt = {'Enter trial #:'};
    dlg_title = 'Go To Trial #';
    num_lines = 1;
    answer = inputdlg(prompt,dlg_title,num_lines);
    newt = str2num(answer{1});
end

ii_cfg = evalin('base', 'ii_cfg');
tcursel = ii_cfg.tcursel;
tindex = ii_cfg.tindex;
numt = size(tcursel,1);

if newt <= numt && newt > 0
    axis manual
    ii_trialplot(newt);
    axis auto
    ii_showselections;
else
    disp('Trial does not exist')
end

end

