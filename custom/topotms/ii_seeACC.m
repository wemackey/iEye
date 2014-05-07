function ii_seeACC()
%II_SEEACC Summary of this function goes here
%   Detailed explanation goes here

x = evalin('base', 'ACCx');
y = evalin('base', 'ACCy');


figure;
% targets
plot(x(3,:),y(3,:),'k*')
hold all
plot(x(6,:),y(6,:),'k*')
plot(x(9,:),y(9,:),'k*')
plot(x(12,:),y(12,:),'k*')
plot(x(15,:),y(15,:),'k*')
plot(x(18,:),y(18,:),'k*')
plot(x(21,:),y(21,:),'k*')
plot(x(24,:),y(24,:),'k*')
plot(x(27,:),y(27,:),'k*')
plot(x(30,:),y(30,:),'k*')
% primary saccade
plot(x(1,:),y(1,:),'ro')
plot(x(4,:),y(4,:),'ro')
plot(x(7,:),y(7,:),'ro')
plot(x(10,:),y(10,:),'ro')
plot(x(13,:),y(13,:),'ro')
plot(x(16,:),y(16,:),'ro')
plot(x(19,:),y(19,:),'ro')
plot(x(22,:),y(22,:),'ro')
plot(x(25,:),y(25,:),'ro')
plot(x(28,:),y(28,:),'ro')
% final saccade
plot(x(2,:),y(2,:),'bo')
plot(x(5,:),y(5,:),'bo')
plot(x(8,:),y(8,:),'bo')
plot(x(11,:),y(11,:),'bo')
plot(x(14,:),y(14,:),'bo')
plot(x(17,:),y(17,:),'bo')
plot(x(20,:),y(20,:),'bo')
plot(x(23,:),y(23,:),'bo')
plot(x(26,:),y(26,:),'bo')
plot(x(29,:),y(29,:),'bo')

axis tight;
end

