function ii_i2d_update(X,Y)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
xl = evalin('base', 'X');
yl = evalin('base', 'Y');
i2f = get(i2d,'CurrentAxes');
axes(i2f);
%cla;
plot(X,Y);

title('2D Spatial Plot')
xlabel('X Position')
ylabel('Y Position')
axis([min(xl) max(xl) min(yl) max(yl)])

end

