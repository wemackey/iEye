function ii_preprocm()
%II_PREPROCM Summary of this function goes here
%   Detailed explanation goes here

ii_invert('Y');

ii_blinkcorrect('X','Pupil',0,25,25);
ii_blinkcorrect('Y','Pupil',0,25,25);

ii_smooth('X','moving',10);
ii_smooth('Y','moving',10);

ii_autoscale('X','TarX');
ii_autoscale('Y','TarY');

ii_selectbyvalue('TarX',2,0);
ii_selectstretch(-400,0);

ii_selecthold;

ii_selectbyvalue('XDAT',1,1);
ii_selectstretch(-250,-250);

ii_selectmerge;

ii_calibrateto('X','TarX',3);
ii_calibrateto('Y','TarY',3);

end

