function ii_blinkcorrect(chan, pchan, pval, pri, fol)
% Basic blink correction. This function takes 5 inputs: (1) The channel you
% want to perform blink correction on; (2) the name of the Pupil channel;
% (3) the Pupil threshold you want to use to define a blink; the # of
% prior (4) and following (5) samples to that threshold value you want to
% include in the correction around each blink

% If not passed, get arguments
if nargin ~= 5
    prompt = {'Channel to Correct', 'Pupil Channel', 'Pupil Threshold', '# Prior Samples', '# Following Samples'};
    dlg_title = 'Blink Correction';
    num_lines = 1;
    answer = inputdlg(prompt,dlg_title,num_lines);
    
    chan = answer{1};
    pchan = answer{2};
    pval = str2num(answer{3});
    pri = str2num(answer{4});
    fol = str2num(answer{5});
end

basevars = evalin('base','who');

if ismember(chan,basevars)
    pupil = evalin('base',pchan);
    x = evalin('base',chan);
    lx = length(x);
    ii_cfg = evalin('base', 'ii_cfg');
    sel = x*0;
    blinkvec = x*0;
    
    blink = find(pupil<=pval);
    if blink > 0
        split1 = SplitVec(blink,'consecutive','firstval');
        split2 = SplitVec(blink,'consecutive','lastval');
        
        if split1-pri < 1
            blinked(:,1) = 1;
        else
            blinked(:,1) = split1 - pri;
        end
        
        if split2+fol > lx
            blinked(:,2) = lx;
        else
            blinked(:,2) = split2 + fol;
        end
        
        chk = find(blinked(:,2) > lx);
        if ~isempty(chk)
            blinked(chk,2) = lx;
        end
               
        for z=1:(size(blinked,1))
            if blinked(z,1)<1
                blinked(z,1) = 1
            end
            sel(blinked(z,1):blinked(z,2)) = 1;
        end
        
        x(sel==1) = 0;
        blink = find(x==0);
        
        % Set new value to value of last non-blink sample
        for o = 2:(length(x))
            if x(o) == 0
                x(o) = x(o - 1);
            end
        end
%         inds = find(x==0);
%         
%         % Interpolate
%         split1 = SplitVec(inds,'consecutive','first');
%         split2 = SplitVec(inds,'consecutive','last');
%         
%         for o = 1:length(split1)
%             x(split1(o):split2(o)) = linspace(x(split1(o)),x(split2(o)),split2(o)-split1(o)+1)';
%         end
        
        
%         % Plot blinks in new window
%         figure('Name','Blink Correction','NumberTitle','off')
%         plot(x);
%         hold all;
%         ylims = get(gca,'YLim');
%         hold on
%         plot([blink blink], ylims, '-r')

        blinkvec(blink) = 1;
        
        assignin('base',chan,x);
        ii_cfg.blink = blink;
        ii_cfg.blinkvec = blinkvec;
        
        dt = datestr(now,'mmmm dd, yyyy HH:MM:SS.FFF AM');
        ii_cfg.history{end+1,1} = sprintf('Blink corrected %s with pupil threshold of %d (%d/%d) on %s ', chan, pval, pri,fol, dt);
        putvar(ii_cfg);
        ii_replot;
    else
        disp('No blinks detected')
    end
else
    disp('Channel to correct does not exist in worksapce');
end
end

