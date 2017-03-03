function [Location,J1,J2] = Template_Method_Refl(I1,I2,PositionL,PositionR)
A=20;
B=10;
Pos1=round(PositionL);        
J=I1(((Pos1(2)-A):(Pos1(2)+A)),((Pos1(1)-A):(Pos1(1)+A)));
Pos2=round(PositionR);
K=I2(((Pos2(2)-B):(Pos2(2)+B)),((Pos2(1)-B):(Pos2(1)+B)));
%Set K as Template

c = normxcorr2(K,J);
% figure, surf(c), shading flat

[ypeak, xpeak] = find(c==max(c(:)));

yoffSet = ypeak-size(K,1);
xoffSet = xpeak-size(K,2);

% figure;
% hAx  = axes;
% imshow(J,'Parent', hAx);
% imrect(hAx, [xoffSet, yoffSet, size(K,2), size(K,1)]);

Location(1,1)=Pos1(1)-A+xoffSet+size(K,2)/2-.5;
Location(1,2)=Pos1(2)-A+yoffSet+size(K,1)/2-.5;
Location(2,1)=Pos2(1);
Location(2,2)=Pos2(2);

J1=insertMarker(I1,Location(1,:),'Color','Cyan','Size',8);
J2=insertMarker(I2,Location(2,:),'Color','Cyan','Size',8);

end

