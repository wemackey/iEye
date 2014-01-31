function ii_showblinks()
%II_SHOWBLINKS Summary of this function goes here
%   Detailed explanation goes here

ii_cfg = evalin('base', 'ii_cfg');
blinks = ii_cfg.blink;

if ~isempty(blinks)
    X = evalin('base','X');
    Y = evalin('base','Y');
    
    XB = X*NaN;
    YB = Y*NaN;
    
    XB(blinks) = X(blinks);
    YB(blinks) = Y(blinks);
    
    plot(XB,'k*');
    plot(YB,'k*');
else
end
end

