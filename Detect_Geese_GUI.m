function varargout = Detect_Geese_GUI(varargin)
% DETECT_GEESE_GUI MATLAB code for Detect_Geese_GUI.fig
%      DETECT_GEESE_GUI, by itself, creates a new DETECT_GEESE_GUI or raises the existing
%      singleton*.
%
%      H = DETECT_GEESE_GUI returns the handle to a new DETECT_GEESE_GUI or the handle to
%      the existing singleton*.
%
%      DETECT_GEESE_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DETECT_GEESE_GUI.M with the given input arguments.
%
%      DETECT_GEESE_GUI('Property','Value',...) creates a new DETECT_GEESE_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Detect_Geese_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Detect_Geese_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Detect_Geese_GUI

% Last Modified by GUIDE v2.5 16-Feb-2015 17:30:47

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Detect_Geese_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @Detect_Geese_GUI_OutputFcn, ...
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


% --- Executes just before Detect_Geese_GUI is made visible.
function Detect_Geese_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Detect_Geese_GUI (see VARARGIN)

% Choose default command line output for Detect_Geese_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Detect_Geese_GUI wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Detect_Geese_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure

varargout{1} = handles;




function Start_Image_Num_Callback(hObject, eventdata, handles)
% hObject    handle to Start_Image_Num (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Start_Image_Num as text
%        str2double(get(hObject,'String')) returns contents of Start_Image_Num as a double


% --- Executes during object creation, after setting all properties.
function Start_Image_Num_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Start_Image_Num (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Num_of_Images_Callback(hObject, eventdata, handles)
% hObject    handle to Num_of_Images (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Num_of_Images as text
%        str2double(get(hObject,'String')) returns contents of Num_of_Images as a double


% --- Executes during object creation, after setting all properties.
function Num_of_Images_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Num_of_Images (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isappdata(0,'FullDataSet')
    rmappdata(0,'FullDataSet') 
end
Images = Start_Detect_Geese(handles);
setappdata(0,'GeeseImages',Images)
CurrentImage=1;
setappdata(0,'ImageIndex',CurrentImage);
Image_Selector_Geese

% DetectGeese
close('Detect_Geese_GUI')
