function [Images] = FindCheckerCorners(Images)
%UNTITLED13 Summary of this function goes here
%   Detailed explanation goes here
for a=1:length(Images.Num)
    % Left
    A=Images.Left(a).CheckerPoints;
    [~,Index1]=min(sum(A,2));
    [~,Index2]=max(sum(A,2));
    Corner1=A(Index1,:);
    Corner4=A(Index2,:);
    Guess2=[Corner1(1)-5,Corner4(2)+5];
    Guess3=[Corner4(1)+5,Corner1(2)-5];
    Diff2=zeros(size(A,1),1);
    Diff3=zeros(size(A,1),1);
    for b=1:size(A,1)
        Diff2(b)=sqrt((Guess2(1)-A(b,1))^2+(Guess2(2)-A(b,2))^2);
        Diff3(b)=sqrt((Guess3(1)-A(b,1))^2+(Guess3(2)-A(b,2))^2);
    end
    [~,Index1]=min(Diff2);
    [~,Index2]=min(Diff3);
    Corner2=A(Index1,:);
    Corner3=A(Index2,:);
    Images.Left(a).Corners=[Corner1;Corner2;Corner3;Corner4];
    % Right
    clear A Corner1 Corner2 Corner3 Corner4 Corners
    A=Images.Right(a).CheckerPoints;
    [~,Index1]=min(sum(A,2));
    [~,Index2]=max(sum(A,2));
    Corner1=A(Index1,:);
    Corner4=A(Index2,:);
    Guess2=[Corner1(1)-5,Corner4(2)+5];
    Guess3=[Corner4(1)+5,Corner1(2)-5];
    Diff2=zeros(size(A,1),1);
    Diff3=zeros(size(A,1),1);
    for b=1:size(A,1)
        Diff2(b)=sqrt((Guess2(1)-A(b,1))^2+(Guess2(2)-A(b,2))^2);
        Diff3(b)=sqrt((Guess3(1)-A(b,1))^2+(Guess3(2)-A(b,2))^2);
    end
    [~,Index1]=min(Diff2);
    [~,Index2]=min(Diff3);
    Corner2=A(Index1,:);
    Corner3=A(Index2,:);
    Images.Right(a).Corners=[Corner1;Corner2;Corner3;Corner4];
end
end

