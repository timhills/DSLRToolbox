function varargout = DetectGeese(varargin)
% DETECTGEESE MATLAB code for DetectGeese.fig
%      DETECTGEESE, by itself, creates a new DETECTGEESE or raises the existing
%      singleton*.
%
%      H = DETECTGEESE returns the handle to a new DETECTGEESE or the handle to
%      the existing singleton*.
%
%      DETECTGEESE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DETECTGEESE.M with the given input arguments.
%
%      DETECTGEESE('Property','Value',...) creates a new DETECTGEESE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before DetectGeese_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to DetectGeese_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help DetectGeese

% Last Modified by GUIDE v2.5 06-Sep-2016 15:33:00

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @DetectGeese_OpeningFcn, ...
                   'gui_OutputFcn',  @DetectGeese_OutputFcn, ...
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


% --- Executes just before DetectGeese is made visible.
function DetectGeese_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to DetectGeese (see VARARGIN)

% Choose default command line output for DetectGeese
handles.output = hObject;
warning('off','images:initSize:adjustingMag')
% Update handles structure
guidata(hObject, handles);

Images = getappdata(0,'GeeseImages');
CurrentImage = getappdata(0,'ImageIndex');
imshow(imread(char(strcat(Images.Left(CurrentImage).Name,'.tif'))));
imTitle=char(Images.Left(CurrentImage).Name);
title([imTitle(1:3),' ',imTitle(5:end)])
set(handles.start,'Visible','On')
set(handles.addGoose,'Visible','Off')
set(handles.removeGoose,'Visible','Off')
set(handles.matchGeese,'Visible','Off')


% UIWAIT makes DetectGeese wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = DetectGeese_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in start.
function start_Callback(hObject, eventdata, handles)
% hObject    handle to start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Images = getappdata(0,'GeeseImages');
CurrentImage = getappdata(0,'ImageIndex');
IMLeft=Image(char(strcat(Images.Left(CurrentImage).Name,'.tif')));
IMLeft=IMLeft.Crop;
Finder=GooseFinder(IMLeft);
Finder=Finder.CreateGeese;
set(handles.start,'Visible','Off')
set(handles.addGoose,'Visible','On')
set(handles.removeGoose,'Visible','On')
set(handles.matchGeese,'Visible','On')
setappdata(0,'GeeseObject',Finder)
setappdata(0,'LeftImage',IMLeft)


% --- Executes on button press in removeGoose.
function removeGoose_Callback(hObject, eventdata, handles)
% hObject    handle to removeGoose (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Finder=getappdata(0,'GeeseObject');
IMLeft=getappdata(0,'LeftImage');
Finder=Finder.RemoveGeese(handles,IMLeft);
setappdata(0,'GeeseObject',Finder)
setappdata(0,'LeftImage',IMLeft)

% --- Executes on button press in addGoose.
function addGoose_Callback(hObject, eventdata, handles)
% hObject    handle to addGoose (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Finder=getappdata(0,'GeeseObject');
IMLeft=getappdata(0,'LeftImage');
 Finder=Finder.AddGeese(handles,IMLeft);
setappdata(0,'GeeseObject',Finder)
setappdata(0,'LeftImage',IMLeft)

% --- Executes on button press in pushbutton10 ("Select Lead Goose" Button).
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Finder=getappdata(0,'GeeseObject');
IMLeft=getappdata(0,'LeftImage');
Finder=Finder.LeadGeese(handles,IMLeft);
setappdata(0,'GeeseObject',Finder)
setappdata(0,'LeftImage',IMLeft)

% --- Executes on button press in pushbutton11. ("Select Rear Geese" Button).
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Finder=getappdata(0,'GeeseObject');
IMLeft=getappdata(0,'LeftImage');
Finder=Finder.RearGeese(handles,IMLeft,1);
setappdata(0,'GeeseObject',Finder)
setappdata(0,'LeftImage',IMLeft)


% --- Executes on button press in matchGeese.
function matchGeese_Callback(hObject, eventdata, handles)
% hObject    handle to matchGeese (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Images=getappdata(0,'GeeseImages');
CurrentImage = getappdata(0,'ImageIndex');
IMLeft=getappdata(0,'LeftImage');
Finder=getappdata(0,'GeeseObject');
%Create Right Image Object
IMRight=Image(char(strcat(Images.Right(CurrentImage).Name,'.tif')));
%Create Right Features Object from the Right Image Object
Right=RightFeatures(IMRight);
%Use the Finder Object to Match Geese in the Right and Left Image
Finder=Finder.MatchGeese(Right,IMLeft,IMRight);
pause(2)
if exist('Calib_Results.mat','file')==0
    msgbox('Need calibration data.')
    Detect_Checker_GUI
end
load('Calib_Results.mat')

SetData = SingleData(Calib,Images,CurrentImage);
figure()
% plot3(0,0,0,'o')
hold on
SetData = SetData.SetGeese(Finder.Geese);
SetData = SetData.CommentBox;
if isappdata(0,'FullDataSet')
    FullDataSet=getappdata(0,'FullDataSet');
end
FullDataSet(CurrentImage) = SetData;
setappdata(0,'FullDataSet',FullDataSet)
save('FullImageSet','FullDataSet')
savefig(char(strcat(Images.Right(CurrentImage).Name)));
CurrentImage=CurrentImage+1;
setappdata(0,'ImageIndex',CurrentImage);
Image_Selector_Geese
close('DetectGeese')
