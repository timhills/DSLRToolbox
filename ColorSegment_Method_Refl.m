function [Location,J1,J2] = ColorSegment_Method_Refl(IL,IR,color_markers,handles)
%UNTITLED47 Summary of this function goes here
%   Detailed explanation goes here
[LocationL]=Reflector_Centroid(IL,color_markers,handles);
[LocationR]=Reflector_Centroid(IR,color_markers,handles);

if ~isempty(LocationL) && ~isempty(LocationR)
    Location(1,:)=LocationL;
    Location(2,:)=LocationR;
    J1=insertMarker(IL,LocationL,'Color','Cyan','Size',8);
    J2=insertMarker(IR,LocationR,'Color','Cyan','Size',8);
else
    Location=[];
    J1=IL;
    J2=IR;
end 


end

