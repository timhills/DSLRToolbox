function [Range] = Refl_Range(handles,Avg_Location)
%UNTITLED19 Summary of this function goes here
%   Detailed explanation goes here
Directions={'Enter the distance from the camera system to the reflector.'};
if (size(Avg_Location,3)+1)/4==round((size(Avg_Location,3)+1)/4)
    msgbox('Did you enter the correct distance?')
end
set(handles.text2,'String',Directions)

set(handles.text3,'Visible','On')
set(handles.text4,'Visible','On')
set(handles.Refl_Range,'Visible','On')
set(handles.Enter_Refl_Range,'Visible','On')

waitfor(handles.Enter_Refl_Range,'Value')
Range=str2double(get(handles.Refl_Range,'String'));
while isnan(Range)
    msgbox('Input must be a number')
    waitfor(handles.Enter_Refl_Range,'Value')
    Range=str2double(get(handles.Refl_Range,'String'));
end
set(handles.text3,'Visible','off')
set(handles.text4,'Visible','off')
set(handles.Refl_Range,'Visible','off')
set(handles.Enter_Refl_Range,'Visible','off')


end

