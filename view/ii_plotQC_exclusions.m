function [fh] = ii_plotQC_exclusions(ii_trial,ii_cfg,which_excl,fig_visible)
% ii_plotQC_exclusions Plots which trials are excluded [per run] in two
% plots: (1) 'dot' plot, which indicates which criteria apply to each trial,
% and (2) bar graph, indicating overall percentage of trials excluded per
% each criteron, and those actually excluded
%
% Usage:
%   ii_plotQC_exclusions(ii_trial,ii_cfg) plots n_runs (if r_num present;
%   otherwise, 1) subplots, each with n_trials x n_excl dot locations. a
%   dot is present if that exclusion criterion applies to that trial; it's
%   red if it's one of those we actually exclude (if it's in which_excl)
%
%   fh = ii_plotQC_exclusions(ii_trial,ii_cfg,...) returns figure handles
%   for all plots
%
%   ii_plotQC_exclusions(ii_trial,ii_cfg,which_excl) allows specification
%   of which types of exclusion criteria to respect (by default, all)
%
%   ii_plotQC_exclusions(ii_trial,ii_cfg,[],fig_visible), where fig_visible
%   is a logical, determines whether the plotted figures are visible, or if
%   they're plotted in the background
%
% ii_plotQC functions are compatible with ii_trial variables, computed with
% ii_scoreMGS.m, or ii_sess variables built from concatenated ii_trial
% files, computed with ii_combineruns.m. I look for r_num and t_num to
% determine whether concatenation occured, and split by run number if so.
% Otherwise, I just use all trials on a single subplot throughout.
%
% Based on plotSaccadeSummary scripts written for individual projects...
%
% NOTE: ii_cfg not used in this function...
%
% TODO: auto-figure-pos: 155 pix per subplot wide, 375 pix per subplot tall
%
% Tommy Sprague, 6/12/2018

%% setup
% all possible exclusions and their string labels
all_excl = [11 12 13 20 21 22];
excl_labels = {'drift','calibration','delay fixation','no i_sacc','bad i_sacc','i_sacc err'};

fh = []; % empty figure handle

if nargin < 3 || isempty(which_excl)
    which_excl = all_excl; 
end

if nargin < 4 || isempty(fig_visible)
    fig_visible = 1;
end

if fig_visible == 1
    fig_arg = {'Visible','on'};
else
    fig_arg = {'Visible','off'};
end

MAX_ROWS = 5;   % max # of rows for run-wise plot
MAX_COLS = 12;  % max # of cols for run-wise plot


plot_params = ii_loadplotparams; % where we save things like EXCL_COLOR, etc...

%% plot dot-plot for each run, or all trials
if isfield(ii_trial,'r_num') && length(unique(ii_trial.r_num))>1 % if we need multiple subplots...
    ru_dot = unique(ii_trial.r_num);
    this_ncols = min(length(ru_dot),MAX_COLS);
    this_nrows = min(ceil(length(ru_dot)/MAX_COLS),MAX_ROWS);
    nfigs_dot = ceil(length(unique(ii_trial.r_num))/(MAX_ROWS*MAX_COLS)); % hopefully just one...
else
    this_nrows = 1;
    this_ncols = 1;
    ru_dot = 1;
end

fh(end+1) = figure(fig_arg{:});

for rr = 1:length(ru_dot)
    
    % if we're on to our next figure, open a new one
    if rr > MAX_ROWS*MAX_COLS && mod(rr,MAX_ROWS*MAX_COLS)==1
        fh(end+1) = figure(fig_arg{:});
    end
    
    subplot(this_nrows,this_ncols,rr);
    hold on;
    
    % get index (don't want these to be logicals, need to loop thru)
    if isfield(ii_trial,'r_num')
        thisidx = find(ii_trial.r_num==ru_dot(rr));
    else
        thisidx = find(ones(size(ii_trial.i_sacc,1),1)==1);
    end
    
    % loop over trials
    for tt = 1:length(thisidx)
        
        if ~isempty(ii_trial.excl_trial{thisidx(tt)})
            
            this_excl = ii_trial.excl_trial{thisidx(tt)};
            thisy = tt; % assume trial number is index number... (could also use t_num)
            
            % loop over exclusion criteria passed on this trial
            for ee = 1:length(this_excl)
                
                % where do we plot?
                thisx = find(all_excl==this_excl(ee));
                
                % which color? if this exclusion in which_excl, red,
                % otherwise, black
                if ismember(this_excl(ee),which_excl)
                    thiscolor = plot_params.EXCL_COLOR;
                else
                    thiscolor = [0 0 0];
                end
                
                plot(thisx,thisy,'o','MarkerSize',5,'MarkerFaceColor',thiscolor,'Color',thiscolor);
                clear thisx thiscolor;
                
            end
        end
    end
    
    % if necessary, title with run number
    if isfield(ii_trial,'r_num')
        title(sprintf('Run %i',ru_dot(rr)));
    end
    
    set(gca,'YTick',[1 5:5:length(thisidx)]);
    if rr == 1
        ylabel('Trial');
        set(gca,'YTickLabel',[1 5:5:length(thisidx)]);
    else
        set(gca,'YTickLabel',[]);
    end
    
    set(gca,'XTick',1:length(all_excl),'XTickLabel',excl_labels','XTickLabelRotation',-90,'TickDir','out','TickLabelInterpreter','none');
    xlim([0 length(all_excl)+1]);
    ylim([0 length(thisidx)+1]);
    axis ij;

    hold off;
    
    clear thisidx;
end

set(get(fh,'Children'),'TickDir','out','LineWidth',1.5,'FontSize',14);

% see above - use this to auto-position figure [on iMac: todo: do this w/
% normalized units!!!]
fig_height = this_nrows * 375/1440; % to normalized units
fig_width  = this_ncols * 155/2560;

% center: (note: matlab defines bottom left corner as 1,1 for monitor and
% figure)
%tmp_scr = get(groot,'MonitorPositions');
fig_center = [0.5 0.5];
fig_pos = [fig_center - [fig_width fig_height]*0.5 fig_width fig_height];
set(gcf,'Units','Normalized');
set(gcf,'Position',fig_pos);

%% plot overall trial exclusions
%
% if run info available, also make a plot of exclusions per run (both using
% which_excl and using all)

if isfield(ii_trial,'r_num') && length(unique(ii_trial.r_num))>1 % there are runs, plot evolution thru time
    this_nrows = 2;
    this_ncols = 2;
    
else
    this_nrows = 1;
    this_ncols = 2;
end


fh(end+1) = figure(fig_arg{:});

% two subplots: one of each criterion, color-coded as to whether it's
% used
subplot(this_nrows,this_ncols,1); hold on;
for ee = 1:length(all_excl)
    if ismember(all_excl(ee),which_excl)
        thiscolor = plot_params.EXCL_COLOR;
    else
        thiscolor = [0 0 0];
    end
    
    this_excl = cellfun(@any,cellfun(@(a) ismember(a,all_excl(ee)),ii_trial.excl_trial,'UniformOutput',false));
    bar(ee,100*mean(this_excl),'FaceColor',thiscolor);
    clear this_excl;
end
set(gca,'XTick',1:length(all_excl),'XTickLabel',excl_labels,'XTickLabelRotation',-90);
ylim([0 100]);
ylabel('Percent trials excluded');

% second, 2 bars, one for applying all criterion (black) and chosen
% criterion (white)
subplot(this_nrows,this_ncols,2); hold on;
this_excl = ~cellfun(@isempty,ii_trial.excl_trial);
bar(1,100*mean(this_excl),'EdgeColor',[0 0 0],'FaceColor',[0 0 0],'LineWidth',1.5);
clear this_excl;

this_excl = cellfun(@any,cellfun(@(a) ismember(a,which_excl),ii_trial.excl_trial,'UniformOutput',false));
bar(2,100*mean(this_excl),'EdgeColor',[0 0 0],'FaceColor',[1 1 1],'LineWidth',1.5);
set(gca,'XTick',[1 2],'XTickLabel',{'All','Specified'},'XTickLabelRotation',-45);
xlabel('Exclusions');
ylim([0 100]);

if isfield(ii_trial,'r_num')
    subplot(this_nrows,this_ncols,[3 4]); % spanning bottom half of figure
    
    ru = unique(ii_trial.r_num);
    
    excl_by_run = nan(length(ru),2); % percent of trials excluded per all; which criteria per run
    
    % loop over runs
    for rr = 1:length(ru)
        
        % do same as above, per run, and draw with black solid and dashed
        % lines
        
        % only look at this run
        this_excl_all   = ~cellfun(@isempty,{ii_trial.excl_trial{ii_trial.r_num==ru(rr)}});
        this_excl_which = cellfun(@any,cellfun(@(a) ismember(a,which_excl),{ii_trial.excl_trial{ii_trial.r_num==ru(rr)}},'UniformOutput',false));
        
        excl_by_run(rr,1) = 100*mean(this_excl_all);
        excl_by_run(rr,2) = 100*mean(this_excl_which);
        
    end
    
    hold on;
    
    plot(1:length(ru),excl_by_run(:,1),'ko-' ,'LineWidth',1.5,'MarkerSize',4,'MarkerFaceColor','k');
    plot(1:length(ru),excl_by_run(:,2),'ko--','LineWidth',1.5,'MarkerSize',4,'MarkerFaceColor','w');
    
    
    hold off;
    
    xlabel('Run number');
    ylabel('Percent trials excluded');
    
    ylim([0 100]);
    xlim([0 max(ru)+1]);
    
    set(gca,'XTick',1:length(ru),'XTickLabel',ru);
    set(get(gcf,'Children'),'FontSize',14,'LineWidth',1.5,'TickDir','out');

    legend({'All criteria','Chosen criteria'},'location','best','FontSize',14);
end



return