function varargout = i2d(varargin)
% I2D MATLAB code for i2d.fig
%      I2D, by itself, creates a new I2D or raises the existing
%      singleton*.
%
%      H = I2D returns the handle to a new I2D or the handle to
%      the existing singleton*.
%
%      I2D('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in I2D.M with the given input arguments.
%
%      I2D('Property','Value',...) creates a new I2D or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before i2d_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to i2d_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help i2d

% Last Modified by GUIDE v2.5 27-Jul-2015 15:05:49

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @i2d_OpeningFcn, ...
                   'gui_OutputFcn',  @i2d_OutputFcn, ...
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


% --- Executes just before i2d is made visible.
function i2d_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to i2d (see VARARGIN)

% Choose default command line output for i2d
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes i2d wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = i2d_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
