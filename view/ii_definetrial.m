function [ii_data,ii_cfg] = ii_definetrial(ii_data,ii_cfg, c1, v1, c2, v2)
%II_DEFINETRIAL Splits data into individual trials based on signal in the
%               ii_data.(chan) variable
%   Detailed explanation goes here
% Updated TCS 8/13/2017 to use ii_data, ii_cfg (no base vars)
%


if nargin == 2
    prompt = {'Start when Channel', 'is at Value', 'Until Channel', 'is at Value'};
    dlg_title = 'Trial Parameters';
    num_lines = 1;
    answer = inputdlg(prompt,dlg_title,num_lines);
    c1 = answer{1};
    v1 = str2num(answer{2});
    c2 = answer{3};
    v2 = str2num(answer{4});
end

%basevars = evalin('base','who');
%ii_cfg = evalin('base', 'ii_cfg');

% TODO: maybe relax case sensitivity?
if ismember(c1,fieldnames(ii_data)) && ismember(c2,fieldnames(ii_data))
    
    chan1 = ii_data.(c1);
    chan2 = ii_data.(c2);
    tsel     = chan1*0;
    trialvec = chan1*0;
    
    % indices where c1 becomes v1
    %swhere = find(diff([0; chan1] == v1)== 1);
    swhere = find(diff(chan1 == v1)== 1)+1;
    
    % indices where c2 is no longer v2
    %ewhere = find(diff([chan2;0] == v2)==-1);
    ewhere = find(diff(chan2 == v2)==-1);
    
    % in case where swhere(1) > ewhere(1), shift them relative to one
    % another (this can be true when c1 matches v1
    if (swhere(1) > ewhere(1)) && chan1(1)==v1
        swhere = [1; swhere];
    end
    
    if length(ewhere) == (length(swhere)-1)
        ewhere = [ewhere; length(chan2)];
    end
    
    %tcursel(:,1) = SplitVec(swhere,'consecutive','firstval');
    %tcursel(:,2) = SplitVec(ewhere,'consecutive','lastval');
    tcursel = [swhere ewhere];
    
    for tt=1:length(swhere)
        %tsel(tcursel(i,1):tcursel(i,2)) = 1;
        tsel(swhere(tt):ewhere(tt)) = 1;
    end
    
    for tt=1:length(swhere)
        %trialvec(tcursel(i,1):tcursel(i,2)) = i;
        trialvec(swhere(tt):ewhere(tt)) = tt;
    end
    
    tindex = 1;
    
    ii_cfg.tcursel = tcursel;
    ii_cfg.tsel = tsel;
    ii_cfg.trialvec = trialvec;
    ii_cfg.tindex = tindex;
    
    % putvar(ii_cfg);
    
    ii_cfg{end+1} = sprintf('ii_definetrial %s %i to %s %i - %s',c1,v1,c2,v2,datestr(now,30));
    
    
end

end

