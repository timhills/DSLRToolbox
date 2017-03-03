function [x] = XCalc(Range,HorizontalPixelLocation,FocalLength,System)
%Determines the spacing of selected points in the X-direction.  The input
%and output units are feet.
%input:
%   Range (The range can be a vector or an array)
%   Focal Length (The focal length must be for the same camera as the pixel
%   locations)
%   Horizontal Pixel Location
%output:
%   x=Spacing in X-Direction

switch System
    case 'NIKON D7000' 
        ImageWidth=4928;            %[Pixels]
        SensorWidth=23.6;           %[mm]
    case 'NIKON D7100'
        ImageWidth=6000;            %[Pixels]
        SensorWidth=23.5;           %[mm]   
end

Range=(Range.*304.8);
x=(HorizontalPixelLocation.*SensorWidth.*Range)./(FocalLength.*ImageWidth);
x=(x./1000).*3.28;

end

