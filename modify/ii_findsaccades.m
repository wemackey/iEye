function [ii_data,ii_cfg] = ii_findsaccades(ii_data,ii_cfg,xchan,ychan,vel_thresh,dur_thresh,amp_thresh)
%Saccade detection
%   This function will detect and select saccades based on a particular set
%   of criteria (velocity and sample/time length).

% if nargin ~= 4
%     prompt = {'X Channel', 'Y Channel', 'Velocity Threshold', 'Length Threshold'};
%     dlg_title = 'Saccade Finder';
%     num_lines = 1;
%     answer = inputdlg(prompt,dlg_title,num_lines);
%
%     x = answer{1};
%     y = answer{2};
%     t = str2num(answer{3});
%     l = str2num(answer{4});
% end
%
% updated TCS 8/14/2017 - requires ii_velocity already been run, uses
% xchan/ychan only for ensuring sufficient distance between
% startpoint/endpoint
% for now, runs on entire time series - does not limit to particular
% epochs. at end of this function, saccades will be 'selected' by iEye -
% then, a separate function can be used to identify fixation periods
% between eye movements, and to extract information/metrics about the
% saccades themselves. [at least for now]. ii_cfg will have relevant info.

%%%%%%%%%% ADD DISTANCE BETWEEN!!!!

% make sure relevant channels exist
if ~ismember(xchan,fieldnames(ii_data))
    error('iEye:ii_findsaccades:channelNotFound', 'Channel %s does not exist in ii_data',xchan)
end

if ~ismember(ychan,fieldnames(ii_data))
    error('iEye:ii_findsaccades:channelNotFound', 'Channel %s does not exist in ii_data',ychan)
end

if ~ismember('velocity',fieldnames(ii_cfg))
    error('iEye:ii_findsaccades:velocityNotComputed', 'Velocity has not yet been computed. Use ii_velocity before running ii_findsaccades.')
end

% by this point, all variables accounted for...

[ii_data,ii_cfg] = ii_selectempty(ii_data,ii_cfg);

% FIND SACCADES >= T

[ii_data,ii_cfg] = ii_selectbyvalue(ii_data,ii_cfg,ii_cfg.velocity,'greaterthanequalto',vel_thresh);



%         ii_cfg = evalin('base', 'ii_cfg');
%         cursel = ii_cfg.cursel;
%         cursel(:,2) = cursel(:,1)+2;
%         sel = ii_cfg.sel * 0;
%
%         ii_cfg.cursel = cursel;
%         ii_cfg.sel = sel;
%         for i=1:(size(cursel,1))
%             sel(cursel(i,1):cursel(i,2)) = 1;
%         end
%         putvar(ii_cfg);
%
%         ii_selectuntil('vel',3,2,t2);

% compute saccade duration
sacc_dur = (ii_cfg.cursel(:,2)-ii_cfg.cursel(:,1))/ii_cfg.hz;



% compute saccade amplitude
sacc_amp = sqrt((ii_data.(xchan)(ii_cfg.cursel(:,1))-ii_data.(xchan)(ii_cfg.cursel(:,2))).^2 + (ii_data.(ychan)(ii_cfg.cursel(:,1))-ii_data.(ychan)(ii_cfg.cursel(:,2))).^2);


sacc_keep = sacc_dur >= dur_thresh & sacc_amp >= amp_thresh;

ii_cfg.cursel = ii_cfg.cursel(sacc_keep,:);
ii_cfg.sel = 0*ii_cfg.sel;
for ii = 1:size(ii_cfg.cursel,1)
    ii_cfg.sel(ii_cfg.cursel(ii,1):ii_cfg.cursel(ii,2)) = 1;
end

ii_cfg.saccades = ii_cfg.cursel;


ii_cfg.history{end+1} = sprintf('ii_findsaccades - dur, vel, amp thresh: %d, %d, %d, chans %s, %s - %s',dur_thresh, vel_thresh, amp_thresh, xchan, ychan,datestr(now,30));

% IGNORE SACCADES < L

% ii_cfg = evalin('base', 'ii_cfg');
% cursel = ii_cfg.cursel;
% sel = ii_cfg.sel * 0;
% 
% dif = cursel(:,2) - cursel(:,1);
% 
% ind = find(dif<dur_thresh);
% 
% cursel(ind,:) = [];
% 
% for i=1:(size(cursel,1))
%     sel(cursel(i,1):cursel(i,2)) = 1;
% end
% 
% ii_cfg.cursel = cursel;
% ii_cfg.sel = sel;
% ii_cfg.saccades = cursel;
% putvar(ii_cfg);
% 
% % SHOW SELECTIONS
% 
% % ii_showselections;
% 
% if ismember(c1,basevars)
%     if ismember(c2,basevars)
%         thechan = evalin('base',c1);
%         thechan2 = evalin('base',c2);
%         
%         ii_cfg = evalin('base', 'ii_cfg');
%         sel = ii_cfg.sel;
%         cursel = [];
%         tsel = sel*0;
%         
%         %         nchan = ii_cfg.nchan;
%         %         lchan = textscan(ii_cfg.lchan,'%s','delimiter',',');
%         %         schan = str2num(ii_cfg.hz);
%         
%         swhere = find(thechan == v1);
%         ewhere = find(thechan2 == v2);
%         
%         tcursel(:,1) = SplitVec(swhere,'consecutive','firstval');
%         tcursel(:,2) = SplitVec(ewhere,'consecutive','lastval');
%         
%         for i=1:(size(tcursel,1))
%             tsel(tcursel(i,1):tcursel(i,2)) = 1;
%         end
%         
%         % eliminate saccades outside this window
%         
%         csel = tsel + sel;
%         csel = csel - 1;
%         cwhere = find(csel==1);
%         cursel(:,1) = SplitVec(cwhere,'consecutive','firstval');
%         cursel(:,2) = SplitVec(cwhere,'consecutive','lastval');
%         cursel(:,2) = cursel(:,2)+2;
%         
%         ii_cfg.cursel = cursel;
%         ii_cfg.sel = csel;
%         putvar(ii_cfg);
%         
%         % ii_showselections;
%         
%         % select 50 samples after the saccade as endpoint
%         
%         %         nsel(:,1) = cursel(:,2);
%         %         nsel(:,2) = nsel(:,1) + 50;
%         %
%         %         cursel = nsel;
%         %         sel = sel*0;
%         %
%         %         for i=1:(size(cursel,1))
%         %             sel(cursel(i,1):cursel(i,2)) = 1;
%         %         end
%         %
%         %         ii_cfg.cursel = cursel;
%         %         ii_cfg.sel = sel;
%         %         putvar(ii_cfg);
%         %
%         %         ii_showselections;
%         
%         % take mean?
%     else
%         disp('Channel does not exist')
%     end
% else
%     disp('Channel does not exist')
% end
% 

end

