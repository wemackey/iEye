function ii_trialplot(tindex)
%II_TRIALPLOT Summary of this function goes here
%   Detailed explanation goes here
ii_cfg = evalin('base', 'ii_cfg');
tcursel = ii_cfg.tcursel;
numt = size(tcursel,1);
cnames = {};

vis = ii_cfg.vis;
v = textscan(vis,'%s','delimiter',',');

qq = tcursel(tindex,:);
rng = qq(2) - qq(1);
selstrt = qq(1);
selend = qq(2);

hax = get(iEye,'CurrentAxes');
axes(hax);
cla;

for w = 1:rng
    sm{w,1} = selstrt;
    selstrt = selstrt + 1;
end

sm = cell2mat(sm);
selstrt = qq(1);
p = [];

col = lines(length(v{1}));

for i = 1:length(v{1})
    c = v{1}{i};
    d = 1;
    chan = evalin('base', c);
    cnames{end+1} = c;
    for w = qq(1)+1:qq(2)
        p(d,i) = chan(w);
        d = d + 1;
    end
    csel = p(:,i);
    plot(sm,csel,'color',col(i,:));
    hold all
end

% hax = figure;
% 
% for i = 1:length(v{1})
%     c = v{1}{i};
%     d = 1;
%     chan = evalin('base', c);
%     cnames{end+1} = c;
%     for w = qq(1)+1:qq(2)
%         p(d,i) = chan(w);
%         d = d + 1;
%     end
%     csel = p(:,i);
%     plot(sm,csel,'color',col(i,:));
%     hold all
% end

blinks = ii_cfg.blink;

if ~isempty(blinks)
    X = evalin('base','X');
    Y = evalin('base','Y');
    
    XB = X*NaN;
    YB = Y*NaN;
    
    XB(blinks) = X(blinks);
    YB(blinks) = Y(blinks);
    
    d = 1;
    for w = qq(1)+1:qq(2)
        XBP(d) = XB(w);
        d = d + 1;
    end
    
    d = 1;
    for w = qq(1)+1:qq(2)
        YBP(d) = YB(w);
        d = d + 1;
    end
    
    plot(sm,XBP,'k*');
    plot(sm,YBP,'k*');
else
end

tl = sprintf('Trial #: %s out of %s', num2str(tindex),num2str(numt));
title(tl);


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
legend(cnames,'Location', 'NortheastOutside', 'Orientation', 'Vertical');

ii_cfg.tindex = tindex;
putvar(ii_cfg);

end

