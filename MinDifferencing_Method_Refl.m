function [Location,J1,J2] = MinDifferencing_Method_Refl(I1,I2,PositionL,PositionR)
%UNTITLED48 Summary of this function goes here
%   Detailed explanation goes here
Pos1=round(PositionL);  
Pos2=round(PositionR);
I1Double=double(I1);
I2Double=double(I2);
J=I1Double(((Pos1(2)-10):(Pos1(2)+10)),((Pos1(1)-10):(Pos1(1)+10)));
Diff=zeros(21,21,10);
k=1;
for i=1:5
    A=3-i;
    for j=1:5
        B=3-j;        
        K=I2Double(((A+Pos2(2)-10):(A+Pos2(2)+10)),((B+Pos2(1)-10):(B+Pos2(1)+10)));
        Diff(:,:,k)=abs(J-K);
        Total(k)=sum(sum(Diff(:,:,k)));
        PixelLocation(k,:)=[B+Pos2(1),A+Pos2(2)];
        k=k+1;
    end            
end
[~,Index]=min(Total);
Pixel=PixelLocation(Index,:);
clear J1 J2
J1=insertMarker(I1,Pos1,'Color','Cyan','Size',8);
J2=insertMarker(I2,Pixel,'Color','Cyan','Size',8);
Location=[Pos1;Pixel];

end

