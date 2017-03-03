function [stats] = LinkQuadrangle(stats)
%UNTITLED28 Summary of this function goes here
%   Detailed explanation goes here

for i=1:size(stats,1)
    X(i)=stats(i).Centroid(1); %#ok<*AGROW>
    Y(i)=stats(i).Centroid(2);
end

%Top left corner will be the minimum sum of X and Y
[~,Index1]=min(sum([X;Y]));
Point1=[X(Index1),Y(Index1)];
[~,Index2]=max(sum([X;Y]));
Guess2=[X(Index1),Y(Index2)];
Guess3=[X(Index2),Y(Index1)];
clear Index1 Index2
for i=1:length(X)
    Diff2(i)=sqrt((Guess2(1)-X(i))^2+(Guess2(2)-Y(i))^2);
    Diff3(i)=sqrt((Guess3(1)-X(i))^2+(Guess3(2)-Y(i))^2);
end
[~,Index]=min(Diff2);
Point2=[X(Index),Y(Index)];
[~,Index]=min(Diff3);
Point3=[X(Index),Y(Index)];
clear Index Diff2 Diff3 Guess1 Guess2

% Normalize X and Y
Norm_X=(X-min(X))/(max(X)-min(X));
Norm_Y=(Y-min(Y))/(max(Y)-min(Y));

% Rotate Norm_X and Norm_Y
Angle=tan((Point1(1)-Point2(1))/(Point1(2)-Point2(2)));
% Angle2=tan((Point1(2)-Point3(2))/(Point1(1)-Point3(1)));
% if sign(Angle1)~=sign(Angle2)
%     Angle2=-Angle2;
% end
% Angle=mean([Angle1,Angle2]);
R=[cos(Angle),-sin(Angle);sin(Angle),cos(Angle)];
for i=1:length(Norm_X)
    Rot_XY(:,i)=R*[Norm_X(i);Norm_Y(i)];
end

% XY=round(Rot_XY*10)/10;
% [XY,Index]=sortrows(XY'); 
% A=[0;0;0;.2;.2;.3;.3;.3;.5;.5;.6;.6;.6;.8;.8;1;1;1];
% if ~isequal(XY(:,1),A)
%     XY=ceil(Rot_XY*10)/10;
%     [XY,Index]=sortrows(XY'); 
% end
% A=[0.1;0.1;0.1;.2;.2;.4;.4;.4;.6;.6;.7;.7;.7;.9;.9;1.1;1.1;1.1];
% if ~isequal(XY(:,1),A)
%     XY=floor(Rot_XY*10)/10;
%     [XY,Index]=sortrows(XY'); 
% end
% 
% 

  
Perf=[0/6,0/4;0/6,2/4;0/6,4/4;1/6,1/4;1/6,3/4;2/6,0/4;2/6,2/4;2/6,4/4;...
    3/6,1/4;3/6,3/4;4/6,0/4;4/6,2/4;4/6,4/4;5/6,1/4;5/6,3/4;6/6,0/4;...
    6/6,2/4;6/6,4/4];
[Dist,Index]=pdist2(Rot_XY',Perf,'euclidean','Smallest',18);
Minimum=min(Dist);
for i=1:18
    [R,C]=find(Minimum(i)==Dist);
    FinalIndex(i)=Index(R,C);
end
clear stats
for i=1:size(Rot_XY,2)
    stats(i).Centroid=[X(FinalIndex(i)),Y(FinalIndex(i))];
end
    
end

