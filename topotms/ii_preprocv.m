function ii_preprocv()
%II_PREPROCV Summary of this function goes here
%   Detailed explanation goes here

starx = evalin('base','TarX');
stary = evalin('base','TarY');
putvar(starx,stary);

ii_invert('Y');

ii_blinkcorrect('X','Pupil',0,50,50);
ii_blinkcorrect('Y','Pupil',0,50,50);

ii_smooth('X','moving',10);
ii_smooth('Y','moving',10);

ii_getgo('TarX');

ii_shift('starx', 200);
ii_shift('stary', 200);

ii_selectall();

ii_calibrateto('X','starx',3);
ii_calibrateto('Y','stary',3);

ii_velocity('X','Y');

ii_saveiye;

end

