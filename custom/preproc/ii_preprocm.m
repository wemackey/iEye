function ii_preprocm()
% Generic script for pre-processing memory-guided saccade data. This script
% assumes the data is already imported in iEye. It addresses the following
% issues: The Y channel is inverted to its correct orientation, the data is
% then blink-corrected and slightly smoothed. Finally, the data is scaled
% and re-calibrated.

% Show only the channels we care about at the moment
ii_view_channels('X,Y,TarX,TarY,XDAT');

% Invert Y channel (the eye-tracker spits out flipped Y values)
ii_invert('Y');

% Correct for blinks
ii_blinkcorrect('X','Pupil',0,10,10);
ii_blinkcorrect('Y','Pupil',0,10,10);

% Smooth data
ii_smooth('X','moving',10);
ii_smooth('Y','moving',10);

% Scale X and Y values to Tar X and Tar Y values. This is done because X
% and Y are output by the eye-tracker in pixel coordinates, while target
% values are expressed in MATLAB in degrees of visual angle.
ii_autoscale('X','TarX');
ii_autoscale('Y','TarY');

% Make initial selections for calibration (Corrective saccade)
ii_selectbyvalue('TarX',2,0);
ii_selectstretch(-400,0);

% Hold these 
ii_selecthold;

% Select fixations
ii_selectbyvalue('XDAT',1,1);
ii_selectstretch(-250,-250);

% Merge fixation selections with corrective saccades
ii_selectmerge;

%%%%%%%%%%%%%%%
% IMPORTANT!! %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%
%
% At this point it is vital to manually check that the selections are
% correct before calibration. It is likely they are not 100% accurate due
% to differences in individual subject behavior.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Once selections are finalized, we calibrate.
ii_calibrateto('X','TarX',3);
ii_calibrateto('Y','TarY',3);

% Empty selections
ii_selectempty;

% Get and store eye-movement velocity
ii_velocity('X','Y');

% Now save me!
end

