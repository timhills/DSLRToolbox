function [Images] = Image_Names_GUI(handles,Images)
%UNTITLED10 Summary of this function goes here
%   Detailed explanation goes here
 
if get(handles.radiobuttonD7000,'Value')
    Name=get(handles.radiobuttonD7000,'UserData');
    NameL=Name(1);
    NameR=Name(2);
else
    Name=get(handles.radiobuttonD7100,'UserData');
    NameL=Name(1);
    NameR=Name(2);
end

k=cell(length(Images.Num),1);
for i=1:length(Images.Num)
    k{i}=sprintf('_%04.0f',Images.Num(i));
end
for i=1:length(Images.Num)
    Images.Left(i).Name=strcat(NameL,k(i));
    Images.Right(i).Name=strcat(NameR,k(i));
end


end

