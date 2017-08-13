function ii_preproc(edf_fn)
% Generic script for pre-processing memory-guided saccade data. This script
% assumes the data is already imported in iEye. It addresses the following
% issues: The Y channel is inverted to its correct orientation, the data is
% then blink-corrected and slightly smoothed. Finally, the data is scaled
% and re-calibrated.

% edited TCS & GH 8/25/2016


if nargin < 1
    edf_fn = 'examples/exdata1.edf';
end



% initialize iEye - make sure paths are correct, etc
ii_init;



% import data
[ii_data,ii_cfg] = ii_import_edf(edf_fn,'examples/p_1000hz.ifg',[edf_fn(1:end-3) 'mat']);

% Show only the channels we care about at the moment
%ii_view_channels('X,Y,TarX,TarY,XDAT');

% rescale X, Y based on screen info
[ii_data,ii_cfg] = ii_rescale(ii_data,ii_cfg,{'X','Y'},[1280 1024],34.1445);



% Invert Y channel (the eye-tracker spits out flipped Y values)
[ii_data,ii_cfg] = ii_invert(ii_data,ii_cfg,'Y');

% Correct for blinks

[ii_data, ii_cfg] = ii_blinkcorrect(ii_data,ii_cfg,{'X','Y'},'Pupil',1500,50,50); % maybe 50, 50? %altering this 6/1/2017 from 1800 in both x/y 


% split into individual trials (so that individual-trial corrections can be
% applied)
[ii_data,ii_cfg] = ii_definetrial(ii_data,ii_cfg,'XDAT',1,'XDAT',8); % CHECK THIS!


% TCS, made it here 8/11/2017

% Smooth data
ii_smooth('X','moving',10);
ii_smooth('Y','moving',10);

% Scale X and Y values to Tar X and Tar Y values. This is done because X
% and Y are output by the eye-tracker in pixel coordinates, while target
% values are expressed in MATLAB in degrees of visual angle.
% NOT NECESSARY ANYMORE - SEE II_RESCALE!!!
ii_autoscale('X','TarX');
ii_autoscale('Y','TarY');

% % Make initial selections for calibration (Corrective saccade)
% ii_selectbyvalue('TarX',2,0);
% ii_selectstretch(-400,0);
% 
% % Hold these 
% ii_selecthold;

% Select fixations
ii_selectbyvalue('XDAT',1,1);
%ii_selectstretch(-250,-250); % SAMPLES, NOT MS!!!!! (for now)
ii_selectstretch(-125,-125); % SAMPLES, NOT MS!!!!! (for now)

% Hold these 
ii_selecthold;

% Make initial selections for calibration (Corrective saccade)
ii_selectbyvalue('XDAT',1,5);
%ii_selectstretch(-400,0);
ii_selectstretch(-200,0);

% Merge fixation selections with corrective saccades
ii_selectmerge;

%%%%%%%%%%%%%%%
%% IMPORTANT!! %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%
%
% At this point it is vital to manually check that the selections are
% correct before calibration. It is likelY theY are not 100% accurate due
% to differences in individual subject behavior.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% make sure TarX, TarY are 0 at XDAT = 1:
% TarX(XDAT==1) = 0;TarY(XDAT==1)=0;

% Once selections are finalized, we calibrate.
ii_calibrateto('X','TarX',3);
ii_calibrateto('Y','TarY',3);

% Empty selections
ii_selectempty;

% Get and store eye-movement velocity
ii_velocity('X','Y');

disp ('save me!');

% Now save me!
end