function [ii_data,ii_cfg] = ii_blinkcorrect(ii_data,ii_cfg,chan, pchan, pval, pri, fol)
% Basic blink correction. This function takes 5 inputs: (1) The channel you
% want to perform blink correction on; (2) the name of the Pupil channel;
% (3) the Pupil threshold you want to use to define a blink; the # of
% prior (4) and following (5) samples to that threshold value you want to
% include in the correction around each blink
%
% Updated TCS 8/11/2017 - no base space variables
%
% TODO: implement a pupil velocity/acceleration version of this

% If not passed, get arguments


% TODO: check this...
if nargin == 2 % only data, cfg
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

%basevars = evalin('base','who');

if ~iscell(chan)
    chan = {chan};
end

% first, find blinks

pupil = ii_data.(pchan);

blink_mask = pupil <= pval; 
blink_onsets  = find(diff(blink_mask)== 1);
blink_offsets = find(diff(blink_mask)==-1);

% handle case(s) where blink at beginning/end, so blink_onsets &
% blink_offsets are different lengths. in general, we'd hope that
% blink_onsets(1) is always < blink_offsets(1), etc. this will not be true
% if the first offset (upwards threshold crossing) precedes the first
% actual blink, or if the eye is closed at end of run (no offset)

if blink_onsets(1) > blink_offsets(1)
    
    blink_onsets = [1; blinkonsets];
    
end

if length(blink_offsets) == (length(blink_onsets)-1)
    blink_offsets = [blink_offsets; length(pupil)];
end

blink_window = [blink_onsets-pri blink_offsets+fol];
blink_window(blink_window(:,1)<1,1) = 1;
blink_window(blink_window(:,2)>length(pupil),2) = length(pupil);

blinkvec = zeros(size(pupil));

for tt = 1:size(blink_window,1)
    blinkvec(blink_window(tt,1):blink_window(tt,2)) = 1;
end

% then, replace those with nan, and save an appropriate variable in ii_cfg

for cc = 1:length(chan)
    ii_data.(chan{cc})(blinkvec==1) = nan;
end

blink = find(blinkvec==1);

ii_cfg.blink = blink;
ii_cfg.blinkvec = blinkvec;

ii_cfg.history{end+1} = sprintf('Blink corrected %s with pupil threshold of %d (%d/%d) on %s ', horzcat(chan{:}), pval, pri,fol, datestr(now,30));


return

