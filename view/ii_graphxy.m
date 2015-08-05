function ii_graphxy()
%II_GRAPHXY Summary of this function goes here
%   Detailed explanation goes here
x = evalin('base', 'X');
y = evalin('base', 'Y');
tarx = evalin('base', 'TarX');
tary = evalin('base', 'TarY');

figure;
plot(x,y,'LineStyle', ':');
hold all
plot(tarx,tary, '*');

legend({'XY','TarXY'},'Location', 'Southeast', 'Orientation', 'Horizontal');
end

