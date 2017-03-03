function varargout = CircleFind(varargin)
% CIRCLEFIND MATLAB code for CircleFind.fig
%      CIRCLEFIND, by itself, creates a new CIRCLEFIND or raises the existing
%      singleton*.
%
%      H = CIRCLEFIND returns the handle to a new CIRCLEFIND or the handle to
%      the existing singleton*.
%
%      CIRCLEFIND('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CIRCLEFIND.M with the given input arguments.
%
%      CIRCLEFIND('Property','Value',...) creates a new CIRCLEFIND or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before CircleFind_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to CircleFind_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help CircleFind

% Last Modified by GUIDE v2.5 21-Jan-2015 13:02:38

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @CircleFind_OpeningFcn, ...
                   'gui_OutputFcn',  @CircleFind_OutputFcn, ...
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


% --- Executes just before CircleFind is made visible.
function CircleFind_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to CircleFind (see VARARGIN)

% Choose default command line output for CircleFind
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

%Set up GUI
set(handles.axes1,'Visible','On')
set(handles.removeCirclesL,'Visible','Off')
set(handles.removeCirclesR,'Visible','Off')
set(handles.submitCircles,'Visible','Off')
set(handles.cancel,'Visible','Off')
set(handles.numberOfCircles,'Visible','Off')
set(handles.text2,'Visible','Off')
set(handles.axes2,'Visible','Off')
set(handles.axes3,'Visible','Off')

%Allow user to crop section to decrease detection time
axes(handles.axes1)
title('Left Image')
IL=getappdata(0,'ImageLeftOriginal');
[IL,RectL]=imcrop(IL);
title('Right Image')
IR=getappdata(0,'ImageRightOriginal');
[IR,RectR]=imcrop(IR);

%Detect reflectors using circles of radius 10 to 30 (Lower radii increase
%detection time and decrease accuracy)
h=msgbox('Detecting reflectors in image... (This may take a few seconds)');
[centersLeft, radiiLeft, ~] = imfindcircles(IL,[10 30]);
[centersRight, radiiRight, ~] = imfindcircles(IR,[10 30]);
%Add crop location to detected centers
centersLeft(:,1)=centersLeft(:,1)+RectL(1);
centersLeft(:,2)=centersLeft(:,2)+RectL(2);
centersRight(:,1)=centersRight(:,1)+RectR(1);
centersRight(:,2)=centersRight(:,2)+RectR(2);
%Match centers by location
[radiiLeft,radiiRight,centersLeft,...
    centersRight,centersLeftDisplay,centersRightDisplay,Smallest] = ...
    MatchCircle(radiiLeft,radiiRight,centersLeft,centersRight,RectL,RectR);
close(h)

%Set data for use in other GUI functions
setappdata(0,'CentersLeft',centersLeft)
setappdata(0,'CentersLeftDisplay',centersLeftDisplay)
setappdata(0,'RadiiLeft',radiiLeft)
setappdata(0,'CentersRight',centersRight)
setappdata(0,'CentersRightDisplay',centersRightDisplay)
setappdata(0,'RadiiRight',radiiRight)
setappdata(0,'ImageLeft',IL)
setappdata(0,'ImageRight',IR)
setappdata(0,'RectLeft',RectL)
setappdata(0,'RectRight',RectR)

%Turn off primary axes and activate sub axes
cla(handles.axes1)
set(handles.axes1,'Visible','Off')
set(handles.axes2,'Visible','On')
set(handles.axes3,'Visible','On')
axes(handles.axes2)
ILDisp=IL;
IRDisp=IR;
for i=1:Smallest
    ILDisp=insertText(ILDisp,centersLeftDisplay(i,:),i,'FontSize', 72);
    IRDisp=insertText(IRDisp,centersRightDisplay(i,:),i,'FontSize', 72);
end
imshow(ILDisp)
title('Left')
viscircles(centersLeftDisplay, radiiLeft,'EdgeColor','b');
axes(handles.axes3)
imshow(IRDisp)
title('Right')
viscircles(centersRightDisplay, radiiRight,'EdgeColor','b');

set(handles.removeCirclesL,'Visible','On')
set(handles.removeCirclesR,'Visible','On')
set(handles.submitCircles,'Visible','On')
set(handles.cancel,'Visible','On')
set(handles.numberOfCircles,'Visible','On')
set(handles.text2,'Visible','On')


% UIWAIT makes CircleFind wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = CircleFind_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function numberOfCircles_Callback(hObject, eventdata, handles)
% hObject    handle to numberOfCircles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of numberOfCircles as text
%        str2double(get(hObject,'String')) returns contents of numberOfCircles as a double


% --- Executes during object creation, after setting all properties.
function numberOfCircles_CreateFcn(hObject, eventdata, handles)
% hObject    handle to numberOfCircles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in removeCirclesL.
function removeCirclesL_Callback(hObject, eventdata, handles)
% hObject    handle to removeCirclesL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes2)
removeCircles=str2double(get(handles.numberOfCircles,'String'));
if round(removeCircles) ~= removeCircles
    waitfor(msgbox('Number of circles to remove must be an integer.'));
    return
end
if removeCircles~=0
    centersLeft=getappdata(0,'CentersLeft');
    centersLeftDisplay=getappdata(0,'CentersLeftDisplay');
    radiiLeft=getappdata(0,'RadiiLeft');
    IL=getappdata(0,'ImageLeft');
    centersRight=getappdata(0,'CentersRight');
    centersRightDisplay=getappdata(0,'CentersRightDisplay');
    radiiRight=getappdata(0,'RadiiRight');
    IR=getappdata(0,'ImageRight');
    RectL=getappdata(0,'RectLeft');
    RectR=getappdata(0,'RectRight');
    for i=1:removeCircles
        K=impoint;
        J=getPosition(K);
        [SelectedPoint1] = ClosestPoint(J,centersLeftDisplay);
        Index=find(centersLeftDisplay(:,1)<SelectedPoint1(1,1)+1 ...
            & centersLeftDisplay(:,1)>SelectedPoint1(1,1)-1);
        centersLeftDisplay(Index,:)=[];
        centersLeft(Index,:)=[];
        radiiLeft(Index)=[];
    end
    [radiiLeft,radiiRight,centersLeft,...
    centersRight,centersLeftDisplay,centersRightDisplay,Smallest] = ...
    MatchCircle(radiiLeft,radiiRight,centersLeft,centersRight,RectL,RectR);
    ILDisp=IL;
    IRDisp=IR;
    for i=1:Smallest
        ILDisp=insertText(ILDisp,centersLeftDisplay(i,:),i,'FontSize', 72);
        IRDisp=insertText(IRDisp,centersRightDisplay(i,:),i,'FontSize', 72);
    end
    axes(handles.axes2)
    imshow(ILDisp)
    title('Left')
    viscircles(centersLeftDisplay, radiiLeft,'EdgeColor','b');
    axes(handles.axes3)
    imshow(IRDisp)
    title('Right')
    viscircles(centersRightDisplay, radiiRight,'EdgeColor','b');
    setappdata(0,'CentersRight',centersRight)
    setappdata(0,'CentersRightDisplay',centersRightDisplay)
    setappdata(0,'RadiiRight',radiiRight)
    setappdata(0,'ImageRight',IR)
    setappdata(0,'CentersLeft',centersLeft)
    setappdata(0,'CentersLeftDisplay',centersLeftDisplay)
    setappdata(0,'RadiiLeft',radiiLeft)
    setappdata(0,'ImageLeft',IL)
end


% --- Executes on button press in submitCircles.
function submitCircles_Callback(hObject, eventdata, handles)
% hObject    handle to submitCircles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close('CircleFind')

% --- Executes on button press in cancel.
function cancel_Callback(hObject, eventdata, handles)
% hObject    handle to cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cancel=menu('Are you sure that you want to cancel the results?','Yes','No');
switch cancel
    case 1
        centersLeft=[];
        centersRight=[];
        setappdata(0,'CentersLeft',centersLeft)
        setappdata(0,'CentersRight',centersRight)
        close('CircleFind')
    case 2
        return
end


% --- Executes on button press in removeCirclesR.
function removeCirclesR_Callback(hObject, eventdata, handles)
% hObject    handle to removeCirclesR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes3)
removeCircles=str2double(get(handles.numberOfCircles,'String'));
if round(removeCircles) ~= removeCircles
    waitfor(msgbox('Number of circles to remove must be an integer.'));
    return
end
if removeCircles~=0
    centersLeft=getappdata(0,'CentersLeft');
    centersLeftDisplay=getappdata(0,'CentersLeftDisplay');
    radiiLeft=getappdata(0,'RadiiLeft');
    IL=getappdata(0,'ImageLeft');
    centersRight=getappdata(0,'CentersRight');
    centersRightDisplay=getappdata(0,'CentersRightDisplay');
    radiiRight=getappdata(0,'RadiiRight');
    IR=getappdata(0,'ImageRight');
    RectL=getappdata(0,'RectLeft');
    RectR=getappdata(0,'RectRight');
    for i=1:removeCircles
        K=impoint;
        J=getPosition(K);
        [SelectedPoint1] = ClosestPoint(J,centersRightDisplay);
        Index=find(centersRightDisplay(:,1)<SelectedPoint1(1,1)+1 ...
            & centersRightDisplay(:,1)>SelectedPoint1(1,1)-1);
        centersRightDisplay(Index,:)=[];
        centersRight(Index,:)=[];
        radiiRight(Index)=[];
    end
    [radiiLeft,radiiRight,centersLeft,...
    centersRight,centersLeftDisplay,centersRightDisplay,Smallest] = ...
    MatchCircle(radiiLeft,radiiRight,centersLeft,centersRight,RectL,RectR);
    ILDisp=IL;
    IRDisp=IR;
    for i=1:Smallest
        ILDisp=insertText(ILDisp,centersLeftDisplay(i,:),i,'FontSize', 72);
        IRDisp=insertText(IRDisp,centersRightDisplay(i,:),i,'FontSize', 72);
    end
    axes(handles.axes2)
    imshow(ILDisp)
    title('Left')
    viscircles(centersLeftDisplay, radiiLeft,'EdgeColor','b');
    axes(handles.axes3)
    imshow(IRDisp)
    title('Right')
    viscircles(centersRightDisplay, radiiRight,'EdgeColor','b');
    setappdata(0,'CentersRight',centersRight)
    setappdata(0,'CentersRightDisplay',centersRightDisplay)
    setappdata(0,'RadiiRight',radiiRight)
    setappdata(0,'ImageRight',IR)
    setappdata(0,'CentersLeft',centersLeft)
    setappdata(0,'CentersLeftDisplay',centersLeftDisplay)
    setappdata(0,'RadiiLeft',radiiLeft)
    setappdata(0,'ImageLeft',IL)
end
