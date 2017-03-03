function [y] = YCalc(Range,YPixCoordinates,FocalLength,System)
%Determines the spacing of selected points in the Y-direction.  The input
%and output units are feet.
%input:
%   Range (The range can be a vector or an array)
%   Focal Length (The focal length must be for the same camera as the pixel
%   locations)
%   Vertical Pixel Location
%output:
%   y=Spacing in Y-Direction

switch System
    case 'NIKON D7000'
        ImageHeight=3264;            %[Pixels]
        SensorHeight=15.6;           %[mm] 
    case 'NIKON D7100'
        ImageHeight=4000;            %[Pixels]
        SensorHeight=15.6;           %[mm]   
end
YPixCoordinates=ImageHeight/2-YPixCoordinates;
Range=(Range.*304.8);
y=(YPixCoordinates*SensorHeight.*Range)./(FocalLength.*ImageHeight);
y=(y./1000).*3.28;

end