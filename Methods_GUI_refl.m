function varargout = Methods_GUI_refl(varargin)
% METHODS_GUI_REFL MATLAB code for Methods_GUI_refl.fig
%      METHODS_GUI_REFL, by itself, creates a new METHODS_GUI_REFL or raises the existing
%      singleton*.
%
%      H = METHODS_GUI_REFL returns the handle to a new METHODS_GUI_REFL or the handle to
%      the existing singleton*.
%
%      METHODS_GUI_REFL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in METHODS_GUI_REFL.M with the given input arguments.
%
%      METHODS_GUI_REFL('Property','Value',...) creates a new METHODS_GUI_REFL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Methods_GUI_refl_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Methods_GUI_refl_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Methods_GUI_refl

% Last Modified by GUIDE v2.5 03-Oct-2014 14:16:20

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Methods_GUI_refl_OpeningFcn, ...
                   'gui_OutputFcn',  @Methods_GUI_refl_OutputFcn, ...
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


% --- Executes just before Methods_GUI_refl is made visible.
function Methods_GUI_refl_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Methods_GUI_refl (see VARARGIN)

% Choose default command line output for Methods_GUI_refl
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
set(handles.Optimize_Results,'Visible','off')
set(handles.ColorSeg_Axes,'Visible','off')
set(handles.SURF_Axes,'Visible','off')
set(handles.Temp_Axes,'Visible','off')
set(handles.Diff_Axes,'Visible','off')
set(handles.Color_Seg,'Visible','off')
set(handles.SURF,'Visible','off')
set(handles.Template,'Visible','off')
set(handles.Difference,'Visible','off')
set(handles.axes2,'Visible','off')
set(handles.axes3,'Visible','off')
set(handles.text3,'Visible','off')
set(handles.text4,'Visible','off')
set(handles.Refl_Range,'Visible','off')
set(handles.Enter_Refl_Range,'Visible','off')
axes(handles.axes1)
load('Stereo_Data.mat')
[I] = Image_Read(Images,1,'Left');
imshow(I)
imageTitle=char(Images.Left(1).Name);
set(handles.imageTitleTag,'String',['Image Pair: ',imageTitle(5:8)])

% UIWAIT makes Methods_GUI_refl wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Methods_GUI_refl_OutputFcn(hObject, eventdata, handles)  %#ok<*INUSL>
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles) %#ok<*DEFNU>
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


set(handles.pushbutton1,'Visible','off')
set(handles.Reflector_Num,'Visible','off')
set(handles.text1,'Visible','off')

global Location2
Num=str2double(get(handles.Reflector_Num,'String'));
if round(Num) ~= Num
    msgbox('Number of reflectors must be an integer.')
    return
end

Directions={'Draw a rectangle around a reflecter for the color',...
    'segmentation process to begin. When ready double click',...
    'within the rectangle.'};
set(handles.text2,'String',Directions)

load('Stereo_Data.mat')
[I] = Image_Read(Images,1,'Left'); %#ok<NODEF>
[Icrop] = Crop_GUI(I,handles);

nColors=2;

Directions={'Draw a polygon around the green pixels, then the red pixels.',...
    'Double click within the polygon when ready.'};
set(handles.text2,'String',Directions)

for count = 1:nColors    
    axes(handles.axes1) %#ok<LAXES>
    poly(:,:,count)=roipoly(Icrop); 
end

%RGB image into an L*a*b* image
cform=makecform('srgb2lab');
lab=applycform(Icrop,cform);

a = lab(:,:,2);
b = lab(:,:,3);
color_markers=zeros([nColors, 2]);

for count = 1:nColors
  color_markers(count,1) = mean2(a(poly(:,:,count)));  
  color_markers(count,2) = mean2(b(poly(:,:,count)));
end
Avg_Location=[];
fileID = fopen('ReflLocations.txt','a');
fprintf(fileID,'%s\n',datestr(clock));

for i=1:length(Images.Num)

    imageTitle=char(Images.Left(i).Name);
    set(handles.imageTitleTag,'String',['Image Pair: ',imageTitle(5:8)])
    setappdata(0,'ImageLeftOriginal',Image_Read(Images,i,'Left'));
    setappdata(0,'ImageRightOriginal',Image_Read(Images,i,'Right'));
    waitfor(CircleFind)
    centersLeft=getappdata(0,'CentersLeft');
    centersRight=getappdata(0,'CentersRight');
    NumReflectors=length(centersLeft)+1;
    %Create text file of locations in case of error or the program is closed
    fprintf(fileID,'%s\n',['Image: ',imageTitle]);
    fprintf(fileID,'%8s %8s %8s %8s %8s\n','Range','X-Left','Y-Left',...
        'X-Right','Y-Right');
    if ~isempty(centersLeft)
        for k=1:size(centersLeft,1)
            cla(handles.SURF_Axes)
            cla(handles.Temp_Axes)
            cla(handles.Diff_Axes)
            cla(handles.Color_Seg)
            axes(handles.axes1)
            RectL=[centersLeft(k,:)-[100,100],200,200];
            RectR=[centersRight(k,:)-[100,100],200,200];
            PosL=[100,100];
            PosR=[100,100];
            IL=imcrop(Image_Read(Images,i,'Left'),RectL);
            IR=imcrop(Image_Read(Images,i,'Right'),RectR);
%             [IL,IR,PosL,PosR,RectL,RectR] = SelectPoint_GUI(Images,i,handles,Avg_Location);
            IDisplay=insertText(Image_Read(Images,i,'Left'),...
                centersLeft(k,:),'Selected','FontSize',60);
            imshow(IDisplay)            
            Images.Ranges{i}.Refl(k) = Refl_Range(handles,Avg_Location);
            IGrayL=rgb2gray(IL);
            IGrayR=rgb2gray(IR);
            [Location1,Color1,Color2] = ColorSegment_Method_Refl(IL,IR,color_markers,handles);
            SURF_Method_Refl(IGrayL,IGrayR);
            [Location3,Temp1,Temp2] = Template_Method_Refl(IL,IR,PosL,PosR);
            [Location4,Diff1,Diff2] = MinDifferencing_Method_Refl(IGrayL,IGrayR,PosL,PosR);
            if ~isempty(Location2)
                SURF1=insertMarker(IGrayL,Location2(1,:),'Color','Cyan','Size',8);
                SURF2=insertMarker(IGrayR,Location2(2,:),'Color','Cyan','Size',8); 
%                 SURF1=insertMarker(SURF1,Location2(1,:),'square','Color','magenta',...
%                     'Size',8);
%                 SURF2=insertMarker(SURF2,Location2(2,:),'square''Color','magenta',...
%                     'Size',8); 
            else
                SURF1=IGrayL;
                SURF2=IGrayR;
            end
            DisplayReflectResults(Color1,Color2,SURF1,SURF2,...
                Temp1,Temp2,Diff1,Diff2,handles)
            Avg_Location(:,:,k) = Result_Optimizer_Refl(Location1,Location2,...
                Location3,Location4,handles);     %#ok<*AGROW>
            Avg_Location(1,:,k)=Avg_Location(1,:,k)+RectL(1:2);
            Avg_Location(2,:,k)=Avg_Location(2,:,k)+RectR(1:2);
            Images.Locations{i}.Refl(:,:,k)=Avg_Location(:,:,k);
            fprintf(fileID,'%04.4f %04.4f %04.4f %04.4f %04.4f\n',...
                Images.Ranges{1}.Refl(k),...
                Images.Locations{i}.Refl(1,1,k),Images.Locations{i}.Refl(1,2,k),...
                Images.Locations{i}.Refl(2,1,k),Images.Locations{i}.Refl(2,2,k));           
            arrayfun(@cla,findall(0,'type','axes'))        
        end    
    end

    for k=NumReflectors:Num
        try
            cla(handles.SURF_Axes)
            cla(handles.Temp_Axes)
            cla(handles.Diff_Axes)
            cla(handles.Color_Seg)
            [IL,IR,PosL,PosR,RectL,RectR] = SelectPoint_GUI(Images,i,handles,Avg_Location);
            Images.Ranges{i}.Refl(k) = Refl_Range(handles,Avg_Location);
            IGrayL=rgb2gray(IL);
            IGrayR=rgb2gray(IR);
            [Location1,Color1,Color2] = ColorSegment_Method_Refl(IL,IR,color_markers,handles);
            SURF_Method_Refl(IGrayL,IGrayR);
            [Location3,Temp1,Temp2] = Template_Method_Refl(IL,IR,PosL,PosR);
            [Location4,Diff1,Diff2] = MinDifferencing_Method_Refl(IGrayL,IGrayR,PosL,PosR);
            if ~isempty(Location2)
                SURF1=insertMarker(IGrayL,Location2(1,:),'Color','Cyan','Size',8);
                SURF2=insertMarker(IGrayR,Location2(2,:),'Color','Cyan','Size',8); 
            else
                SURF1=IGrayL;
                SURF2=IGrayR;
            end
            DisplayReflectResults(Color1,Color2,SURF1,SURF2,...
                Temp1,Temp2,Diff1,Diff2,handles)
            Avg_Location(:,:,k) = Result_Optimizer_Refl(Location1,Location2,...
                Location3,Location4,handles);     %#ok<*AGROW>
            Avg_Location(1,:,k)=Avg_Location(1,:,k)+RectL(1:2);
            Avg_Location(2,:,k)=Avg_Location(2,:,k)+RectR(1:2);
            Images.Locations{i}.Refl(:,:,k)=Avg_Location(:,:,k);
            arrayfun(@cla,findall(0,'type','axes'))
            fprintf(fileID,'%04.4f %04.4f %04.4f %04.4f %04.4f\n',...
                Images.Ranges{1}.Refl(k),...
                Images.Locations{i}.Refl(1,1,k),Images.Locations{i}.Refl(1,2,k),...
                Images.Locations{i}.Refl(2,1,k),Images.Locations{i}.Refl(2,2,k));
        catch 
            msgbox({'Selected point was too close to the edge of the cropped',...
                'image. Redraw the rectangle around both reflectors.'})
            cla(handles.SURF_Axes)
            cla(handles.Temp_Axes)
            cla(handles.Diff_Axes)
            cla(handles.Color_Seg)
            [IL,IR,PosL,PosR,RectL,RectR] = SelectPoint_GUI(Images,i,handles,Avg_Location);
            Images.Ranges{i}.Refl(k) = Refl_Range(handles);
            IGrayL=rgb2gray(IL);
            IGrayR=rgb2gray(IR);
            [Location1,Color1,Color2] = ColorSegment_Method_Refl(IL,IR,color_markers,handles);
            SURF_Method_Refl(IGrayL,IGrayR);
            [Location3,Temp1,Temp2] = Template_Method_Refl(IL,IR,PosL,PosR);
            [Location4,Diff1,Diff2] = MinDifferencing_Method_Refl(IGrayL,IGrayR,PosL,PosR);
            if ~isempty(Location2)
                SURF1=insertMarker(IGrayL,Location2(1,:),'Color','Cyan','Size',8);
                SURF2=insertMarker(IGrayR,Location2(2,:),'Color','Cyan','Size',8); 
            else
                SURF1=IGrayL;
                SURF2=IGrayR;
            end
            DisplayReflectResults(Color1,Color2,SURF1,SURF2,...
                Temp1,Temp2,Diff1,Diff2,handles)
            Avg_Location(:,:,k) = Result_Optimizer_Refl(Location1,Location2,...
                Location3,Location4,handles);     %#ok<*AGROW>
            Avg_Location(1,:,k)=Avg_Location(1,:,k)+RectL(1:2);
            Avg_Location(2,:,k)=Avg_Location(2,:,k)+RectR(1:2);
            Images.Locations{i}.Refl(:,:,k)=Avg_Location(:,:,k);
            arrayfun(@cla,findall(0,'type','axes'))
            fprintf(fileID,'%04.4f %04.4f %04.4f %04.4f %04.4f\n',...
                Images.Ranges{1}.Refl(k),...
                Images.Locations{i}.Refl(1,1,k),Images.Locations{i}.Refl(1,2,k),...
                Images.Locations{i}.Refl(2,1,k),Images.Locations{i}.Refl(2,2,k));
        end
    end
    clear Avg_Location
    Avg_Location=[];
end
comment = inputdlg('Enter Comment','Comment',10);
fprintf(fileID,'%s\n',['Comments: ',comment{1}]);
fclose(fileID);
save('Stereo_Data.mat','Images')
close(Methods_GUI_refl)



function Reflector_Num_Callback(hObject, eventdata, handles) %#ok<*INUSD>
% hObject    handle to Reflector_Num (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Reflector_Num as text
%        str2double(get(hObject,'String')) returns contents of Reflector_Num as a double


% --- Executes during object creation, after setting all properties.
function Reflector_Num_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Reflector_Num (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Color_Seg.
function Color_Seg_Callback(hObject, eventdata, handles)
% hObject    handle to Color_Seg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Color_Seg


% --- Executes on button press in SURF.
function SURF_Callback(hObject, eventdata, handles)
% hObject    handle to SURF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of SURF


% --- Executes on button press in Template.
function Template_Callback(hObject, eventdata, handles)
% hObject    handle to Template (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Template


% --- Executes on button press in Difference.
function Difference_Callback(hObject, eventdata, handles)
% hObject    handle to Difference (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Difference


% --- Executes on button press in Optimize_Results.
function Optimize_Results_Callback(hObject, eventdata, handles)
% hObject    handle to Optimize_Results (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Optimize_Results


% --- Executes on button press in Enter_Refl_Range.
function Enter_Refl_Range_Callback(hObject, eventdata, handles)
% hObject    handle to Enter_Refl_Range (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Enter_Refl_Range



function Refl_Range_Callback(hObject, eventdata, handles)
% hObject    handle to Refl_Range (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Refl_Range as text
%        str2double(get(hObject,'String')) returns contents of Refl_Range as a double


% --- Executes during object creation, after setting all properties.
function Refl_Range_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Refl_Range (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
