function varargout = tinfo(varargin)
% TINFO MATLAB code for tinfo.fig
%      TINFO, by itself, creates a new TINFO or raises the existing
%      singleton*.
%
%      H = TINFO returns the handle to a new TINFO or the handle to
%      the existing singleton*.
%
%      TINFO('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TINFO.M with the given input arguments.
%
%      TINFO('Property','Value',...) creates a new TINFO or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before tinfo_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to tinfo_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help tinfo

% Last Modified by GUIDE v2.5 25-Mar-2014 15:57:41

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @tinfo_OpeningFcn, ...
                   'gui_OutputFcn',  @tinfo_OutputFcn, ...
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


% --- Executes just before tinfo is made visible.
function tinfo_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to tinfo (see VARARGIN)

% Choose default command line output for tinfo
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);


% UIWAIT makes tinfo wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = tinfo_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in next_Button.
function next_Button_Callback(hObject, eventdata, handles)
% hObject    handle to next_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

ii_cfg = evalin('base', 'ii_cfg');
tcursel = ii_cfg.tcursel;
tindex = ii_cfg.tindex;
tindex = tindex + 1;

numt = size(tcursel,1);

if tindex <= numt
    ii_cfg.tindex = tindex;
    cnames = {};
    
    vis = ii_cfg.vis;
    v = textscan(vis,'%s','delimiter',',');
    
    qq = tcursel(tindex,:);
    rng = qq(2) - qq(1);
    selstrt = qq(1);
    selend = qq(2);
    
    for w = 1:rng
        sm{w,1} = selstrt;
        selstrt = selstrt + 1;
    end
    
    sm = cell2mat(sm);
    selstrt = qq(1);
    p = [];
    
    col = lines(length(v{1}));
    
    tt = sprintf('Trial #: %s', num2str(tindex));
    set(handles.trial_Text,'String', tt);
    
    % Plot timeseries
    
    cla(handles.ts_axes);
    hold(handles.ts_axes,'on')
    for i = 1:length(v{1})
        c = v{1}{i};
        d = 1;
        chan = evalin('base', c);
        cnames{end+1} = c;
        for w = qq(1)+1:qq(2)
            p(d,i) = chan(w);
            d = d + 1;
        end
        csel = p(:,i);
        plot(handles.ts_axes,sm,csel,'color',col(i,:));
        
    end
    
    % Plot blinks on timeseries if they exist
    
    blinks = ii_cfg.blink;
    
    if ~isempty(blinks)
        X = evalin('base','X');
        Y = evalin('base','Y');
        
        XB = X*NaN;
        YB = Y*NaN;
        
        XB(blinks) = X(blinks);
        YB(blinks) = Y(blinks);
        
        d = 1;
        for w = qq(1)+1:qq(2)
            XBP(d) = XB(w);
            d = d + 1;
        end
        
        d = 1;
        for w = qq(1)+1:qq(2)
            YBP(d) = YB(w);
            d = d + 1;
        end
        hold all
        plot(handles.ts_axes,sm,XBP,'k*');
        plot(handles.ts_axes,sm,YBP,'k*');
    else
    end
    
    % Plot spatial information
    
    X = evalin('base','X');
    Y = evalin('base','Y');
    TarX = evalin('base','TarX');
    TarY = evalin('base','TarY');
    
    d = 1;
    for w = qq(1)+1:qq(2)
        x(d) = X(w);
        y(d) = Y(w);
        tx(d) = TarX(w);
        ty(d) = TarY(w);
        d = d + 1;
    end
    
    cla(handles.space_axes);
    plot(handles.space_axes,x,y,'LineStyle', ':','Color','r');
    hold all
    plot(handles.space_axes,tx,ty,'LineStyle', '*','Color','k');
    axis([-11 11 -11 11])
    
    ii_cfg.tindex = tindex;
    putvar(ii_cfg);
else
    disp('Currently at last trial')
end


% --- Executes on button press in previous_Button.
function previous_Button_Callback(hObject, eventdata, handles)
% hObject    handle to previous_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


ii_cfg = evalin('base', 'ii_cfg');
tcursel = ii_cfg.tcursel;
tindex = ii_cfg.tindex;
tindex = tindex - 1;

if tindex > 0
    ii_cfg.tindex = tindex;
    cnames = {};
    
    vis = ii_cfg.vis;
    v = textscan(vis,'%s','delimiter',',');
    
    qq = tcursel(tindex,:);
    rng = qq(2) - qq(1);
    selstrt = qq(1);
    selend = qq(2);
    
    for w = 1:rng
        sm{w,1} = selstrt;
        selstrt = selstrt + 1;
    end
    
    sm = cell2mat(sm);
    selstrt = qq(1);
    p = [];
    
    col = lines(length(v{1}));
    
    tt = sprintf('Trial #: %s', num2str(tindex));
    set(handles.trial_Text,'String', tt);
    
    % Plot timeseries
    
    cla(handles.ts_axes);
    hold(handles.ts_axes,'on')
    for i = 1:length(v{1})
        c = v{1}{i};
        d = 1;
        chan = evalin('base', c);
        cnames{end+1} = c;
        for w = qq(1)+1:qq(2)
            p(d,i) = chan(w);
            d = d + 1;
        end
        csel = p(:,i);
        plot(handles.ts_axes,sm,csel,'color',col(i,:));
        
    end
    
    % Plot blinks on timeseries if they exist
    
    blinks = ii_cfg.blink;
    
    if ~isempty(blinks)
        X = evalin('base','X');
        Y = evalin('base','Y');
        
        XB = X*NaN;
        YB = Y*NaN;
        
        XB(blinks) = X(blinks);
        YB(blinks) = Y(blinks);
        
        d = 1;
        for w = qq(1)+1:qq(2)
            XBP(d) = XB(w);
            d = d + 1;
        end
        
        d = 1;
        for w = qq(1)+1:qq(2)
            YBP(d) = YB(w);
            d = d + 1;
        end
        hold all
        plot(handles.ts_axes,sm,XBP,'k*');
        plot(handles.ts_axes,sm,YBP,'k*');
    else
    end
    
    % Plot spatial information
    
    X = evalin('base','X');
    Y = evalin('base','Y');
    TarX = evalin('base','TarX');
    TarY = evalin('base','TarY');
    
    d = 1;
    for w = qq(1)+1:qq(2)
        x(d) = X(w);
        y(d) = Y(w);
        tx(d) = TarX(w);
        ty(d) = TarY(w);
        d = d + 1;
    end
    
    cla(handles.space_axes);
    plot(handles.space_axes,x,y,'LineStyle', ':','Color','r');
    hold all
    plot(handles.space_axes,tx,ty,'LineStyle', '*','Color','k');
    axis([-11 11 -11 11])
    
    ii_cfg.tindex = tindex;
    putvar(ii_cfg);
else
    disp('Currently at first trial')
end


% --- Executes on button press in define_Button.
function define_Button_Callback(hObject, eventdata, handles)
% hObject    handle to define_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

ii_definetrial;


% --- Executes on mouse press over axes background.
function ts_axes_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to ts_axes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
