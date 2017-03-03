function [SelectedPoint] = ClosestPoint(Position,Points)
%UNTITLED13 Summary of this function goes here
%   Detailed explanation goes here
for i=1:length(Points(:,1))
    d1(i) = (Points(i,1)-Position(1)).^2 + (Points(i,2)-Position(2)).^2; %#ok<AGROW>
end
d1=d1';
[~,index]=min(d1); %#ok<UDIM>
SelectedPoint=Points(index,:);


end

