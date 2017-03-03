function [radiiLeft,radiiRight,centersLeft,...
    centersRight,centersLeftDisplay,centersRightDisplay,Smallest] = ...
    MatchCircle(radiiLeft,radiiRight,centersLeft,centersRight,RectL,RectR)

%Determine shortest set of centers
if length(radiiLeft)~=length(radiiRight)
    if length(radiiLeft)<length(radiiRight)
        Smallest=length(radiiLeft);
        for i=1:Smallest
            %Find correlated point by shortest distance
            [MatchedPoint] = ClosestPoint(centersLeft(i,:),centersRight);
            %Index the matched point with a tolerance of one pixel
            Index=find(centersRight(:,1)<MatchedPoint(1,1)+1 &...
                centersRight(:,1)>MatchedPoint(1,1)-1);
            MatchedCenterR(i,:)=centersRight(Index(1),:); %#ok<*AGROW>
            MatchedRadiiR(i)=radiiRight(Index(1));
            MatchedCenterL(i,:)=centersLeft(i,:);
            MatchedRadiiL(i)=radiiLeft(i);
            clear Index
        end
    else
        Smallest=length(radiiRight);
        for i=1:Smallest
            [MatchedPoint] = ClosestPoint(centersRight(i,:),centersLeft);
            Index=find(centersLeft(:,1)<MatchedPoint(1,1)+1 &...
                centersLeft(:,1)>MatchedPoint(1,1)-1);
            MatchedCenterL(i,:)=centersLeft(Index(1),:); %#ok<*AGROW>
            MatchedRadiiL(i)=radiiLeft(Index(1));
            MatchedCenterR(i,:)=centersRight(i,:);
            MatchedRadiiR(i)=radiiRight(i);
            clear Index
        end
    end
else
    Smallest=length(radiiLeft);
    for i=1:Smallest
        [MatchedPoint] = ClosestPoint(centersLeft(i,:),centersRight);
        Index=find(centersRight(:,1)<MatchedPoint(1,1)+1 &...
            centersRight(:,1)>MatchedPoint(1,1)-1);
        MatchedCenterR(i,:)=centersRight(Index,:); %#ok<*AGROW>
        MatchedRadiiR(i)=radiiRight(Index);
        MatchedCenterL(i,:)=centersLeft(i,:);
        MatchedRadiiL(i)=radiiLeft(i);
    end
end
clear centersRight radiiRight centersLeft radiiLeft
centersRight=MatchedCenterR;
radiiRight=MatchedRadiiR;
centersLeft=MatchedCenterL;
radiiLeft=MatchedRadiiL;

%Find distance to every center from every center (Pairwise Distance)
LDist=pdist(centersLeft);
RDist=pdist(centersRight);
IndexL=find(LDist==0);
IndexR=find(RDist==0);
if ~isempty(IndexL)
    %Create an order matrix which matches the output of the pdist function
    Order=[];
    for i=2:Smallest
        p=i;
        while p<Smallest+1
            Order=[Order,p];
            p=p+1;
        end
    end
    Delete=Order(IndexL);
    centersLeft(Delete,:)=[];
    centersRight(Delete,:)=[];
    radiiLeft(Delete)=[];
    radiiRight(Delete)=[];
    Smallest=Smallest-1;
end
if ~isempty(IndexR)
    Order=[];
    for i=2:Smallest
        p=i;
        while p<Smallest+1
            Order=[Order,p];
            p=p+1;
        end
    end
    Delete=Order(IndexR);
    centersLeft(Delete,:)=[];
    centersRight(Delete,:)=[];
    radiiLeft(Delete)=[];
    radiiRight(Delete)=[];
    Smallest=Smallest-1;
end
%Subtract crop location for display on the cropped images
centersLeftDisplay(:,1)=centersLeft(:,1)-RectL(1);
centersLeftDisplay(:,2)=centersLeft(:,2)-RectL(2);
centersRightDisplay(:,1)=centersRight(:,1)-RectR(1);
centersRightDisplay(:,2)=centersRight(:,2)-RectR(2);


end

