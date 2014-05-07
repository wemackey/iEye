function ii_view_topotms()
%II_VIEW_TOPOTMS Summary of this function goes here
%   Detailed explanation goes here

x = evalin('base', 'fX');
y = evalin('base', 'fY');
tarx = evalin('base', 'tX');
tary = evalin('base', 'tY');

figure;
%plot(x(1,:),y(1,:),'--ks','MarkerFaceColor','g', 'MarkerEdgeColor', 'g', 'MarkerSize',10);
%plot(x,y,'--ks','MarkerFaceColor','g', 'MarkerEdgeColor', 'g', 'MarkerSize',10);
plot(x(1,:),y(1,:),'--ks','MarkerFaceColor','g', 'MarkerEdgeColor', 'g', 'MarkerSize',10);
plot(x(2,:),y(2,:),'--ks','MarkerFaceColor','g', 'MarkerEdgeColor', 'g', 'MarkerSize',10);
plot(x(3,:),y(3,:),'--ks','MarkerFaceColor','g', 'MarkerEdgeColor', 'g', 'MarkerSize',10);


hold all
%plot(tarx(1,:),tary(1,:),'--ks','MarkerFaceColor','b', 'MarkerEdgeColor', 'b', 'MarkerSize',10);
%plot(tarx,tary,'--ks','MarkerFaceColor','b', 'MarkerEdgeColor', 'b', 'MarkerSize',10);
plot(tarx(1,:),tary(1,:),'--ks','MarkerFaceColor','b', 'MarkerEdgeColor', 'b', 'MarkerSize',10);
plot(tarx(2,:),tary(2,:),'--ks','MarkerFaceColor','b', 'MarkerEdgeColor', 'b', 'MarkerSize',10);
plot(tarx(3,:),tary(3,:),'--ks','MarkerFaceColor','b', 'MarkerEdgeColor', 'b', 'MarkerSize',10);

end

