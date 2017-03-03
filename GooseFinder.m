classdef GooseFinder < handle
    %UNTITLED9 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (SetAccess = protected)
        BoundingBoxes
        Centroids
        Perimeter
        Area
        Number_of_Geese
        Geese
        ImageName
        NumberOfRearGeese
    end
    
    methods
        function EObj = GooseFinder(Image)
            stats = FindGeese(Image.Cropped,Image.Name);
            if ~isempty(stats)
                EObj.Number_of_Geese = length(stats);
                for i=1:EObj.Number_of_Geese
                    EObj.BoundingBoxes(i,:) = floor(stats(i).BoundingBox);
                    EObj.BoundingBoxes(i,1:2) = EObj.BoundingBoxes(i,1:2)+...
                        floor(Image.Crop_Location(1:2));
                    EObj.Centroids(i,:) = stats(i).Centroid+...
                        Image.Crop_Location(1:2);
                end
            else
                disp('No geese were detected in image.')
            end   
        EObj.Plot(Image) 
        end
        function EObj = CreateGeese(EObj)
            if EObj.Number_of_Geese~=0
                for i=1:EObj.Number_of_Geese
                    G(i,:)=Goose(EObj,i); %#ok<AGROW>
                end
                EObj.Geese=G;
            else
                EObj.Number_of_Geese=0;
                msgbox('Could not create geese because no geese were detected.')
            end            
        end
        function EObj = RemoveGeese(EObj,handles,Image)      
            axes(handles.axes1)
            K=impoint;
            J=getPosition(K);
            [SelectedPoint] = ClosestPoint(J,EObj.Centroids);
            clear K J
            [Index]=find(floor(SelectedPoint(1))==floor(EObj.Centroids(:,1))...
                & floor(SelectedPoint(2))==floor(EObj.Centroids(:,2)));
            EObj.Centroids(Index,:)=[];
            EObj.BoundingBoxes(Index,:)=[];
%             EObj.Area(Index)=[];
%             EObj.Perimeter(Index)=[];
            EObj.Number_of_Geese=EObj.Number_of_Geese-1;
            EObj.Geese(Index).Delete;
            EObj.Plot(Image)            
        end
        function EObj = AddGeese(EObj,handles,Image)
            axes(handles.axes1)
            Index=EObj.Number_of_Geese+1;
            %Rectangle ROI selected by the user
            h=imrect;
            %Hold the ROI until the interior is double clicked.
            wait(h);
            %The position of the rectangle to be used for all images.
            EObj.BoundingBoxes(Index,:)=floor(getPosition(h));
            EObj.Centroids(Index,:)=[EObj.BoundingBoxes(Index,1)+...
                EObj.BoundingBoxes(Index,3)/2,EObj.BoundingBoxes(Index,2)+...
                EObj.BoundingBoxes(Index,4)/2];
            EObj.Number_of_Geese=EObj.Number_of_Geese+1;
            if Index~=1
                EObj.Geese(Index)=Goose(EObj,Index);
            else
                EObj.Geese=Goose(EObj,Index);
            end
            EObj.Plot(Image)            
        end
        
        %function added by Tim Hills, 9-6-2016
        function EObj = LeadGeese(EObj,handles,Image)
            axes(handles.axes1)
            Index=EObj.Number_of_Geese+1;
            %Rectangle ROI selected by the user
            h=imrect;
            %Hold the ROI until the interior is double clicked.
            wait(h);
            %The position of the rectangle to be used for all images.
            EObj.BoundingBoxes(Index,:)=floor(getPosition(h));
            EObj.Centroids(Index,:)=[EObj.BoundingBoxes(Index,1)+...
                EObj.BoundingBoxes(Index,3)/2,EObj.BoundingBoxes(Index,2)+...
                EObj.BoundingBoxes(Index,4)/2];
            if Index~=1
                EObj.Geese(Index)=Goose(EObj,Index);
            else
                EObj.Geese=Goose(EObj,Index);
            end
            
            SmallestDifference = 1e+6;
            for i = 1:(Index - 1)
                Difference(i,:) = abs(EObj.Centroids(i,:) - EObj.Centroids(Index,:));
                if Difference(i,:) < SmallestDifference
                    SmallestDifference = Difference(i,:);
                    LeadGooseIndex = i;
                end
            end
            EObj.Geese(LeadGooseIndex).ID = 'LeadGoose';
            EObj.BoundingBoxes = EObj.BoundingBoxes((1:Index-1),:);
            EObj.Centroids = EObj.Centroids((1:Index-1),:);
            EObj.Geese = EObj.Geese(1:Index-1);
            EObj.Plot(Image)
        end
        
        %function added by Tim Hills, 9-6-2016
        function EObj = RearGeese(EObj,handles,Image,Number)
            EObj.NumberOfRearGeese = Number + 1;
            axes(handles.axes1)
            Index=EObj.Number_of_Geese+1;
            %Rectangle ROI selected by the user
            h=imrect;
            %Hold the ROI until the interior is double clicked.
            wait(h);
            %The position of the rectangle to be used for all images.
            EObj.BoundingBoxes(Index,:)=floor(getPosition(h));
            EObj.Centroids(Index,:)=[EObj.BoundingBoxes(Index,1)+...
                EObj.BoundingBoxes(Index,3)/2,EObj.BoundingBoxes(Index,2)+...
                EObj.BoundingBoxes(Index,4)/2];
            if Index~=1
                EObj.Geese(Index)=Goose(EObj,Index);
            else
                EObj.Geese=Goose(EObj,Index);
            end
            
            SmallestDifference = 1e+10;
            for i = 1:(Index - 1)
                Difference(i,:) = abs(EObj.Centroids(i,:) - EObj.Centroids(Index,:));
                if Difference(i,:) < SmallestDifference
                    SmallestDifference = Difference(i,:);
                    RearGooseIndex = i;
                end
            end
            if EObj.NumberOfRearGeese == 2
                EObj.Geese(RearGooseIndex).ID = 'RearGooseOne';
            else
                EObj.Geese(RearGooseIndex).ID = 'RearGooseTwo';
            end
            EObj.BoundingBoxes = EObj.BoundingBoxes((1:Index-1),:);
            EObj.Centroids = EObj.Centroids((1:Index-1),:);
            EObj.Geese = EObj.Geese(1:Index-1);
            EObj.Plot(Image)
        end
        
        function Plot(EObj,Image)
            cla reset
            imshow(Image.Original)
            hold on
            for i = 1:EObj.Number_of_Geese
                plot(EObj.Centroids(i,1),EObj.Centroids(i,2),...
                    'ro','Markersize',6)
                rectangle('Position',EObj.BoundingBoxes(i,:),...
                    'EdgeColor','r','LineWidth',2)
            end
        end
        function EObj = MatchGeese(EObj,Right,IMLeft,IMRight)
            msg=[];
            h = waitbar(0,'Matching features...');
            SuccMatch=0;
            for i=1:EObj.Number_of_Geese
                Match(i,:)=EObj.Geese(i).MatchGoose(Right,IMLeft,IMRight,'Off'); %#ok<AGROW>
                EObj.Geese(i)=Match(i);
                T=0;
                if ~isempty(Match(i).M_Pairs)
                    EObj.Geese(i).MSER_Coordinates(:,1:2)=...
                        Match(i).M_Points(Match(i).M_Pairs(:,1)).Location;
                    EObj.Geese(i).MSER_Coordinates(:,3:4)=...
                        Right.M_Points(Match(i).M_Pairs(:,2)).Location;
                    M=[];
                    T=1;
                else
                    M=sprintf('No MSER features were matched for Goose %d.',i);
                    M=[M,blanks(50-length(M))];
                end
                
                if ~isempty(Match(i).S_Pairs)
                    EObj.Geese(i).SURF_Coordinates(:,1:2)=...
                        Match(i).S_Points(Match(i).S_Pairs(:,1)).Location;
                    EObj.Geese(i).SURF_Coordinates(:,3:4)=...
                        Right.S_Points(Match(i).S_Pairs(:,2)).Location;
                    S=[];
                    T=1;
                else
                    S=sprintf('No SURF features were matched for Goose %d.',i);
                    S=[S,blanks(50-length(S))];
                end
                
                if ~isempty(Match(i).B_Pairs)
                    EObj.Geese(i).BRISK_Coordinates(:,1:2)=...
                        Match(i).B_Points(Match(i).B_Pairs(:,1)).Location;
                    EObj.Geese(i).BRISK_Coordinates(:,3:4)=...
                        Right.B_Points(Match(i).B_Pairs(:,2)).Location;
                    B=[];
                    T=1;
                else
                    B=sprintf('No BRISK features were matched for Goose %d.',i);
                    B=[B,blanks(50-length(B))];
                end
                msg=[msg;M;S;B];                 %#ok<AGROW>
                waitbar(i/EObj.Number_of_Geese,h)
                if T==1
                    SuccMatch=SuccMatch+1;
                end
            end
            close(h)
            Succ=sprintf('%d geese were successfully matched.',SuccMatch);
            msg=[msg;[Succ,blanks(50-length(Succ))]];
            msgbox(msg)        
        end         
          
    end
    
end

