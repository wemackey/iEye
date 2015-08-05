function ii_replot()
%II_REPLOT Summary of this function goes here
%   Detailed explanation goes here

%ii_hideselections;

hax = get(iEye,'CurrentAxes');
axes(hax);
cla;
set(gca, 'XColor', [0.3 0.3 0.3]);
set(gca, 'YColor', [0.3 0.3 0.3]);
xlabel('Sample','FontSize',10);
ylabel('Value','FontSize',10);
grid on;
cnames = {};

ii_cfg = evalin('base', 'ii_cfg');
vis = ii_cfg.vis;
% schan = ii_cfg.hz;
schan = 1000; %fix later
v = textscan(vis,'%s','delimiter',',');

col = lines(length(v{1}));

for i = 1:length(v{1})
    c = v{1}{i};
    chan = evalin('base', c);
    cnames{end+1} = c;
    tsec = (schan./1000).*size(chan);
    tss = tsec(1);
    css = length(chan);
    tt = linspace(1,tss,css);
    if strcmpi(c,'X') || strcmpi(c,'Y')
        tline = plot(tt,chan,'LineStyle','-','LineWidth',1,'color',col(i,:));
    else
        tline = plot(tt,chan,'LineWidth',1,'color',col(i,:));
    end
    hold all
end

tl = sprintf('Timeseries mode');
title(tl);

hcmenu = uicontextmenu;
hcb1 = ['set(gco, ''Visible'', ''Off'')'];
hcb2 = ['set(gco, ''LineStyle'', '':'')'];
hcb3 = ['set(gco, ''LineStyle'', ''-'')'];
item1 = uimenu(hcmenu, 'Label', 'hide', 'Callback', hcb1);
item2 = uimenu(hcmenu, 'Label', 'dotted', 'Callback', hcb2);
item3 = uimenu(hcmenu, 'Label', 'solid',  'Callback', hcb3);
hlines = findall(hax,'Type','line');

for lineq = 1:length(hlines)
    set(hlines(lineq),'uicontextmenu',hcmenu)
end
axis(hax,'auto')
xlabel('Time in ms')
ylabel('Channel value')

ii_showselections;

ii_showblinks;

legend(cnames,'Location', 'NortheastOutside', 'Orientation', 'Vertical');
keyboardnavigate on;

i2 = findobj('type','figure','name','i2d');
if ~isempty(i2)
    X = evalin('base', 'X');
    Y = evalin('base', 'Y');
    ii_i2d_update(X,Y);
end
end

