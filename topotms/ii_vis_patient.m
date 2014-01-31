function ii_vis_patient()
%II_VIS_PATIENT Summary of this function goes here
%   Detailed explanation goes here

rX = evalin('base', 'rX');
rY = evalin('base', 'rY');
lX = evalin('base', 'lX');
lY = evalin('base', 'lY');

% Create figure
figure('Name','Right Hemifield','NumberTitle','off')

% Plot axes lines
xax = plot ([-5 5],[0 0]);
set(xax, 'Color', 'k', 'LineStyle', '--')
hold on
yax = plot ([0 0],[-5 5]);
set(yax, 'Color', 'k', 'LineStyle', '--')
axis tight;
axis equal;

% Plot results
plot(rX,rY, 'ro');
plotv([rX, rY]','--')

% Create figure
figure('Name','Left Hemifield','NumberTitle','off')

% Plot axes lines
xax = plot ([-5 5],[0 0]);
set(xax, 'Color', 'k', 'LineStyle', '--')
hold on
yax = plot ([0 0],[-5 5]);
set(yax, 'Color', 'k', 'LineStyle', '--')
axis tight;
axis equal;

% Plot results
plot(lX, lY, 'ro');
plotv([lX, lY]','--')
end

