function varargout = multistep(varargin)
% MULTISTEP MATLAB code for multistep.fig
%      MULTISTEP, by itself, creates a new MULTISTEP or raises the existing
%      singleton*.
%
%      H = MULTISTEP returns the handle to a new MULTISTEP or the handle to
%      the existing singleton*.
%
%      MULTISTEP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MULTISTEP.M with the given input arguments.
%
%      MULTISTEP('Property','Value',...) creates a new MULTISTEP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before multistep_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to multistep_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help multistep

% Last Modified by GUIDE v2.5 31-Jul-2014 14:32:05

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @multistep_OpeningFcn, ...
                   'gui_OutputFcn',  @multistep_OutputFcn, ...
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


% --- Executes just before multistep is made visible.
function multistep_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to multistep (see VARARGIN)

% Choose default command line output for multistep
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes multistep wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = multistep_OutputFcn(hObject, eventdata, handles) 
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
mstep = ii_stats(r).mstep;
mstep(ii_cfg.tindex,1) = 1;
ii_stats(r).mstep = mstep;
cmsg = sprintf('(Trial # %s) is multistep', num2str(ii_cfg.tindex));
disp(cmsg);
putvar(ii_stats);


% --- Executes on button press in b1.
function b1_Callback(hObject, eventdata, handles)
% hObject    handle to b1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

ii_cfg = evalin('base','ii_cfg');
r = evalin('base','r');
ii_stats = evalin('base','ii_stats');
numstep = ii_stats(r).numstep;
numstep(ii_cfg.tindex,1) = 1;
ii_stats(r).numstep = numstep;
cmsg = sprintf('(Trial # %s) is multistep', num2str(ii_cfg.tindex));
disp(cmsg);
putvar(ii_stats);

% --- Executes on button press in b2.
function b2_Callback(hObject, eventdata, handles)
% hObject    handle to b2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

ii_cfg = evalin('base','ii_cfg');
r = evalin('base','r');
ii_stats = evalin('base','ii_stats');
numstep = ii_stats(r).numstep;
numstep(ii_cfg.tindex,1) = 2;
ii_stats(r).numstep = numstep;
cmsg = sprintf('(Trial # %s) is multistep', num2str(ii_cfg.tindex));
disp(cmsg);
putvar(ii_stats);

% --- Executes on button press in b3.
function b3_Callback(hObject, eventdata, handles)
% hObject    handle to b3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

ii_cfg = evalin('base','ii_cfg');
r = evalin('base','r');
ii_stats = evalin('base','ii_stats');
numstep = ii_stats(r).numstep;
numstep(ii_cfg.tindex,1) = 3;
ii_stats(r).numstep = numstep;
cmsg = sprintf('(Trial # %s) is multistep', num2str(ii_cfg.tindex));
disp(cmsg);
putvar(ii_stats);

% --- Executes on button press in b4.
function b4_Callback(hObject, eventdata, handles)
% hObject    handle to b4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

ii_cfg = evalin('base','ii_cfg');
r = evalin('base','r');
ii_stats = evalin('base','ii_stats');
numstep = ii_stats(r).numstep;
numstep(ii_cfg.tindex,1) = 4;
ii_stats(r).numstep = numstep;
cmsg = sprintf('(Trial # %s) is multistep', num2str(ii_cfg.tindex));
disp(cmsg);
putvar(ii_stats);

% --- Executes on button press in b5.
function b5_Callback(hObject, eventdata, handles)
% hObject    handle to b5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

ii_cfg = evalin('base','ii_cfg');
r = evalin('base','r');
ii_stats = evalin('base','ii_stats');
numstep = ii_stats(r).numstep;
numstep(ii_cfg.tindex,1) = 5;
ii_stats(r).numstep = numstep;
cmsg = sprintf('(Trial # %s) is multistep', num2str(ii_cfg.tindex));
disp(cmsg);
putvar(ii_stats);

% --- Executes on button press in b6.
function b6_Callback(hObject, eventdata, handles)
% hObject    handle to b6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

ii_cfg = evalin('base','ii_cfg');
r = evalin('base','r');
ii_stats = evalin('base','ii_stats');
numstep = ii_stats(r).numstep;
numstep(ii_cfg.tindex,1) = 6;
ii_stats(r).numstep = numstep;
cmsg = sprintf('(Trial # %s) is multistep', num2str(ii_cfg.tindex));
disp(cmsg);
putvar(ii_stats);


% --- Executes on button press in corsac.
function corsac_Callback(hObject, eventdata, handles)
% hObject    handle to corsac (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

ii_cfg = evalin('base','ii_cfg');
ii_stats = evalin('base','ii_stats');
r = evalin('base','r');
sel = ii_cfg.sel;

b = find(sel==1);
split1 = SplitVec(b,'consecutive','firstval');
split2 = SplitVec(b,'consecutive','lastval');

cursel(:,1) = split1;
cursel(:,2) = split2;

ii_stats(r).corsac_cursel = cursel;
ii_stats(r).corsac_sel = sel;
putvar(ii_stats);
disp('Calculation successful. Remember to save your data!');
