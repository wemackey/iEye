function ii_trialinfo(tindex)
%II_TRIALINFO Summary of this function goes here
%   Detailed explanation goes here

if nargin ~= 1
    tindex = 1;
end

ii_cfg = evalin('base', 'ii_cfg');
tcursel = ii_cfg.tcursel;
cnames = {};

vis = ii_cfg.vis;
v = textscan(vis,'%s','delimiter',',');

qq = tcursel(tindex,:);
rng = qq(2) - qq(1);
selstrt = qq(1);
selend = qq(2);

figure('Name','Trial Info','NumberTitle','off')


for w = 1:rng
    sm{w,1} = selstrt;
    selstrt = selstrt + 1;
end

sm = cell2mat(sm);
selstrt = qq(1);
p = [];

col = lines(length(v{1}));

% Plot timeseries

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
    subplot(2,1,1);
    tt = sprintf('Trial #: %s', num2str(tindex));
    title(tt)
    plot(sm,csel,'color',col(i,:));
    hold all
end

% Plot blinks on timeseries if they exist

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
    
    subplot(2,1,1);
    plot(sm,XBP,'k*');
    plot(sm,YBP,'k*');
else
end

% Plot spatial information

X = evalin('base','X');
Y = evalin('base','Y');
TarX = evalin('base','TarX');
TarY = evalin('base','TarY');

d = 1;
for w = qq(1)+1:qq(2)
    x(d) = X(w);
    y(d) = Y(w);
    tx(d) = TarX(w);
    ty(d) = TarY(w);
    d = d + 1;
end

subplot(2,1,2);
plot(x,y,'LineStyle', ':');
hold all
plot(tx,ty,'LineStyle', '*');
axis([-11 11 -11 11])

end



