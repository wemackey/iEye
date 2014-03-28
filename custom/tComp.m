function varargout = tComp(varargin)
% TCOMP MATLAB code for tComp.fig
%      TCOMP, by itself, creates a new TCOMP or raises the existing
%      singleton*.
%
%      H = TCOMP returns the handle to a new TCOMP or the handle to
%      the existing singleton*.
%
%      TCOMP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TCOMP.M with the given input arguments.
%
%      TCOMP('Property','Value',...) creates a new TCOMP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before tComp_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to tComp_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help tComp

% Last Modified by GUIDE v2.5 27-Mar-2014 12:10:07

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @tComp_OpeningFcn, ...
                   'gui_OutputFcn',  @tComp_OutputFcn, ...
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


% --- Executes just before tComp is made visible.
function tComp_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to tComp (see VARARGIN)

% Choose default command line output for tComp
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes tComp wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = tComp_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ii_cfg = evalin('base','ii_cfg');
r = evalin('base','r');
ii_stats = evalin('base','ii_stats');
trial_compliance = ii_stats(r).trial_compliance;
trial_compliance(ii_cfg.tindex,1) = 0;
ii_stats(r).trial_compliance = trial_compliance;
putvar(ii_stats);


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ii_cfg = evalin('base','ii_cfg');
r = evalin('base','r');
ii_stats = evalin('base','ii_stats');
trial_compliance = ii_stats(r).trial_compliance;
trial_compliance(ii_cfg.tindex,2) = 0;
ii_stats(r).trial_compliance = trial_compliance;
putvar(ii_stats);


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ii_cfg = evalin('base','ii_cfg');
r = evalin('base','r');
ii_stats = evalin('base','ii_stats');
trial_compliance = ii_stats(r).trial_compliance;
trial_compliance(ii_cfg.tindex,3) = 0;
ii_stats(r).trial_compliance = trial_compliance;
putvar(ii_stats);


% --- Executes on button press in calcAcc.
function calcAcc_Callback(hObject, eventdata, handles)
% hObject    handle to calcAcc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

ii_cfg = evalin('base','ii_cfg');
ii_stats = evalin('base','ii_stats');
r = evalin('base','r');
x = evalin('base','X');
y = evalin('base','Y');
cursel = sort(ii_cfg.cursel);

% Make sure there are 90 selections, then get raw x and y positions
nsel = size(cursel);

if nsel(1) == 90
    raw_x = zeros(90,1);
    raw_y = zeros(90,1);
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
        
    end
    
    % Split our matrix into the appropriate saccades (i.e. primary, final,
    % corrective)
    
    [pX,fX,cX,pY,fY,cY] = ii_splitacc(raw_x,raw_y);
    [p_theta, p_rho] = cart2pol(pX,pY);
    [f_theta, f_rho] = cart2pol(fX,fY);
    [c_theta, c_rho] = cart2pol(cX,cY);
    
    [p_eX,p_eY,p_eZ,p_gX,p_gY,p_gZ] = ii_calcerror(pX,cX,pY,cY);
    [f_eX,f_eY,f_eZ,f_gX,f_gY,f_gZ] = ii_calcerror(fX,cX,fY,cY);
    
    p_eR = abs(c_rho - p_rho);
    f_eR = abs(c_rho - f_rho);
    p_eT = abs(c_theta - p_theta);
    f_eT = abs(c_theta - f_theta);
    
    p_gR = p_rho./c_rho;
    f_gR = f_rho./c_rho;    
    p_gT = p_theta./c_theta;
    f_gT = p_theta./c_theta;
    
    ii_stats(r).primary_x = pX;
    ii_stats(r).primary_y = pY;
    ii_stats(r).primary_rho = p_theta;
    ii_stats(r).primary_theta = p_rho;
    
    ii_stats(r).primary_err_x = p_eX;
    ii_stats(r).primary_err_y = p_eY;
    ii_stats(r).primary_err_z = p_eZ;
    ii_stats(r).primary_err_rho = p_eR;
    ii_stats(r).primary_err_theta = p_eT;
    
    ii_stats(r).primary_gain_x = p_gX;
    ii_stats(r).primary_gain_y = p_gY;
    ii_stats(r).primary_gain_z = p_gZ;
    ii_stats(r).primary_gain_rho = p_gR;
    ii_stats(r).primary_gain_theta = p_gT;
    
    ii_stats(r).final_x = fX;
    ii_stats(r).final_y = fY;
    ii_stats(r).final_rho = f_theta;
    ii_stats(r).final_theta = f_rho;
    
    ii_stats(r).final_err_x = f_eX;
    ii_stats(r).final_err_y = f_eY;
    ii_stats(r).final_err_z = f_eZ;
    ii_stats(r).final_err_rho = f_eR;
    ii_stats(r).final_err_theta = f_eT;
    
    ii_stats(r).final_gain_x = f_gX;
    ii_stats(r).final_gain_y = f_gY;
    ii_stats(r).final_gain_z = f_gZ;
    ii_stats(r).final_gain_rho = f_gR;
    ii_stats(r).final_gain_theta = f_gT;
    
    ii_stats(r).corrective_x = cX;
    ii_stats(r).corrective_y = cY;
    ii_stats(r).corrective_rho = c_theta;
    ii_stats(r).corrective_theta = c_rho;
    
    ii_stats(r).raw_x = raw_x;
    ii_stats(r).raw_y = raw_y;
    
    ii_stats(r).acc_cursel = cursel;
    ii_stats(r).acc_sel = ii_cfg.sel;
    
    putvar(ii_stats)
    
    disp('Calculation successful. Remember to save your data!');
else
    error('ERROR: Not enough selections!');
end


% --- Executes on button press in calcSRT.
function calcSRT_Callback(hObject, eventdata, handles)
% hObject    handle to calcSRT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

ii_cfg = evalin('base','ii_cfg');
ii_stats = evalin('base','ii_stats');
r = evalin('base','r');
cursel = sort(ii_cfg.cursel);
sel = ii_cfg.sel;

% Make sure there are 30 selections

nsel = size(cursel);

if nsel(1) == 30
    cursel = ii_cfg.cursel;
    nSRT = cursel(:,2) - cursel(:,1);
    ii_stats(r).srt = nSRT;
    ii_stats(r).srt_cursel = cursel;
    ii_stats(r).srt_sel = sel;
    putvar(ii_stats);
    disp(nSRT);
    disp('Calculation successful. Remember to save your data!');
else
    error('ERROR: Not enough selections!');
end


% --- Executes on button press in calcMS.
function calcMS_Callback(hObject, eventdata, handles)
% hObject    handle to calcMS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% This must be done after SRT has already been calculated because it uses
% the saccade selections used in the SRT calculations to identify the
% correct saccades to compute the main sequence. Basically, it takes the
% end of the SRT selection (the beginning of the saccade we are interested
% in) and makes that the beginning of the new selection.

ii_cfg = evalin('base','ii_cfg');
ii_stats = evalin('base','ii_stats');
r = evalin('base','r');
vel = evalin('base','vel');
cursel = sort(ii_cfg.cursel);
sel = ii_cfg.sel;

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
    ii_stats(r).ms_duration = nDuration;
    ii_stats(r).ms_peak_velocity = pvel;
    ii_stats(r).ms_cursel = cursel;
    ii_stats(r).ms_sel = sel;
    putvar(ii_stats);
    disp('Calculation successful. Remember to save your data!');
else
    error('ERROR: Not enough selections!');
end



function txtNote_Callback(hObject, eventdata, handles)
% hObject    handle to txtNote (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtNote as text
%        str2double(get(hObject,'String')) returns contents of txtNote as a double


% --- Executes during object creation, after setting all properties.
function txtNote_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtNote (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in addNote.
function addNote_Callback(hObject, eventdata, handles)
% hObject    handle to addNote (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

ii_cfg = evalin('base','ii_cfg');
r = evalin('base','r');
ii_stats = evalin('base','ii_stats');
trial_notes = ii_stats(r).trial_notes;
the_note = get(handles.txtNote,'String');
trial_notes{ii_cfg.tindex} = the_note;
ii_stats(r).trial_notes = trial_notes;
putvar(ii_stats);
