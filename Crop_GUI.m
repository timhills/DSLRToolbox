function [Icrop,Position] = Crop_GUI(I,handles,haxes,Position_Set)
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here
if nargin<3
    haxes='axes1';
end
axes(handles.(haxes));
imshow(I)
h2=imrect;
text(10,1,'Double click within the rectangle when ready to process.',...
'BackgroundColor',[1 1 1])
%The position of the top right corner, width and height of the rectangle.

wait(h2); %Holds the ROI until the interior is double clicked with the mouse.
Position=getPosition(h2); 
if Position(1)<0
    Position(1)=0;
elseif Position(1)>size(I,2)
    Position(1)=size(I,2);
elseif Position(2)<0
    Position(2)=0;
elseif Position(2)>size(I,1)
    Position(2)=size(I,1);
end
if nargin<4
    Icrop=imcrop(I,[Position(1) Position(2) Position(3) Position(4)]);
else
    Icrop=imcrop(I,[Position(1) Position(2) Position_Set(3) Position_Set(4)]);
    Position=[Position(1) Position(2) Position_Set(3) Position_Set(4)];
end

end