function [Centroid]=Reflector_Centroid(Icrop,color_markers,handles)

% [I] = Image_Read(Images,Image_Num,Side);
% [Icrop, Position]=Crop(I);
[Segmented_Image(:,:,:,:)] = Segment_Image(Icrop,color_markers,2);
clear I Icrop

% Display(Segmented_Image(:,:,:,1), 'Green Objects');
% pause(1)


HSV = rgb2hsv(Segmented_Image(:,:,:,1));
% imshow(HSV)
% pause(2);
BWHSV = im2bw(HSV,.3);
A=size(BWHSV);
%Remove all objects containing fewer than 100 pixels
bw = bwareaopen(BWHSV,100);
bw=imcomplement(bw);
bw = imfill(bw,[1,1;1,A(2);A(1),1;A(1),A(2)]);
bw=imcomplement(bw);
bw = bwareaopen(bw,100);
[Num] = bwboundaries(bw,'noholes');
if length(Num)>1
    cla
    axes(handles.axes1)
    bw=bwselect(bw,8);
end
[B,L] = bwboundaries(bw,'noholes');

%Plot boundaries on reflector
% fig=figure();
% imshow(label2rgb(L, @jet, [.5 .5 .5]))
% set (fig, 'Units', 'normalized', 'Position', [0.0045,0.045,.99,.873]);
% hold on
% for a = 1:length(B)
%   boundary = B{a};
%   plot(boundary(:,2), boundary(:,1), 'w', 'LineWidth', 2)
% end
% pause(.5)
%Name=char(Images.(Side).Names(Image_Num));

if isempty(B)
    Centroid=[];
else
    Stats = regionprops(L,'Centroid');
    Centroid(1)=Stats.Centroid(1);
    Centroid(2)=Stats.Centroid(2);
end
end