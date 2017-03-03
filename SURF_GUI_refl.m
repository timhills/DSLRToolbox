function varargout = SURF_GUI_refl(varargin)
% SURF_GUI_REFL MATLAB code for SURF_GUI_refl.fig
%      SURF_GUI_REFL, by itself, creates a new SURF_GUI_REFL or raises the existing
%      singleton*.
%
%      H = SURF_GUI_REFL returns the handle to a new SURF_GUI_REFL or the handle to
%      the existing singleton*.
%
%      SURF_GUI_REFL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SURF_GUI_REFL.M with the given input arguments.
%
%      SURF_GUI_REFL('Property','Value',...) creates a new SURF_GUI_REFL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SURF_GUI_refl_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SURF_GUI_refl_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SURF_GUI_refl

% Last Modified by GUIDE v2.5 25-Sep-2014 11:35:32

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SURF_GUI_refl_OpeningFcn, ...
                   'gui_OutputFcn',  @SURF_GUI_refl_OutputFcn, ...
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


% --- Executes just before SURF_GUI_refl is made visible.
function SURF_GUI_refl_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SURF_GUI_refl (see VARARGIN)

% Choose default command line output for SURF_GUI_refl
handles.output = hObject;
set(handles.pushbutton1,'Visible','on');
set(handles.edit1,'Visible','on');
global I1 I2
blobs1 = detectSURFFeatures(I1, 'MetricThreshold', 2000);
blobs2 = detectSURFFeatures(I2, 'MetricThreshold', 2000);
Strong1=blobs1.selectStrongest(10);
Strong2=blobs2.selectStrongest(10);
handles.Strong1=Strong1;
handles.Strong2=Strong2;
J1=insertMarker(I1,Strong1.Location);
J2=insertMarker(I2,Strong2.Location);

axes(handles.axes1)
imshow(J1)
axes(handles.axes2)
imshow(J2)

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes SURF_GUI_refl wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = SURF_GUI_refl_OutputFcn(hObject, eventdata, handles) 
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
set(handles.pushbutton1,'Visible','off');
set(handles.edit1,'Visible','off');
UISelectPoints(handles)


function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
