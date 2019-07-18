function [fig_handle] = plot_data(ii_data, which_chans)


fig_handle = figure;
for ii=1:length(which_chans)
hold on; 
plot(ii_data.(which_chans{ii}),'linewidth',1.2)
end

legend(which_chans)
% 80% wide, 0.25 tall as wide
%scr_size = get(0,'Screensize');
%FIG_POSITION = [[0.05 0.5-0.22*0.9]*scr_size(3) [0.9 0.9*0.22]*scr_size(3)];
%ticks
set(gcf,'Position',[32 610 2529  690])
set(gca,'TickDir','out','LineWidth',1.5,'FontSize',14,'TickLength',[0.0075 0.0075]);

% label axes, etc
xlabel('Sample');
ylabel('Channel value');
