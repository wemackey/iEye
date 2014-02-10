function ii_iyefix(x)
%II_IYEFIX Summary of this function goes here
%   Detailed explanation goes here

cfg = evalin('base','cfg');
vis = evalin('base','vis');
x = evalin('base',x);
dt = datestr(now,'mmmm dd, yyyy HH:MM:SS.FFF AM');

ii_cfg.cursel = [];
ii_cfg.sel = x*0;
ii_cfg.cfg = cfg;
ii_cfg.vis = vis;
ii_cfg.nchan = 6;
ii_cfg.lchan = 'X,Y,Pupil,XDAT,TarX,TarY';
ii_cfg.hz = 1000;
ii_cfg.blink = [];
ii_cfg.velocity = [];
ii_cfg.tcursel = [];
ii_cfg.tsel = x*0;
ii_cfg.tindex = 0;
ii_cfg.saccades = [];
ii_cfg.history{1} = ['EDF imported ', dt];

putvar(ii_cfg);

clear cursel
clear sel
clear cfg
clear vis

end

