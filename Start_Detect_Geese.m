function Images=Start_Detect_Geese(handles)
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here

Images.Num=str2double(get(handles.Num_of_Images,'String'));
if round(Images.Num) ~= Images.Num
    waitfor(msgbox('Number of images must be an integer.')); 
    return
end
Images.Num=(1:Images.Num);
Name_Start=str2double(get(handles.Start_Image_Num,'String'));
if round(Name_Start) ~= Name_Start
    waitfor(msgbox('Starting image number must be an integer.'));
    return
end
Images.Num=Images.Num+Name_Start-1;

Images = Image_Names_GUI(handles,Images);
end