function ii_replot()
%II_REPLOT Summary of this function goes here
%   Detailed explanation goes here
ii_hideselections;

hax = get(iEye,'CurrentAxes');
axes(hax);
cla;
set(gca, 'XColor', [0.3 0.3 0.3]);
set(gca, 'YColor', [0.3 0.3 0.3]);
xlabel('Time (in milliseconds)','FontSize',10);
ylabel('Value','FontSize',10);
grid on;
cnames = {};

ii_cfg = evalin('base', 'ii_cfg');
vis = ii_cfg.vis;
schan = ii_cfg.hz;
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
    tline = plot(tt,chan,'color',col(i,:));
    hold all
end

% Define a context menu; it is not attached to anything
hcmenu = uicontextmenu;
% Define callbacks for context menu items that change linestyle
hcb1 = ['set(gco, ''Visible'', ''Off'')'];
hcb2 = ['set(gco, ''LineStyle'', '':'')'];
hcb3 = ['set(gco, ''LineStyle'', ''-'')'];
% Define the context menu items and install their callbacks
item1 = uimenu(hcmenu, 'Label', 'hide', 'Callback', hcb1);
item2 = uimenu(hcmenu, 'Label', 'dotted', 'Callback', hcb2);
item3 = uimenu(hcmenu, 'Label', 'solid',  'Callback', hcb3);
% Locate line objects
hlines = findall(hax,'Type','line');
% Attach the context menu to each line
for line = 1:length(hlines)
    set(hlines(line),'uicontextmenu',hcmenu)
end
axis(hax,'auto')
ii_showselections;
ii_showblinks;

legend(cnames,'Location', 'NortheastOutside', 'Orientation', 'Vertical');
keyboardnavigate on;
end

