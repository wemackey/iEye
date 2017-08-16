function ii_plottrial(ii_data,ii_cfg,trial_num,which_chans,ax,plot_mode)
% II_PLOTTRIAL Plots channels & selections for a single trial; can put into
% subplots in outside function
%
% TCS 8/15/2017 - ii_plot* functions are mostly meant to be used via
% command line or for spot-checking data, at least now are not intended to
% be interactive. potentially can change that in the future
% TODO: allow for multiple trials, will create subplots within here (though
% that can/should also happen outside of this)


if nargin < 5 || isempty(ax)
    myf = figure;
    ax = axes;
end

if ~isa(ax,'matlab.graphics.axis.Axes')
    myf = figure;
    ax = axes;
end

% plot 'condensed', or 'standard'?
if nargin < 6
    plot_mode = 'standard';
end

% if which_chans is empty, or not defined, by default we'll:
%  - plot X, Y, and X_fix, Y_fix if available
%  - colorbar indicating XDAT (if available, and if multiple values per
%    trial) [top]
%  - colorbar of velocity [bottom]
%  - translucent rectangles for selections? or horizontal line

if nargin < 4 || isempty(which_chans)
    which_chans = {'X','Y'};
end

% be sure trials have already been defined
if ~ismember('trialvec',fieldnames(ii_cfg))
    error('iEye:ii_plottrial:noTrials', 'Trials not yet identified, run ii_definetrial')
end

% grab temporal indices for this trial
thisidx = ii_cfg.trialvec==trial_num;

% make sure this trial exists...
if sum(thisidx)==0
    error('iEye:ii_plottrial:trialNotFound', 'Trial %i not found',trial_num)
    
end

% TODO: make sure all thisidx is consecutive...

myt = (1:sum(thisidx)).' * 1/ii_cfg.hz;

hold on;

for ii = 1:length(which_chans)
    plot(myt,ii_data.(which_chans{ii})(thisidx),'-','LineWidth',1.5);
    if ismember(sprintf('%s_fix',which_chans{ii}),fieldnames(ii_data))
        plot(myt,ii_data.(sprintf('%s_fix',which_chans{ii}))(thisidx),'k-','LineWidth',1);
    end
end

xlim([0 max(myt)]);


% if velocity is a channel, plot this under the graph as heatmap
if strcmpi(plot_mode,'standard')
    if ismember('velocity',fieldnames(ii_cfg))
        this_ylim = get(gca,'YLim');
        
        imagesc(myt,this_ylim(1)-[0.75 1.25],repmat(ii_cfg.velocity(thisidx).',2,1));
        colormap hot;
        
        ylim([this_ylim(1)-1.5 this_ylim(2)]);
        
        
        clear this_ylim;
    end
end
% if XDAT is available and there's more than one unique value on this
% trial, plot it in the 'lines' color scheme w/ patches
if strcmpi(plot_mode,'standard')
    if ismember('XDAT',fieldnames(ii_data))
        
        this_xdat = ii_data.XDAT(thisidx);
        
        ux = unique(this_xdat);
        
        if length(ux) > 1
            
            this_ylim = get(gca,'YLim');
            
            newy = this_ylim(1)-[0.75 1.25];
            
            mycolors = lines(length(ux));
            
            for uu = 1:length(ux)
                
                startidx = find(diff([ux(1)-1;  this_xdat]==ux(uu))== 1)*1/ii_cfg.hz;
                endidx   = find(diff([this_xdat;ux(end)+1]==ux(uu))==-1)*1/ii_cfg.hz;
                
                patch([startidx startidx endidx endidx], [newy(1) newy(2) newy(2) newy(1)], mycolors(uu,:) );
                
            end
            %if strcmpi(plot_mode,'standard')
            ylim([this_ylim(1)-1.5 this_ylim(2)]);
            %end
        end
        
        
    end
end


if strcmpi(plot_mode,'standard')
    xlabel('Time (s)');
    ylabel('Position (\circ)');
    title(sprintf('Trial %i',trial_num));
else
    axis tight;
    this_ylim = get(gca,'YLim');
    if abs(this_ylim(1)) < abs(this_ylim(2))
        %t_han = text(0.25,this_ylim(2),sprintf('Trial %i',trial_num));
        t_han = text(0.25,3.5,sprintf('Trial %i',trial_num),'FontSize',9);
    else
        t_han = text(0.25,-3.5,sprintf('Trial %i',trial_num),'FontSize',9);
    end
    
    plot(myt,zeros(size(myt)),'k--');
    axis off;
end
hold off;



return