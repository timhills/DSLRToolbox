classdef Goose
    %UNTITLED8 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties %(SetAccess = protected, GetAccess = public)
        BoundingBox
        Centroid
        ID
        MSER
        M_Points
        M_Pairs
        SURF
        S_Points
        S_Pairs
%         FAST
%         F_Points
%         F_Pairs
        BRISK
        B_Points
        B_Pairs
        MSER_Coordinates
        SURF_Coordinates
        BRISK_Coordinates
        Matched_Pixels
        X_Location
        Y_Location
        Z_Location
    end
    
    methods
        function EObj = Goose(FinderObj,Index)
            %Bounding Boxes and Centroids correspond to the left image only            
            EObj.BoundingBox(1,:)=FinderObj.BoundingBoxes(Index,:);
            EObj.Centroid(1,:)=FinderObj.Centroids(Index,:);
            EObj.ID=Index;
        end
        function EObj = FeatureFinder(EObj,LeftImage)
            if nargin>0
                leftImage=LeftImage.Original;
                if size(leftImage,3)>1
                    IL=rgb2gray(leftImage);
                else
                    IL=leftImage;
                end
                clear LeftImage
                M = detectMSERFeatures(IL,'ROI',EObj.BoundingBox);
                S = detectSURFFeatures(IL,'ROI',EObj.BoundingBox);
%                 F = detectFASTFeatures(IL,'ROI',EObj.BoundingBox);
                B = detectBRISKFeatures(IL,'ROI',EObj.BoundingBox);
                [EObj.MSER, EObj.M_Points] = extractFeatures(IL,M);
                [EObj.SURF, EObj.S_Points] = extractFeatures(IL,S);
%                 [EObj.FAST, EObj.F_Points] = extractFeatures(IL,F);
                [EObj.BRISK, EObj.B_Points] = extractFeatures(IL,B);   
            end
        end
        function EObj = FeatureMatcher(EObj,RightFeatures)
            if nargin>0
                if ~isempty(EObj.MSER) && ~isempty(RightFeatures.MSER)
                [EObj.M_Pairs] = matchFeatures(EObj.MSER,...
                    RightFeatures.MSER);            
                end
                
                if ~isempty(EObj.SURF) && ~isempty(RightFeatures.SURF)
                [EObj.S_Pairs] = matchFeatures(EObj.SURF,...
                    RightFeatures.SURF);
                end
                
%                 if ~isempty(EObj.FAST) && ~isempty(RightFeatures.FAST)
%                 [Obj.F_Pairs] = matchFeatures(EObj.FAST,...
%                     RightFeatures.FAST);
%                 else
%                     disp('No FAST features were matched.')
%                 end
                
                if ~isempty(EObj.BRISK) && ~isempty(RightFeatures.BRISK)
                [EObj.B_Pairs] = matchFeatures(EObj.BRISK,...
                    RightFeatures.BRISK);
                end               
            end   
        end
        function EObj = MatchGoose(EObj,RightFeatures,...
                    LeftImageObj,RightImageObj,DisplayOn)                
            if nargin>0
                leftImage=LeftImageObj.Original;
                rightImage=RightImageObj.Original;
                if nargin==5
                    switch DisplayOn
                        case 'On'
                            Display=1;
                        case 'Off'
                            Display=0;
                        otherwise
                            disp('DisplayOn must either be ''On'' or ''Off''.')
                            Display=0;
                    end 
                else
                    Display=0;
                end                   
             
                EObj=EObj.FeatureFinder(LeftImageObj);
                EObj=EObj.FeatureMatcher(RightFeatures);
                
                if ~isempty(EObj.M_Pairs)
                    Matched_MSER_Left = EObj.M_Points(EObj.M_Pairs(:,1));
                    Matched_MSER_Right = ...
                        RightFeatures.M_Points(EObj.M_Pairs(:,2));
                    if Display==1
                        figure() %For GUI replace with set(AxisNameHere)
                        showMatchedFeatures(leftImage,rightImage,...
                            Matched_MSER_Left,Matched_MSER_Right); 
                        title('MSER')
                    end
                end

                if ~isempty(EObj.S_Pairs)
                    Matched_SURF_Left = EObj.S_Points(EObj.S_Pairs(:,1));
                    Matched_SURF_Right = ...
                        RightFeatures.S_Points(EObj.S_Pairs(:,2));
                    if Display==1
                        figure() %For GUI replace with set(AxisNameHere)
                        showMatchedFeatures(leftImage,rightImage,...
                            Matched_SURF_Left,Matched_SURF_Right); 
                        title('SURF')
                    end
                end
                
%                 if ~isempty(EObj.F_Pairs)
%                     Matched_FAST_Left = EObj.F_Points(EObj.F_Pairs(:,1));
%                     Matched_FAST_Right = ...
%                         RightFeatures.F_Points(EObj.F_Pairs(:,2));
%                     if Display==1
%                         figure() %For GUI replace with set(AxisNameHere)
%                         showMatchedFeatures(leftImage,rightImage,...
%                             Matched_FAST_Left,Matched_FAST_Right); 
%                         title('FAST')
%                     end
%                 else
%                     disp('No FAST features were matched.')
%                 end

                if ~isempty(EObj.B_Pairs)                    
                    Matched_BRISK_Left = EObj.B_Points(EObj.B_Pairs(:,1));
                    Matched_BRISK_Right = ...
                        RightFeatures.B_Points(EObj.B_Pairs(:,2));
                    if Display==1
                        figure() %For GUI replace with set(AxisNameHere)
                        showMatchedFeatures(leftImage,rightImage,...
                            Matched_BRISK_Left,Matched_BRISK_Right); 
                        title('BRISK')
                    end
                end

            end
        end
        function EObj = MatchPoints(EObj)
            EObj.Matched_Pixels=[];
            if ~isempty(EObj.MSER_Coordinates)
                EObj.Matched_Pixels=[EObj.Matched_Pixels;...
                    EObj.MSER_Coordinates];
            end
            if ~isempty(EObj.SURF_Coordinates)
                EObj.Matched_Pixels=[EObj.Matched_Pixels;...
                    EObj.SURF_Coordinates];
            end
            if ~isempty(EObj.BRISK_Coordinates)
                EObj.Matched_Pixels=[EObj.Matched_Pixels;...
                    EObj.BRISK_Coordinates];
            end
        end
        function EObj = Triangulate(EObj,Calibration,System)
            EObj = EObj.MatchPoints;
            if ~isempty(EObj.Matched_Pixels)
                %Set Parameters 
                X=System.Baseline;
                FL=System.LeftFocalLength;
                FR=System.RightFocalLength;
                pixL=System.LeftPix;
                pixR=System.RightPix;
                H=System.HalfDimension;
                theta1=atan(H/FL);    %Half angle of view [Radians]
                theta2=atan(H/FR);

                PL=EObj.Matched_Pixels(:,1);
                PY=EObj.Matched_Pixels(:,2);
                PR=EObj.Matched_Pixels(:,3);
                for i=1:length(PL(:,1))
                    a=Calibration.Coefficients(1)*PY(i)+Calibration.Coefficients(2);
                    EObj.Z_Location(i,1)=ZCalc(PL(i),PR(i),a,X,theta1,theta2,pixL,pixR);
                end
                EObj.X_Location=XCalc(EObj.Z_Location,PL-pixL,FL,System.Model)*0.3048;
                EObj.Y_Location=YCalc(EObj.Z_Location,PY,FL,System.Model)*0.3048;
                EObj.Z_Location=EObj.Z_Location*0.3048;
            end
        end
            
            
            
            
        function GooseID = Delete(EObj)
            GooseID = EObj.ID;
            clear EObj
        end
  
            
            
            
            
    end
    
end

