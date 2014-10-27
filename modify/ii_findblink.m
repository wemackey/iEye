function ii_findblink(tmin,tmax)
%Blink detection
%   This function will find blinks across a timeseries. Blinks are defined
%   by a min and max threshold value.

if nargin ~= 2
    prompt = {'Min:','Max:'};
    dlg_title = 'Blink thresholds';
    num_lines = 1;
    answer = inputdlg(prompt,dlg_title,num_lines);
    
    tmin = str2num(answer{1});
    tmax = str2num(answer{2});
end

pval = 0;

basevars = evalin('base','who');

pupil = evalin('base','Pupil');
sel = pupil*0;
blinkvec = sel;

blink = find(pupil==pval);
if blink > 0
    split1 = SplitVec(blink,'consecutive','firstval');
    split2 = SplitVec(blink,'consecutive','lastval');
    sb = split2 - split1;
    
    tblinks(:,1) = split1;
    tblinks(:,2) = split2;
    tblinks(:,3) = sb;
    
    g = find(tblinks(:,3)>=tmin);
    xblinks(:,1) = tblinks(g,1);
    xblinks(:,2) = tblinks(g,2);
    xblinks(:,3) = tblinks(g,3);
    
    f = find(xblinks(:,3)<=tmax);
    blinks(:,1) = xblinks(f,1);
    blinks(:,2) = xblinks(f,2);
    
    for u=1:(size(blinks,1))
        blinkvec(blinks(u,1):blinks(u,2)) = 1;
    end
    
    for z=1:(size(blinks,1))
        sel(blinks(z,1):blinks(z,2)) = 1;
    end
    
    bplot = find(blinkvec==1);
    
    figure('Name','Blinks','NumberTitle','off')
    plot(pupil);
    hold all;
    
    ylims = get(gca,'YLim');
    hold on
    plot([blink blink], ylims, '-y')
    plot([bplot bplot], ylims, '-r')
    
    pvec = sel;
    putvar(blinks,pvec,tblinks,xblinks,blinkvec);
else
    disp('No blinks detected')
end

end