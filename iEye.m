function varargout = iEye(varargin)
% IEYE_DISPLAY M-file for iEye_Display.fig
%      IEYE_DISPLAY, by itself, creates a new IEYE_DISPLAY or raises the existing
%      singleton*.
%
%      H = IEYE_DISPLAY returns the handle to a new IEYE_DISPLAY or the handle to
%      the existing singleton*.
%
%      IEYE_DISPLAY('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in IEYE_DISPLAY.M with the given input arguments.
%
%      IEYE_DISPLAY('Property','Value',...) creates a new IEYE_DISPLAY or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before iEye_Display_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to iEye_Display_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help iEye_Display

% Last Modified by GUIDE v2.5 30-Jan-2013 13:36:42

% Begin initialization code - DO NOT EDIT

global sft
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @iEye_OpeningFcn, ...
                   'gui_OutputFcn',  @iEye_OutputFcn, ...
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

function OnClickAxes( hObject, eventdata, handles )
global sft

hax = handles.axes1;
point1 = get(hax,'CurrentPoint'); % button down detected
finalRect = rbbox; % return figure units
point2 = get(hax,'CurrentPoint'); % button up detected

ii_cfg = evalin('base', 'ii_cfg');
cursel = ii_cfg.cursel;
sel = ii_cfg.sel;

point1 = point1(1,1:2); % extract x and y
point2 = point2(1,1:2);
p1 = min(point1,point2); % calculate locations
offset = abs(point1-point2); % and dimensions

minx = min(point1(1),point2(1));
maxx = max(point1(1),point2(1));
xdif = maxx - minx;

if xdif == 0
    disp('Selection too small');
else
    
    x = [p1(1) p1(1)+offset(1) p1(1)+offset(1) p1(1) p1(1)];
    y = [p1(2) p1(2) p1(2)+offset(2) p1(2)+offset(2) p1(2)];
    
    k = size(cursel,1)+1;
    
    cursel(k,1) = ceil(minx);
    cursel(k,2) = ceil(maxx);
    
    if sft == 1
        for i=1:(size(cursel,1))
            sel(cursel(k,1):cursel(k,2)) = 0;
        end
    else
        for i=1:(size(cursel,1))
            sel(cursel(i,1):cursel(i,2)) = 1;
        end
    end
    
    ii_cfg.cursel = cursel;
    ii_cfg.sel = sel;
    putvar(ii_cfg);
    ii_showselections;
end

% --- Executes just before iEye_Display is made visible.
function iEye_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to iEye_Display (see VARARGIN)

% Choose default command line output for iEye_Display
handles.output = hObject;

handles.Main = [];
grid on;
% Update handles structure
guidata(hObject, handles);


% UIWAIT makes iEye_Display wait for user response (see UIRESUME)
% uiwait(handles.iEye);


% --- Outputs from this function are returned to the command line.
function varargout = iEye_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function uipushtool1_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushtool1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function uitoggletool4_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uitoggletool4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pan xon


% --------------------------------------------------------------------
function uitoggletool2_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uitoggletool2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
zoom xon


% --------------------------------------------------------------------
function uipushtool4_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushtool4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pan off
zoom off
hax = handles.axes1;
set(hax,'ButtonDownFcn',{@OnClickAxes, handles});


% --------------------------------------------------------------------
function uitoggletool8_OffCallback(hObject, eventdata, handles)
% hObject    handle to uitoggletool8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --------------------------------------------------------------------
function uipushtool6_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushtool6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ii_replot;


% --------------------------------------------------------------------
function mnuFile_Callback(hObject, eventdata, handles)
% hObject    handle to mnuFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function mnuOpen_Callback(hObject, eventdata, handles)
% hObject    handle to mnuOpen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ii_openiye;


% --------------------------------------------------------------------
function mnuClose_Callback(hObject, eventdata, handles)
% hObject    handle to mnuClose (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clear all;
axes(handles.axes1);
cla;

% --------------------------------------------------------------------
function mnuSaveAs_Callback(hObject, eventdata, handles)
% hObject    handle to mnuSaveAs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ii_saveiye;

% --------------------------------------------------------------------
function mnuImport_Callback(hObject, eventdata, handles)
% hObject    handle to mnuImport (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function mnuExport_Callback(hObject, eventdata, handles)
% hObject    handle to mnuExport (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function mnuPrint_Callback(hObject, eventdata, handles)
% hObject    handle to mnuExport (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --------------------------------------------------------------------
function mnuExit_Callback(hObject, eventdata, handles)
% hObject    handle to mnuExit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
exit;


% --------------------------------------------------------------------
function mnuSelect_Callback(hObject, eventdata, handles)
% hObject    handle to mnuSelect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function mnuSelectAll_Callback(hObject, eventdata, handles)
% hObject    handle to mnuSelectAll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ii_selectall;


% --------------------------------------------------------------------
function mnuSelectEmpty_Callback(hObject, eventdata, handles)
% hObject    handle to mnuSelectEmpty (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ii_selectempty;


% --------------------------------------------------------------------
function mnuSelectInverse_Callback(hObject, eventdata, handles)
% hObject    handle to mnuSelectInverse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ii_selectinverse;


% --------------------------------------------------------------------
function mnuSelectSpecial_Callback(hObject, eventdata, handles)
% hObject    handle to mnuSelectSpecial (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ii_selectrange;


% --------------------------------------------------------------------
function mnuSelectByValue_Callback(hObject, eventdata, handles)
% hObject    handle to mnuSelectByValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ii_selectbyvalue;


% --------------------------------------------------------------------
function mnuSelectStretch_Callback(hObject, eventdata, handles)
% hObject    handle to mnuSelectStretch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ii_selectstretch;


% --------------------------------------------------------------------
function mnuView_Callback(hObject, eventdata, handles)
% hObject    handle to mnuView (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function mnuChannel_Callback(hObject, eventdata, handles)
% hObject    handle to mnuChannel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --------------------------------------------------------------------
function mnuViewReset_Callback(hObject, eventdata, handles)
% hObject    handle to mnuViewReset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ii_replot;

% --------------------------------------------------------------------
function mnuViewXvsY_Callback(hObject, eventdata, handles)
% hObject    handle to mnuViewXvsY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ii_graphxy;


% --------------------------------------------------------------------
function mnuChannelNew_Callback(hObject, eventdata, handles)
% hObject    handle to mnuChannelNew (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ii_newchan;

% --------------------------------------------------------------------
function mnuDeleteChannel_Callback(hObject, eventdata, handles)
% hObject    handle to mnuDeleteChannel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ii_deletechan;

% --------------------------------------------------------------------
function mnuModify_Callback(hObject, eventdata, handles)
% hObject    handle to mnuModify (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function mnuModifyArithmetic_Callback(hObject, eventdata, handles)
% hObject    handle to mnuModifyArithmetic (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function mnuModifyCalibrate_Callback(hObject, eventdata, handles)
% hObject    handle to mnuModifyCalibrate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function mnuModifyMath_Callback(hObject, eventdata, handles)
% hObject    handle to mnuModifyMath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function mnuModifyFilter_Callback(hObject, eventdata, handles)
% hObject    handle to mnuModifyFilter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function mnuModifyShiftTime_Callback(hObject, eventdata, handles)
% hObject    handle to mnuModifyShiftTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ii_shift;


% --------------------------------------------------------------------
function mnuMathDifferentiate_Callback(hObject, eventdata, handles)
% hObject    handle to mnuMathDifferentiate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ii_diff;


% --------------------------------------------------------------------
function mnuMathSquare_Callback(hObject, eventdata, handles)
% hObject    handle to mnuMathSquare (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ii_square;


% --------------------------------------------------------------------
function mnuMathSquareRoot_Callback(hObject, eventdata, handles)
% hObject    handle to mnuMathSquareRoot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ii_squareroot;


% --------------------------------------------------------------------
function mnuMathInverse_Callback(hObject, eventdata, handles)
% hObject    handle to mnuMathInverse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ii_inverse;



% --------------------------------------------------------------------
function mnuMathAbsoluteValue_Callback(hObject, eventdata, handles)
% hObject    handle to mnuMathAbsoluteValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ii_abs;


% --------------------------------------------------------------------
function mnuCalibrateAutoscale_Callback(hObject, eventdata, handles)
% hObject    handle to mnuCalibrateAutoscale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ii_autoscale;


% --------------------------------------------------------------------
function mnuCalibrateTo_Callback(hObject, eventdata, handles)
% hObject    handle to mnuCalibrateTo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ii_calibrateto;



% --------------------------------------------------------------------
function mnuFilterSmooth_Callback(hObject, eventdata, handles)
% hObject    handle to mnuFilterSmooth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ii_smooth;


% --- Executes on mouse press over axes background.
function axes1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function mnuSelectUntil_Callback(hObject, eventdata, handles)
% hObject    handle to mnuSelectUntil (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ii_selectuntil;


% --------------------------------------------------------------------
function mnuShowSelections_Callback(hObject, eventdata, handles)
% hObject    handle to mnuShowSelections (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ii_showselections;


% --------------------------------------------------------------------
function mnuHideSelections_Callback(hObject, eventdata, handles)
% hObject    handle to mnuHideSelections (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ii_hideselections;


% --------------------------------------------------------------------
function mnuReplot_Callback(hObject, eventdata, handles)
% hObject    handle to mnuReplot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ii_replot;


% --------------------------------------------------------------------
function mnuViewTrials_Callback(hObject, eventdata, handles)
% hObject    handle to mnuViewTrials (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ii_trials;


% --------------------------------------------------------------------
function mnuModifyAdd_Callback(hObject, eventdata, handles)
% hObject    handle to mnuModifyAdd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ii_add;

% --------------------------------------------------------------------
function mnuModifySubtract_Callback(hObject, eventdata, handles)
% hObject    handle to mnuModifySubtract (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ii_subtract;

% --------------------------------------------------------------------
function mnuModifyMultiply_Callback(hObject, eventdata, handles)
% hObject    handle to mnuModifyMultiply (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ii_multiply;

% --------------------------------------------------------------------
function mnuModifyDivide_Callback(hObject, eventdata, handles)
% hObject    handle to mnuModifyDivide (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ii_divide;


% --------------------------------------------------------------------
function uitoggletool9_OffCallback(hObject, eventdata, handles)
% hObject    handle to uitoggletool9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axis auto
ii_replot;
ii_showselections;
trwin = iEye;
mainHandles = guidata(trwin);
trwinslider = mainHandles.uipushtool11;
trwinslider2 = mainHandles.uipushtool12;
trwinslider3 = mainHandles.uipushtool14;

set(trwinslider, 'Visible', 'Off');
set(trwinslider2, 'Visible', 'Off');
set(trwinslider3, 'Visible', 'Off');

% --------------------------------------------------------------------
function uitoggletool9_OnCallback(hObject, eventdata, handles)
% hObject    handle to uitoggletool9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axis auto
ii_trials;
trwin = iEye;
mainHandles = guidata(trwin);
trwinslider = mainHandles.uipushtool11;
trwinslider2 = mainHandles.uipushtool12;
trwinslider3 = mainHandles.uipushtool14;

set(trwinslider, 'Visible', 'On');
set(trwinslider2, 'Visible', 'On');
set(trwinslider3, 'Visible', 'On');

% --------------------------------------------------------------------
function uipushtool11_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushtool11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

ii_cfg = evalin('base', 'ii_cfg');
tcursel = ii_cfg.tcursel;
tindex = ii_cfg.tindex;
numt = size(tcursel,1);
newt = tindex - 1;

if newt > 0
    axis manual
    ii_trialplot(newt);
    axis auto
    ii_showselections;
    disp(['Currently at trial ' num2str(newt) ' out of ' num2str(numt)])
else
    disp('Currently at first trial')
end


% --------------------------------------------------------------------
function uipushtool12_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushtool12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

ii_cfg = evalin('base', 'ii_cfg');
tcursel = ii_cfg.tcursel;
tindex = ii_cfg.tindex;
numt = size(tcursel,1);
newt = tindex + 1;

if newt < numt
    axis manual
    ii_trialplot(newt);
    axis auto
    ii_showselections;
    disp(['Currently at trial ' num2str(newt) ' out of ' num2str(numt)])
else
    disp('Currently at last trial')
end


% --------------------------------------------------------------------
function uipushtool13_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushtool13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ii_hideselections;
axis auto
ii_showselections;


% --------------------------------------------------------------------
function uitoggletool10_OffCallback(hObject, eventdata, handles)
% hObject    handle to uitoggletool10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ii_hideselections;


% --------------------------------------------------------------------
function uitoggletool10_OnCallback(hObject, eventdata, handles)
% hObject    handle to uitoggletool10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ii_showselections;


% --------------------------------------------------------------------
function uitoggletool11_OffCallback(hObject, eventdata, handles)
% hObject    handle to uitoggletool11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global sft
sft = 0;


% --------------------------------------------------------------------
function uitoggletool11_OnCallback(hObject, eventdata, handles)
% hObject    handle to uitoggletool11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global sft
sft = 1;


% --------------------------------------------------------------------
function uipushtool14_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushtool14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ii_gotrial;


% --------------------------------------------------------------------
function mnuNewConfig_Callback(hObject, eventdata, handles)
% hObject    handle to mnuNewConfig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ii_new_ifg;


% --------------------------------------------------------------------
function mnuChanView_Callback(hObject, eventdata, handles)
% hObject    handle to mnuChanView (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ii_view_channels;


% --------------------------------------------------------------------
function mnuConvertEDF_Callback(hObject, eventdata, handles)
% hObject    handle to mnuConvertEDF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

ii_edf2iye;


% --------------------------------------------------------------------
function mnuMergeIYE_Callback(hObject, eventdata, handles)
% hObject    handle to mnuMergeIYE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ii_merge_iye;

% --------------------------------------------------------------------
function mnuConvertASC_Callback(hObject, eventdata, handles)
% hObject    handle to mnuConvertASC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ii_asc2iye;
