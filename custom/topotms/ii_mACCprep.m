function ii_mACCprep()
%II_MACCPREP Summary of this function goes here
%   Detailed explanation goes here


ii_view_channels('X,Y,TarX,TarY,XDAT')

x = evalin('base','X');
y = evalin('base','Y');
tarx = evalin('base','TarX');
tary = evalin('base','TarY');

% ii_velocity('x','y');

ii_selectbyvalue('XDAT',1,5);
ii_selectstretch(-400,-100);
ii_calibrateto('X','TarX',3);
ii_calibrateto('Y','TarY',3);

ii_selectempty;

ii_selectbyvalue('XDAT',1,5);
ii_selectstretch(-400,-100);
end

