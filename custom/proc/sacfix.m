% p13

% make sure r (run #) exists in workspace

di = [];
blinkvec = X*0;
blinkvec = blinkvec+1;
blinkvec(ii_cfg.blink) = 0;

ii_stats = evalin('base','ii_stats');

ii_definetrial('XDAT',1,'XDAT',6); % create trialvec
ii_findsaccades('X','Y',.04,10,'XDAT',4,'XDAT',5); % find saccades

%%%%%%%%%%%%%%%%%%%%%%%%%
% COMBINE < 100MS APART %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%

for i=2:length(ii_cfg.cursel)
    di(i-1)= ii_cfg.cursel(i,1) - ii_cfg.cursel(i-1,1);
end

z=find(di<100);
ii_cfg.cursel(z,2) = ii_cfg.cursel(z+1,1); 

ii_cfg.cursel(z+1,:) = [];
ii_cfg.sel = ii_cfg.sel*0;

for i=1:(size(ii_cfg.cursel,1))
    ii_cfg.sel(ii_cfg.cursel(i,1):ii_cfg.cursel(i,2)) = 1;
end

%%%%%%%%%%%%%%%%%%%%%%
% FIX BLINK SACCADES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%
% CHECK SACCADES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%

ii_replot;

ii_stats(r).saccades_45 = ii_cfg.cursel;
putvar(ii_stats);

%%%%%%%%%%%%%%%%%%
% CHECK SACCADES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%

numsacs = zeros(30,1);

% sync saccades with trial numbers
sacmat = ii_cfg.cursel;

for i = 1:length(sacmat)
    sacmat(i,3) = median(ii_cfg.trialvec(sacmat(i,1):sacmat(i,2)));
end

% count # of saccades per trial
for i = 1:30
    sacs = find(sacmat(:,3)==i);
    numsacs(i) = length(sacs);
end

ii_stats(r).numsacs = numsacs;
ii_stats(r).saccades_45 = ii_cfg.cursel;
putvar(ii_stats);

% avgsacs=[];
% 
% for i=1:length(ii_stats)
%     avgsacs = [avgsacs; ii_stats(i).numsacs];
% end
% 
% x_vec = [0 1 2 3 4 5 6];
% d_vec = [0 length(d_1)/length(d_avgsacs) length(d_2)/length(d_avgsacs) length(d_3)/length(d_avgsacs) length(d_4)/length(d_avgsacs) length(d_5)/length(d_avgsacs) 0];
% c_vec = [0 length(c_1)/length(c_avgsacs) length(c_2)/length(c_avgsacs) length(c_3)/length(c_avgsacs) length(c_4)/length(c_avgsacs) length(c_5)/length(c_avgsacs) 0];
% f_vec = [0 length(f_1)/length(f_avgsacs) length(f_2)/length(f_avgsacs) length(f_3)/length(f_avgsacs) length(f_4)/length(f_avgsacs) length(f_5)/length(f_avgsacs) 0];
