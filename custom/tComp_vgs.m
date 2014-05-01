function varargout = tComp_vgs(varargin)
% TCOMP_VGS MATLAB code for tComp_vgs.fig
%      TCOMP_VGS, by itself, creates a new TCOMP_VGS or raises the existing
%      singleton*.
%
%      H = TCOMP_VGS returns the handle to a new TCOMP_VGS or the handle to
%      the existing singleton*.
%
%      TCOMP_VGS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TCOMP_VGS.M with the given input arguments.
%
%      TCOMP_VGS('Property','Value',...) creates a new TCOMP_VGS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before tComp_vgs_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to tComp_vgs_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help tComp_vgs

% Last Modified by GUIDE v2.5 01-May-2014 12:20:46

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @tComp_vgs_OpeningFcn, ...
                   'gui_OutputFcn',  @tComp_vgs_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before tComp_vgs is made visible.
function tComp_vgs_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to tComp_vgs (see VARARGIN)

% Choose default command line output for tComp_vgs
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes tComp_vgs wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = tComp_vgs_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in calcSRT.
function calcSRT_Callback(hObject, eventdata, handles)
% hObject    handle to calcSRT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


ii_cfg = evalin('base','ii_cfg');
ii_stats_vgs = evalin('base','ii_stats_vgs');
r = evalin('base','r');
sel = ii_cfg.sel;

b = find(sel==1);
split1 = SplitVec(b,'consecutive','firstval');
split2 = SplitVec(b,'consecutive','lastval');

cursel(:,1) = split1;
cursel(:,2) = split2;

% Make sure there are 30 selections

nsel = size(cursel);

if nsel(1) == 30
    nSRT = cursel(:,2) - cursel(:,1);
    ii_stats_vgs(r).srt = nSRT;
    ii_stats_vgs(r).srt_cursel = cursel;
    ii_stats_vgs(r).srt_sel = sel;
    putvar(ii_stats_vgs);
    disp(nSRT);
    disp('Calculation successful. Remember to save your data!');
else
    error('ERROR: Not enough selections!');
end


% --- Executes on button press in calcACC.
function calcACC_Callback(hObject, eventdata, handles)
% hObject    handle to calcACC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


ii_cfg = evalin('base','ii_cfg');
ii_stats_vgs = evalin('base','ii_stats_vgs');
r = evalin('base','r');
x = evalin('base','X');
y = evalin('base','Y');
tarx = evalin('base','TarX');
tary = evalin('base','TarY');
sel = ii_cfg.sel;

b = find(sel==1);
split1 = SplitVec(b,'consecutive','firstval');
split2 = SplitVec(b,'consecutive','lastval');

cursel(:,1) = split1;
cursel(:,2) = split2;

% Make sure there are 60 selections, then get raw x and y positions
nsel = size(cursel);

if nsel(1) == 60
    raw_x = zeros(60,1);
    raw_y = zeros(60,1);
    raw_tx = zeros(60,1);
    raw_ty = zeros(60,1);
    for g = 1:nsel
        sel = x*0;
        qq = cursel(g,:);
        rng = qq(2) - qq(1);
        selstrt = qq(1);
        selend = qq(2);
        
        for z=1:rng
            sel(selstrt:selend) = 1;
        end
        
        raw_x(g) = mean(x(sel==1));
        raw_y(g) = mean(y(sel==1));
        raw_tx(g) = mean(tx(sel==1));
        raw_ty(g) = mean(ty(sel==1));
        
    end
    
    % Split our matrix into the appropriate saccades (i.e. primary, final,
    % corrective)
    
    [pX,fX,tX,pY,fY,tY] = ii_split_acc_vgs(raw_x,raw_y,raw_tx,raw_ty);
    [p_theta, p_rho] = cart2pol(pX,pY);
    [f_theta, f_rho] = cart2pol(fX,fY);
    [t_theta, t_rho] = cart2pol(tX,tY);
    
    [p_eX,p_eY,p_eZ,p_gX,p_gY,p_gZ] = ii_calcerror(pX,fX,pY,fY);
    [f_eX,f_eY,f_eZ,f_gX,f_gY,f_gZ] = ii_calcerror(fX,tX,fY,tY);
    
    p_eR = abs(f_rho - p_rho);
    f_eR = abs(t_rho - f_rho);
    p_eT = abs(f_theta - p_theta);
    f_eT = abs(t_theta - f_theta);
    
    p_gR = p_rho./f_rho;
    f_gR = f_rho./t_rho;    
    p_gT = p_theta./f_theta;
    f_gT = p_theta./t_theta;
    
    ii_stats_vgs(r).primary_x = pX;
    ii_stats_vgs(r).primary_y = pY;
    ii_stats_vgs(r).primary_rho = p_theta;
    ii_stats_vgs(r).primary_theta = p_rho;
    
    ii_stats_vgs(r).primary_err_x = p_eX;
    ii_stats_vgs(r).primary_err_y = p_eY;
    ii_stats_vgs(r).primary_err_z = p_eZ;
    ii_stats_vgs(r).primary_err_rho = p_eR;
    ii_stats_vgs(r).primary_err_theta = p_eT;
    
    ii_stats_vgs(r).primary_gain_x = p_gX;
    ii_stats_vgs(r).primary_gain_y = p_gY;
    ii_stats_vgs(r).primary_gain_z = p_gZ;
    ii_stats_vgs(r).primary_gain_rho = p_gR;
    ii_stats_vgs(r).primary_gain_theta = p_gT;
    
    ii_stats_vgs(r).final_x = fX;
    ii_stats_vgs(r).final_y = fY;
    ii_stats_vgs(r).final_rho = f_theta;
    ii_stats_vgs(r).final_theta = f_rho;
    
    ii_stats_vgs(r).final_err_x = f_eX;
    ii_stats_vgs(r).final_err_y = f_eY;
    ii_stats_vgs(r).final_err_z = f_eZ;
    ii_stats_vgs(r).final_err_rho = f_eR;
    ii_stats_vgs(r).final_err_theta = f_eT;
    
    ii_stats_vgs(r).final_gain_x = f_gX;
    ii_stats_vgs(r).final_gain_y = f_gY;
    ii_stats_vgs(r).final_gain_z = f_gZ;
    ii_stats_vgs(r).final_gain_rho = f_gR;
    ii_stats_vgs(r).final_gain_theta = f_gT;
    
    ii_stats_vgs(r).target_x = tX;
    ii_stats_vgs(r).target_y = tY;
    ii_stats_vgs(r).target_rho = t_theta;
    ii_stats_vgs(r).target_theta = t_rho;
    
    ii_stats_vgs(r).raw_x = raw_x;
    ii_stats_vgs(r).raw_y = raw_y;
    
    ii_stats_vgs(r).acc_cursel = cursel;
    ii_stats_vgs(r).acc_sel = ii_cfg.sel;
    
    putvar(ii_stats_vgs)
    
    disp('Calculation successful. Remember to save your data!');
else
    error('ERROR: Not enough selections!');
end

% --- Executes on button press in calcMS.
function calcMS_Callback(hObject, eventdata, handles)
% hObject    handle to calcMS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

ii_cfg = evalin('base','ii_cfg');
ii_stats_vgs = evalin('base','ii_stats_vgs');
r = evalin('base','r');
vel = evalin('base','vel');
sel = ii_cfg.sel;

b = find(sel==1);
split1 = SplitVec(b,'consecutive','firstval');
split2 = SplitVec(b,'consecutive','lastval');

cursel(:,1) = split1;
cursel(:,2) = split2;

% Make sure there are 30 selections

nsel = size(cursel);

if nsel(1) == 30

    pvel = zeros(30,1);
    avel = zeros(30,1);
    
    for g = 1:nsel
        sel =sel*0;
        qq = cursel(g,:);
        rng = qq(2) - qq(1);
        selstrt = qq(1);
        selend = qq(2);
        
        for z=1:rng
            sel(selstrt:selend) = 1;
        end
        
        avel(g) = mean(vel(sel==1));
        pvel(g) = max(vel(sel==1));
        
    end  

    nDuration = cursel(:,2) - cursel(:,1);
    ii_stats_vgs(r).ms_duration = nDuration;
    ii_stats_vgs(r).ms_peak_velocity = pvel;
    ii_stats_vgs(r).ms_avg_velocity = avel;
    ii_stats_vgs(r).ms_cursel = cursel;
    ii_stats_vgs(r).ms_sel = sel;
    putvar(ii_stats_vgs);
    disp('Calculation successful. Remember to save your data!');
else
    error('ERROR: Not enough selections!');
end
