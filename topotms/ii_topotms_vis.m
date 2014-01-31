function ii_topotms_vis()
%II_TOPOTMS_VIS Summary of this function goes here
%   Detailed explanation goes here

% SESSION 1
xp1 = evalin('base', 'Ses01_Pre_X');
yp1 = evalin('base', 'Ses01_Pre_Y');
tarxp1 = evalin('base', 'Ses01_Pre_TarX');
taryp1 = evalin('base', 'Ses01_Pre_TarY');

xt1 = evalin('base', 'Ses01_Post_X');
yt1 = evalin('base', 'Ses01_Post_Y');
tarxt1 = evalin('base', 'Ses01_Post_TarX');
taryt1 = evalin('base', 'Ses01_Post_TarY');

% SESSION 2
xp2 = evalin('base', 'Ses02_Pre_X');
yp2 = evalin('base', 'Ses02_Pre_Y');
tarxp2 = evalin('base', 'Ses02_Pre_TarX');
taryp2 = evalin('base', 'Ses02_Pre_TarY');

xt2 = evalin('base', 'Ses02_Post_X');
yt2 = evalin('base', 'Ses02_Post_Y');
tarxt2 = evalin('base', 'Ses02_Post_TarX');
taryt2 = evalin('base', 'Ses02_Post_TarY');

% DEFINE HEMIFIELDS SESSION 1
p1right = tarxp1 > 0;
p1left = tarxp1 < 0;
t1right = tarxt1 > 0;
t1left = tarxt1 < 0;

% DEFINE HEMIFIELDS SESSION 2
p2right = tarxp2 > 0;
p2left = tarxp2 < 0;
t2right = tarxt2 > 0;
t2left = tarxt2 < 0;

%%%%%%%%%%%%%
% SESSION 1 %
%%%%%%%%%%%%%

% SESSION 1 PRE TMS RIGHT
% Create figure
figure('Name','Session 1 PreTMS Right Hemifield','NumberTitle','off')

% Plot axes lines
xax = plot ([-5 5],[0 0]);
set(xax, 'Color', 'k', 'LineStyle', '--')
hold on
yax = plot ([0 0],[-5 5]);
set(yax, 'Color', 'k', 'LineStyle', '--')
axis tight;
axis equal;

% Plot results
plot(xp1(p1right) - tarxp1(p1right), yp1(p1right)-taryp1(p1right), 'ko');
plotv([xp1(p1right)- tarxp1(p1right), yp1(p1right)-taryp1(p1right)]','--')

% SESSION 1 PRE TMS LEFT
% Create figure
figure('Name','Session 1 PreTMS Left Hemifield','NumberTitle','off')

% Plot axes lines
xax = plot ([-5 5],[0 0]);
set(xax, 'Color', 'k', 'LineStyle', '--')
hold on
yax = plot ([0 0],[-5 5]);
set(yax, 'Color', 'k', 'LineStyle', '--')
axis tight;
axis equal;

% Plot results
plot(xp1(p1left) - tarxp1(p1left), yp1(p1left)-taryp1(p1left), 'ko');
plotv([xp1(p1left)- tarxp1(p1left), yp1(p1left)-taryp1(p1left)]','--')

% SESSION 1 POST TMS RIGHT
% Create figure
figure('Name','Session 1 PostTMS Right Hemifield','NumberTitle','off')

% Plot axes lines
xax = plot ([-5 5],[0 0]);
set(xax, 'Color', 'k', 'LineStyle', '--')
hold on
yax = plot ([0 0],[-5 5]);
set(yax, 'Color', 'k', 'LineStyle', '--')
axis tight;
axis equal;

% Plot results
plot(xt1(t1right) - tarxt1(t1right), yt1(t1right)-taryt1(t1right), 'ko');
plotv([xt1(t1right)- tarxt1(t1right), yt1(t1right)-taryt1(t1right)]','--')

% SESSION 1 POST TMS LEFT
% Create figure
figure('Name','Session 1 PostTMS Left Hemifield','NumberTitle','off')

% Plot axes lines
xax = plot ([-5 5],[0 0]);
set(xax, 'Color', 'k', 'LineStyle', '--')
hold on
yax = plot ([0 0],[-5 5]);
set(yax, 'Color', 'k', 'LineStyle', '--')
axis tight;
axis equal;

% Plot results
plot(xt1(t1left) - tarxt1(t1left), yt1(t1left)-taryt1(t1left), 'ko');
plotv([xt1(t1left)- tarxt1(t1left), yt1(t1left)-taryt1(t1left)]','--')


%%%%%%%%%%%%%
% SESSION 2 %
%%%%%%%%%%%%%

% SESSION 2 PRE TMS RIGHT
% Create figure
figure('Name','Session 2 PreTMS Right Hemifield','NumberTitle','off')

% Plot axes lines
xax = plot ([-5 5],[0 0]);
set(xax, 'Color', 'k', 'LineStyle', '--')
hold on
yax = plot ([0 0],[-5 5]);
set(yax, 'Color', 'k', 'LineStyle', '--')
axis tight;
axis equal;

% Plot results
plot(xp2(p2right) - tarxp2(p2right), yp2(p2right)-taryp2(p2right), 'ko');
plotv([xp2(p2right)- tarxp2(p2right), yp2(p2right)-taryp2(p2right)]','--')

% SESSION 2 PRE TMS LEFT
% Create figure
figure('Name','Session 2 PreTMS Left Hemifield','NumberTitle','off')

% Plot axes lines
xax = plot ([-5 5],[0 0]);
set(xax, 'Color', 'k', 'LineStyle', '--')
hold on
yax = plot ([0 0],[-5 5]);
set(yax, 'Color', 'k', 'LineStyle', '--')
axis tight;
axis equal;

% Plot results
plot(xp2(p2left) - tarxp2(p2left), yp2(p2left)-taryp2(p2left), 'ko');
plotv([xp2(p2left)- tarxp2(p2left), yp2(p2left)-taryp2(p2left)]','--')

% SESSION 2 POST TMS RIGHT
% Create figure
figure('Name','Session 2 PostTMS Right Hemifield','NumberTitle','off')

% Plot axes lines
xax = plot ([-5 5],[0 0]);
set(xax, 'Color', 'k', 'LineStyle', '--')
hold on
yax = plot ([0 0],[-5 5]);
set(yax, 'Color', 'k', 'LineStyle', '--')
axis tight;
axis equal;

% Plot results
plot(xt2(t2right) - tarxt2(t2right), yt2(t2right)-taryt2(t2right), 'ko');
plotv([xt2(t2right)- tarxt2(t2right), yt2(t2right)-taryt2(t2right)]','--')

% SESSION 2 POST TMS LEFT
% Create figure
figure('Name','Session 2 PostTMS Left Hemifield','NumberTitle','off')

% Plot axes lines
xax = plot ([-5 5],[0 0]);
set(xax, 'Color', 'k', 'LineStyle', '--')
hold on
yax = plot ([0 0],[-5 5]);
set(yax, 'Color', 'k', 'LineStyle', '--')
axis tight;
axis equal;

% Plot results
plot(xt2(t2left) - tarxt2(t2left), yt2(t2left)-taryt2(t2left), 'ko');
plotv([xt2(t2left)- tarxt2(t2left), yt2(t2left)-taryt2(t2left)]','--')

end
