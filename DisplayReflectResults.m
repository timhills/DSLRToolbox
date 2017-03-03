function DisplayReflectResults(Color1,Color2,SURF1,SURF2,...
    Temp1,Temp2,Diff1,Diff2,handles)
%UNTITLED52 Summary of this function goes here
%   Detailed explanation goes here
cla(handles.axes1)
cla(handles.axes2)
cla(handles.axes3)
set(handles.ColorSeg_Axes,'Visible','on')
set(handles.SURF_Axes,'Visible','on')
set(handles.Temp_Axes,'Visible','on')
set(handles.Diff_Axes,'Visible','on')
set(handles.Color_Seg,'Visible','on')
set(handles.SURF,'Visible','on')
set(handles.Template,'Visible','on')
set(handles.Difference,'Visible','on')
set(handles.Optimize_Results,'Visible','on')

axes(handles.ColorSeg_Axes)
imshowpair(Color1,Color2,'montage');

axes(handles.SURF_Axes)
imshowpair(SURF1,SURF2,'montage');

axes(handles.Temp_Axes)
imshowpair(Temp1,Temp2,'montage');

axes(handles.Diff_Axes)
imshowpair(Diff1,Diff2,'montage');

Directions={'Select the methods which returned the best results then hit',...
    'the optimize results button.'};
set(handles.text2,'String',Directions)
waitfor(handles.Optimize_Results,'Value')
set(handles.ColorSeg_Axes,'Visible','off')
set(handles.SURF_Axes,'Visible','off')
set(handles.Temp_Axes,'Visible','off')
set(handles.Diff_Axes,'Visible','off')
set(handles.Color_Seg,'Visible','off')
set(handles.SURF,'Visible','off')
set(handles.Template,'Visible','off')
set(handles.Difference,'Visible','off')
set(handles.Optimize_Results,'Visible','off')
end

