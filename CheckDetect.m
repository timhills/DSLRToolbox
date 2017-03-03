function [Label] = CheckDetect(Image)
%UNTITLED15 Summary of this function goes here
%   Detailed explanation goes here
close all
I=Image;    
fig=figure();
imshow(I)
set (fig, 'Units', 'normalized', 'Position', [0.0045,0.045,.99,.873]);
h2=imrect; %Rectangle ROI selected by the user
text(10,1,'Double click within the rectangle when ready to process.','BackgroundColor',[1 1 1])
Position.First=getPosition(h2); %The position of the rectangle to be used for all images.
wait(h2); %Holds the ROI until the interior is double clicked with the mouse.
I=imcrop(I,[Position.First(1) Position.First(2) Position.First(3) Position.First(4)]);
I = imsharpen(I,'Amount',2);
fig=figure();
imshow(I)
set (fig, 'Units', 'normalized', 'Position', [0.0045,0.045,.99,.873]);
pause(1)


[imagePoints, boardSize] = detectCheckerboardPoints(I);
%Check if detectCheckerboardPoints function returned information
TF=isempty(imagePoints);
if TF==0 && boardSize(1)==7 && boardSize(2)==9
    J = insertText(I, imagePoints, 1:size(imagePoints, 1));
    J = insertMarker(J, imagePoints, 'o', 'Color', 'red', 'Size', 5);
    fig=figure();
    imshow(J);
    set (fig, 'Units', 'normalized', 'Position', [0.0045,0.045,.99,.873]);
    title(sprintf('Detected a %d x %d Checkerboard', boardSize));
    imagePoints=[imagePoints(:,1)+Position.First(1),...
        imagePoints(:,2)+Position.First(2)];
    pause(2)
    k=1;
    for i=1:boardSize(1)-1
        for j=1:boardSize(2)-1
            CheckerPoints.X(i,j)=imagePoints(k,1);
            CheckerPoints.Y(i,j)=imagePoints(k,2);
            k=k+1;
        end        
    end
else
    Gray = rgb2gray(I);
    BW = im2bw(I,graythresh(Gray));
    fig=figure();
    imshow(BW)
    set (fig, 'Units', 'normalized', 'Position', [0.0045,0.045,.99,.873]);
    h3=imrect; %Rectangle ROI selected by the user
    text(10,1,'Double click within the rectangle when ready to process.',...
        'BackgroundColor',[1 1 1])
    wait(h3); %Holds the ROI until the interior is double clicked with the mouse.
    Position.Second=getPosition(h3); %The position of the rectangle to be used for all images.
    BW=imcrop(BW,[Position.Second(1) Position.Second(2) Position.Second(3)...
        Position.Second(4)]);
    %Run a test to see if further processing must be performed. If the
    %number of areas detected is equal to 18 then processing is most likely
    %finished.
    BW=imcomplement(BW);
    BWTest=BW;
    BWTest=imclearborder(BWTest, 4);
    BWTest = bwareaopen(BWTest,50);
    [~,L] = bwboundaries(BWTest,'noholes');
    stats = regionprops(L,'Area');
    iter=0;
    if length(stats)~=18
        SE=strel('square',3);
        %Set an image to allow multiple erosions. Data is deleted if
        %borders are cleared and the erosion is not correct.
        BWTest1=BW;
        while length(stats)~=18
            %Erode until 18 objects are found
            BWTest1=imerode(BWTest1,SE);
            BWTest=imclearborder(BWTest1, 4);
            BWTest = bwareaopen(BWTest,50);
            clear stats L
            [~,L] = bwboundaries(BWTest,'noholes');            
            stats = regionprops(L,'Area');
            iter=iter+1;
            if iter>10
                BWTest=BW;
                clear stats L
                [~,L] = bwboundaries(BWTest,'noholes');            
                stats = regionprops(L,'Area');
                break
            end
        end
    end
    BW=BWTest;        
    imshow(BW)

%     fig=figure();
%     imshow(BW);
%     set (fig, 'Units', 'normalized', 'Position', [0.0045,0.045,.99,.873]);
%     Extra=menu('Have all of the extra regions been removed?','Yes','No');
%     switch Extra
%         case 1
%         otherwise
%             text(10,1,'Select regions to remove for futher processing then hit enter.','BackgroundColor',[1 1 1])
%             BW_Remove=bwselect(BW,8);
%             BW_Inv=imcomplement(BW);
%             BW_Inv=BW_Inv+BW_Remove;
%             BW=imcomplement(BW_Inv);
%             BW = bwareaopen(BW,6);
%     end
    [B,L] = bwboundaries(BW,'noholes');
%     RGB=label2rgb(L, @jet, [.5 .5 .5]);
%     fig=figure();
%     imshow(RGB)
%     set (fig, 'Units', 'normalized', 'Position', [0.0045,0.045,.99,.873]);
%     hold on
%     
%     for k = 1:length(B)
%       boundary = B{k};
%       plot(boundary(:,2), boundary(:,1), 'w', 'LineWidth', 2)
%     end
%     pause(1)
    
    stats = regionprops(L,'Centroid');
    [stats] = LinkQuadrangle(stats);
    Dim1=[1,2,2,3,4,4,5,5,6,7,7,8,9,9,10,10,11,12,12,13,14,14,15,15];
    Dim2=[4,4,5,5,6,7,7,8,9,9,10,10,11,12,12,13,14,14,15,15,16,17,17,18];
    CornerX=[];
    CornerY=[];
    k=1;
    %Find inner corners
    for i=1:6
        Col=[];
        for j=1:4
            Width(k)=abs(stats(Dim1(k)).Centroid(1)-stats(Dim2(k)).Centroid(1))/2; %#ok<*AGROW>
            Height(k)=(stats(Dim1(k)).Centroid(2)-stats(Dim2(k)).Centroid(2))/2;
            C=[stats(Dim1(k)).Centroid(1)+Width(k),stats(Dim2(k)).Centroid(2)+Height(k)];
            Col=[Col;C]; 
            k=k+1;
            clear C
        end
        CornerX=[CornerX,Col(:,1)];
        CornerY=[CornerY,Col(:,2)];
        clear Col
    end
    %Find outer corners using slopes from inner corners
    for i=1:3
        XDiff1(i,:)=CornerX(i+1,:)-CornerX(i,:);
        YDiff1(i,:)=CornerY(i+1,:)-CornerY(i,:);       
    end
    for i=1:5
        XDiff2(:,i)=CornerX(:,i+1)-CornerX(:,i);
        YDiff2(:,i)=CornerY(:,i+1)-CornerY(:,i);
    end
    XDiff1=mean(XDiff1);
    YDiff1=mean(YDiff1);
    XDiff2=mean(mean(XDiff2,2));
    YDiff2=mean(mean(YDiff2,2));
    TopCornerX=CornerX(1,:)-XDiff1;
    TopCornerY=CornerY(1,:)-YDiff1;
    BottomCornerX=CornerX(4,:)+XDiff1;
    BottomCornerY=CornerY(4,:)+YDiff1;
    CornerX=[TopCornerX;CornerX;BottomCornerX];
    CornerY=[TopCornerY;CornerY;BottomCornerY]; 
    LeftCornerX=CornerX(:,1)-XDiff2;
    LeftCornerY=CornerY(:,1)-YDiff2;
    RightCornerX=CornerX(:,6)+XDiff2;
    RightCornerY=CornerY(:,6)+YDiff2;
    CornerX=[LeftCornerX,CornerX,RightCornerX];
    CornerY=[LeftCornerY,CornerY,RightCornerY];        
    boardSize=[7,9];
%     for i=1:6
%         for j=1:8
%             RGB = insertMarker(RGB, [CornerX(i,j),CornerY(i,j)],...
%                 'o', 'Color', 'red', 'Size', 5);
%         end
%     end
%     fig=figure();
%     imshow(RGB)   
%     set (fig, 'Units', 'normalized', 'Position', [0.0045,0.045,.99,.873]);
%     pause(1)
    CheckerPoints.X=(CornerX)+Position.First(1)+Position.Second(1);
    CheckerPoints.Y=(CornerY)+Position.First(2)+Position.Second(2);    
end

close all
clear I
numPoints=numel(CheckerPoints.X);
Label=[reshape(CheckerPoints.X,numPoints,1),reshape(CheckerPoints.Y,numPoints,1)];
I = Image;
J = insertText(I,Label,1:numPoints);
J = insertMarker(J, Label, 'o', 'Color', 'red', 'Size', 5);
fig=figure();
imshow(J);
set (fig, 'Units', 'normalized', 'Position', [0.0045,0.045,.99,.873]);
title(sprintf('Detected a %d x %d Checkerboard', boardSize));
pause(1)
end

