function [Images,Processed]=Start_Detect_refl(handles)
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here

if exist('Stereo_Data.mat','file')==2
    load('Stereo_Data.mat')
    Processed=menu({'Some of the images have already been processed.'...
        'Do you want to use the existing data?'},'Yes','No');
    switch Processed
        case 1
            Exist_Num=Images.Num;
        case 2
            Exist_Num=[];
    end
    clear Images
else
    Exist_Num=[];
    Processed = 2;
end

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

if isempty(Exist_Num)
    Images.Num=Images.Num+Name_Start-1;
else
    Images.Num=Images.Num+Name_Start-1;
    for i=1:length(Exist_Num)
        Images.Num=Images.Num(Images.Num~=Exist_Num(i));
    end
end

[Images] = Image_Names_GUI(handles,Images);


end

