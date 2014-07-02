function ii_import_edf_sd(filename,pathname)
%IMPORT EYELINK EDF FILES
%   This function will import Eyelink EDF files but requires 'edf2asc'
%   command (from Eyelink) be installed in MATLAB's path. A config (*.ifg)
%   file is also required. After import, you can save as binary MAT file
%   for faster file I/O. Config information will be baked into ii_cfg
%   structure.

% MONOCULAR ONLY AT THE MOMENT
% Ignores corneal reflection flag information at the moment
% Automatically pulls out x,y,pupil sample data
% Will always be saved samples, messages
% i.e. x,y,pupil, message1, message2, message3
% Message variables are CASE SENSITIVE


% *IMPORTANT* MAKE SURE EDF2ASC COMMAND IS IN ENV PATH
% Add edf2asc command location to path if not already included. For
% example, this adds "/usr/local/bin" to the env path.
% path1 = getenv('PATH');
% path1 = [path1 ':/usr/local/bin'];
% setenv('PATH', path1);
% !echo $PATH;

% SETUP FILE

% [filename, pathname] = uigetfile('*.edf', 'Select EDF file');

if isequal(filename,0)
    disp('User selected Cancel');
else
    % GET CONFIG
    [nchan,lchan,schan,cfg] = ii_openifg_sd('deepu.ifg', '/Volumes/davachilab/murty/CYOM/CYOM.ey/eye_track/iEye-master/');
    nchan = str2num(nchan);
    schan = str2num(schan);
    vis = lchan;
    lchan = textscan(lchan,'%s','delimiter',',');
    
    echan = nchan - 3;
    
    % EXTRACT SAMPLES
    [status,result] = system(['edf2asc -t -c -s -miss 0 ' fullfile(pathname, filename)]);
    disp(status);
    disp(result);
    asc_samp_file = strrep(filename, 'edf', 'asc');
    
    fid = fopen(fullfile(pathname, asc_samp_file),'r');
    M = textscan(fid,'%f %f %f %f %*s');
    M = cell2mat(M);
    s_num = M(:,1);
    x = M(:,2);
    y = M(:,3);
    pupil = M(:,4);
    
    delete (fullfile(pathname, asc_samp_file));
    
    % EXTRACT EVENTS
    [status,result] = system(['edf2asc -t -c -e -miss 0 ' fullfile(pathname, filename)]);
    disp(status);
    disp(result);
    asc_evnt_file = strrep(filename, 'edf', 'asc');
    
    fid = fopen(fullfile(pathname, asc_evnt_file),'r');
    E = textscan(fid,'%s', 'delimiter','\n');
    E = E{1};
    mline = 1;
    Mess = {};
    
    % GET MSG EVENTS
    token = strtok(E);
    for v = 1:length(token)
        dm = strcmp(token(v),'MSG');
        if dm == 1
            Mess(mline) = E(v);
            mline = mline + 1;
        end
    end
    
    Mess = Mess';
    [useless, remain] = strtok(Mess);
    [samp_n, remain] = strtok(remain);
    [varbl, vval] = strtok(remain);
    samp_n = str2double(samp_n);
    vval = str2double(vval);
    
    % SEARCH MSG EVENTS FOR VARIABLE
    for i = 4:nchan
        mline = 1;
        cname = lchan{1}{i};
        MV = [];
        
        for v = 1:length(varbl)
            dm = strcmp(varbl(v),cname);
            
            if dm == 1
                MV(mline,:) = [samp_n(v) vval(v)];
                mline = mline + 1;
            end
        end
        
        % GET INDICES & SET VALUES
        li = 1;
        ci = 1;
        cv = 0;
        M(:,(i+1)) = 0;
        
        for h = 1:length(MV)
            ci = find(M(:,1)==MV(h,1));            
            M((ci:length(M)),(i+1)) = MV(h,2);
            li = ci;
        end       
    end
    
     delete(fullfile(pathname,asc_evnt_file));
    
    % CREATE FILE MATRIX
    iye_file = strrep(filename, 'edf', 'iye');
    fil = fullfile(pathname, iye_file);
    M(:,1) = [];
    
    % SAVE AND PLOT
    h = waitbar(0,'Opening file...');
    for i = 1:nchan
        cname = lchan{1}{i};
        cvalue = M(:,i);
        assignin('base',cname,cvalue);
        waitbar(i/nchan,h);
    end
    close(h);
    
    x = M(:,1);
    
    iEye;
    
    % CREATE II_CFG STRUCT    
    dt = datestr(now,'mmmm dd, yyyy HH:MM:SS.FFF AM');
    
    ii_cfg.cursel = [];
    ii_cfg.sel = x*0;
    ii_cfg.cfg = cfg;
    ii_cfg.vis = vis;
    ii_cfg.nchan = nchan;
    ii_cfg.lchan = lchan;
    ii_cfg.hz = schan;
    ii_cfg.blink = [];
    ii_cfg.velocity = [];
    ii_cfg.tcursel = [];
    ii_cfg.tsel = x*0;
    ii_cfg.tindex = 0;
    ii_cfg.saccades = [];
    ii_cfg.history{1} = ['EDF imported ', dt];
    putvar(ii_cfg);
    ii_replot;
    
end
end

