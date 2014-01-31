function ii_resample()
% RESAMPLE FUNCTION FOR MERGING EYE AND REACH DATA INTO ONE IYE
% FILE FOR BONNIE. REQUIRES:
% EYE MOVEMENT FILE IN IYE FORMAT
% REACH MOVEMENT FILE IN IYE FORMAT
% REACH MESSAGES FILE IN TSV/ASCII FORMAT
% EYE MOVEMENT CONFIG FILE
% REACH MOVEMENT CONFIG FILE
% MERGED EYE/REACH CONFIG FILE
%
% /wem 10.30.13

%%%%%%%%%%%%
% EYE FILE %
%%%%%%%%%%%%
% IYE

% LOAD FILE
[filename, pathname] = uigetfile('*.*', 'Select base EYE MOVEMENT file');
ifile = fullfile(pathname, filename);
ii_openiye(ifile);

% FIND SAMPLES BEFORE FIRST FIXATION
X = evalin('base','X');
Y = evalin('base','Y');
TarX = evalin('base','TarX');
TarY = evalin('base','TarY');
XDAT = evalin('base','XDAT');
Pupil = evalin('base','Pupil');

sel = X*0;
cursel(:,1) = 1;
cursel(:,2) = 2;
for i=1:(size(cursel,1))
    sel(cursel(i,1):cursel(i,2)) = 1;
end
putvar(cursel,sel);
ii_selectuntil('XDAT',4,2,0);

% CUT EVERYTHING BEFORE
X(cursel(:,1):cursel(:,2)) = [];
Y(cursel(:,1):cursel(:,2)) = [];
TarX(cursel(:,1):cursel(:,2)) = [];
TarY(cursel(:,1):cursel(:,2)) = [];
XDAT(cursel(:,1):cursel(:,2)) = [];
Pupil(cursel(:,1):cursel(:,2)) = [];
sel(cursel(:,1):cursel(:,2)) = [];

putvar(X,Y,TarX,TarY,Pupil,XDAT,sel);
ii_selectempty;
ii_replot;

% FIND START SAMPLE OF LAST ITI
split_xdat = SplitVec(XDAT,'equal','first');
sz = size(split_xdat);
st = split_xdat(sz(1));
en = size(X);
en = en(1);

% CUT EVERYTHING AFTER
X(st:en) = [];
Y(st:en) = [];
TarX(st:en) = [];
TarY(st:en) = [];
XDAT(st:en) = [];
Pupil(st:en) = [];
sel(st:en) = [];

putvar(X,Y,TarX,TarY,Pupil,XDAT,sel);
ii_replot;

% SAVE CHANGES
% ii_saveiye;


%%%%%%%%%%%%%%
% REACH FILE %
%%%%%%%%%%%%%%
[filename3, pathname3] = uigetfile('*.*', 'Select REACH SAMPLES file');
% TSV MESSAGES FILE

% LOAD FILE
[filename2, pathname2] = uigetfile('*.*', 'Select REACH MESSAGES file');

% GET CONFIG
[nchan,lchan,schan,cfg] = ii_openifg();
nchan = str2num(nchan);
schan = str2num(schan);
vis = lchan;
lchan = textscan(lchan,'%s','delimiter',',');

% LOAD SAMPLES
fid = fopen(fullfile(pathname3, filename3),'r');
M = textscan(fid,'%f %f %f %f %f');
M = cell2mat(M);
Frame = M(:,1);
Time = M(:,2);
rX = M(:,3);
rY = M(:,4);
rZ = M(:,5);

% SEARCH FOR FIRST FIXATION EVENT
fid = fopen(fullfile(pathname2, filename2),'r');
E = textscan(fid,'%s', 'delimiter','\n');
E = E{1};
mline = 1;
Mess = {};

% GET MSG EVENTS
token = strtok(E);
for v = 1:length(token)
    dm = strcmp(token(v),'EVENT');
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
lv = length(varbl);
ffix = varbl(1);

% rX = evalin('base','rX');
% rY = evalin('base','rY');
% rZ = evalin('base','rZ');
% Frame = evalin('base','Frame');
% Time = evalin('base','Time');

% SEARCH FOR LAST ITI EVENT
liti = varbl(lv);

f = liti{1};
f = str2num(liti{1});

% CUT EVERYTHING AFTER
rX(f:end) = [];
rY(f:end) = [];
rZ(f:end) = [];
Frame(f:end) = [];
Time(f:end) = [];
sel(f:end) = [];

% CUT EVERYTHING BEFORE

ffix = ffix{1};
ffix = str2num(ffix);

rX(1:ffix) = [];
rY(1:ffix) = [];
rZ(1:ffix) = [];
Frame(1:ffix) = [];
Time(1:ffix) = [];
sel(1:ffix) = [];

putvar(rX,rY,rZ,Frame,Time,sel);

%%%%%%%%%%%%
% RESAMPLE %
%%%%%%%%%%%%

% UPSAMPLE (INTERP)
rX = interp(rX,100);
rY = interp(rY,100);
rZ = interp(rZ,100);
Frame = interp(Frame,100);
Time = interp(Time,100);

% DOWNSAMPLE (DECIMATE)
rX = decimate(rX,6);
rY = decimate(rY,6);
rZ = decimate(rZ,6);
Frame = decimate(Frame,6);
Time = decimate(Time,6);
sel = rX*0;

putvar(rX,rY,rZ,Frame,Time,sel,cfg,vis);
% ii_replot;

%%%%%%%%%%%%%%%%%%%
% SIZE UP & SHAVE %
%%%%%%%%%%%%%%%%%%%
% FIND THE LESS OF THE 2 AND CHOP THE LARGER

sr = size(rX(:,1));
se = size(X(:,1));
sr = sr(1);
se = se(1);

if sr > se
    rX(se+1:sr) = [];
    rY(se+1:sr) = [];
    rZ(se+1:sr) = [];
    Frame(se+1:sr) = [];
    Time(se+1:sr) = [];
    putvar(rX,rY,rZ,Frame,Time);
elseif sr < se
    X(sr+1:se) = [];
    Y(sr+1:se) = [];
    TarX(sr+1:se) = [];
    TarY(sr+1:se) = [];
    XDAT(sr+1:se) = [];
    Pupil(sr+1:se) = [];
    putvar(X,Y,TarX,TarY,XDAT,Pupil);
else
    disp('Size is the same');
end


%%%%%%%%%%%%%%
% SAVE MERGE %
%%%%%%%%%%%%%%

ii_saveiye();
end

