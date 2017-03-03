function varargout = Image_Selector_Geese(varargin)
% IMAGE_SELECTOR_GEESE MATLAB code for Image_Selector_Geese.fig
%      IMAGE_SELECTOR_GEESE, by itself, creates a new IMAGE_SELECTOR_GEESE or raises the existing
%      singleton*.
%
%      H = IMAGE_SELECTOR_GEESE returns the handle to a new IMAGE_SELECTOR_GEESE or the handle to
%      the existing singleton*.
%
%      IMAGE_SELECTOR_GEESE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in IMAGE_SELECTOR_GEESE.M with the given input arguments.
%
%      IMAGE_SELECTOR_GEESE('Property','Value',...) creates a new IMAGE_SELECTOR_GEESE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Image_Selector_Geese_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Image_Selector_Geese_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Image_Selector_Geese

% Last Modified by GUIDE v2.5 17-Feb-2015 12:18:25

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Image_Selector_Geese_OpeningFcn, ...
                   'gui_OutputFcn',  @Image_Selector_Geese_OutputFcn, ...
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


% --- Executes just before Image_Selector_Geese is made visible.
function Image_Selector_Geese_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Image_Selector_Geese (see VARARGIN)

% Choose default command line output for Image_Selector_Geese
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
Images = getappdata(0,'GeeseImages');
CurrentImage = getappdata(0,'ImageIndex');
if CurrentImage>length(Images.Num)
    CurrentImage=CurrentImage-1;
    msgbox('Image set appears to be complete.')
end
setappdata(0,'ImageIndex',CurrentImage);
axes(handles.axes1)
imshow(imread(char(strcat(Images.Left(CurrentImage).Name,'.tif'))));
imTitle=char(Images.Left(CurrentImage).Name);
title([imTitle(1:3),' ',imTitle(5:end)])
axes(handles.axes2)
imshow(imread(char(strcat(Images.Right(CurrentImage).Name,'.tif'))));
imTitle=char(Images.Right(CurrentImage).Name);
title([imTitle(1:3),' ',imTitle(5:end)])



% UIWAIT makes Image_Selector_Geese wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Image_Selector_Geese_OutputFcn(hObject, eventdata, handles) 
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
IMLeft=getappdata(0,'LeftImage');
Finder=getappdata(0,'GeeseObject');
if ~isempty(IMLeft)
    rmappdata(0,'LeftImage');
end
if ~isempty(Finder)
    rmappdata(0,'GeeseObject') 
end
DetectGeese
close('Image_Selector_Geese')

% --- Executes on button press in next.
function next_Callback(hObject, eventdata, handles)
% hObject    handle to next (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

Images = getappdata(0,'GeeseImages');
CurrentImage = getappdata(0,'ImageIndex')+1;
if CurrentImage<length(Images.Num)+1
    axes(handles.axes1)
    imshow(imread(char(strcat(Images.Left(CurrentImage).Name,'.tif'))));
    imTitle=char(Images.Left(CurrentImage).Name);
    title([imTitle(1:3),' ',imTitle(5:end)])
    axes(handles.axes2)
    imshow(imread(char(strcat(Images.Right(CurrentImage).Name,'.tif'))));
    imTitle=char(Images.Right(CurrentImage).Name);
    title([imTitle(1:3),' ',imTitle(5:end)])
    setappdata(0,'ImageIndex',CurrentImage);
else
    msgbox('Image is out of range.')
end


% --- Executes on button press in back.
function back_Callback(hObject, eventdata, handles)
% hObject    handle to back (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

Images = getappdata(0,'GeeseImages');
CurrentImage = getappdata(0,'ImageIndex')-1;
if CurrentImage>0
    axes(handles.axes1)
    imshow(imread(char(strcat(Images.Left(CurrentImage).Name,'.tif'))));
    imTitle=char(Images.Left(CurrentImage).Name);
    title([imTitle(1:3),' ',imTitle(5:end)])
    axes(handles.axes2)
    imshow(imread(char(strcat(Images.Right(CurrentImage).Name,'.tif'))));
    imTitle=char(Images.Right(CurrentImage).Name);
    title([imTitle(1:3),' ',imTitle(5:end)])
    setappdata(0,'ImageIndex',CurrentImage);
else
    msgbox('Image is out of range.')
end
