function [IL,IR,PointL,PointR,RectL,RectR] = SelectPoint_GUI(Images,...
    Image_Num,handles,Avg_Location)
%UNTITLED51 Summary of this function goes here
%   Detailed explanation goes here
[I1] = Image_Read(Images,Image_Num,'Left');
[I2] = Image_Read(Images,Image_Num,'Right');
IDisplay1=I1;
IDisplay2=I2;
if ~isempty(Avg_Location)
    for i=1:size(Avg_Location,3)
        IDisplay1=insertText(IDisplay1,Avg_Location(1,:,i),'Processed','FontSize',60);
        IDisplay2=insertText(IDisplay2,Avg_Location(2,:,i),'Processed','FontSize',60);
    end
end
cla
Directions={'Draw a rectangle around the reflector, then double click',...
    'within the box when ready to process.'};
set(handles.text2,'String',Directions)
[~,RectL]=Crop_GUI(IDisplay1,handles,'axes1');
IL=imcrop(I1,[RectL(1) RectL(2) RectL(3) RectL(4)]);
cla
Directions={'Draw a rectangle around the same reflector, then double click',...
    'within the box when ready to process.'};
set(handles.text2,'String',Directions)
[~,RectR]=Crop_GUI(IDisplay2,handles,'axes1',RectL);
IR=imcrop(I2,[RectR(1) RectR(2) RectR(3) RectR(4)]);
clear I1 I2

cla
axes(handles.axes2)
imshow(IL)
axes(handles.axes3)
imshow(IR)

axes(handles.axes2)
Directions={'Select a pixel on the left reflector.'};
set(handles.text2,'String',Directions)
K=impoint;
PointL=getPosition(K);
clear K

axes(handles.axes3)
Directions={'Select the same pixel on the right reflector.'};
set(handles.text2,'String',Directions)
K=impoint;
PointR=getPosition(K);
clear K

end

