function [I] = Image_Read(Images,Image_Number,Left_or_Right)
%UNTITLED12 Summary of this function goes here
%   Detailed explanation goes here
i=Image_Number;
if strcmp(Left_or_Right,'Left')==1
    I=imread(char(strcat(Images.Left(i).Name,'.tif')));
    
else
    I=imread(char(strcat(Images.Right(i).Name,'.tif')));     
end

end

