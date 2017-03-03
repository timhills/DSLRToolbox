classdef SingleData
    %SingleData stores the 2-D image data from the image of every goose,
    %the 3-D position data and velocity data of every goose as well as the  
    %image number. Properties are protected to ensure that users can't
    %manipulate the data.
    
    properties (SetAccess=protected)
        PairNumber
        System
        Folder
        Comments
        Calibration
        Geese
    end
    
    methods
        function EObj = SingleData(Calib,Images,CurrentImage)
            if nargin>1
                Name=char(strcat(Images.Left(CurrentImage).Name));
                EObj.PairNumber=Name(5:end);
                EObj.Folder=pwd;
                for i=1:length(Calib.CorrectionAngle)
                    Location=mean(Calib.Image.Left(i).CheckerPoints);
                    PY(i)=Location(2);
                end                
                Calib.Coefficients=polyfit(PY,Calib.CorrectionAngle,1);            
                               
                EObj.Calibration=Calib;   
                EXIF_Data=imfinfo(char(strcat(cellstr(Images.Left(1).Name),'.tif')));
                Camera=EXIF_Data.Model;
                Sys.Model=Camera;
                FocalLength=EXIF_Data.DigitalCamera.FocalLength;
                switch Camera
                    case 'NIKON D7000'
                        Sys.Baseline=10/12;         %[ft]
                        Sys.HalfDimension=23.6/2;   %Half dimension of sensor [mm]
                        if FocalLength==50
                            load('D7000_50mm.mat');
                            Sys.LeftPix=Parameters(1);
                            Sys.RightPix=Parameters(2);
                            Sys.LeftFocalLength=Parameters(3);
                            Sys.RightFocalLength=Parameters(4);                            
                        else
                            msgbox('No calibration parameters were detected for this lens and camera.')
                        end
                    case 'NIKON D7100'
                        Sys.Baseline=15/12;         %[ft]
                        Sys.HalfDimension=23.5/2;   %Half dimension of sensor [mm]
                        if FocalLength==105
                            load('D7100_105mm.mat');
                            Sys.LeftPix=Parameters(1);
                            Sys.RightPix=Parameters(2);
                            Sys.LeftFocalLength=Parameters(3);
                            Sys.RightFocalLength=Parameters(4);                            
                        else
                            msgbox('No calibration parameters were detected for this lens and camera.')
                        end
                end
                EObj.System=Sys;
            end
        end
        function EObj = SetGeese(EObj,GeeseObjects)
            EObj.Geese=GeeseObjects;
            EObj = EObj.Triangulate;
        end
        function EObj = Triangulate(EObj)
            if ~isempty(EObj.Calibration)
                Range=[];
                for i=1:length(EObj.Geese)
                    EObj.Geese(i)=EObj.Geese(i).Triangulate(EObj.Calibration,...
                        EObj.System);  
                    Range=[Range;sign(EObj.Geese(i).Z_Location).*...
                        sqrt(EObj.Geese(i).X_Location.^2+...
                        EObj.Geese(i).Y_Location.^2+...
                        EObj.Geese(i).Z_Location.^2)];
                end
                Average=mean(Range);
                StanDev=std(Range);
                if StanDev<20
                    StanDev=20;
                end
                clear Range
                for i=1:length(EObj.Geese)
                    Range=sign(EObj.Geese(i).Z_Location).*...
                        sqrt(EObj.Geese(i).X_Location.^2+...
                        EObj.Geese(i).Y_Location.^2+...
                        EObj.Geese(i).Z_Location.^2);
                    Index=find(Range>Average+StanDev);
                    Index=[Index;find(Range<Average-StanDev)];
                    Index=[Index;find(Range<0)];
                    if ~isempty(Index)
                        EObj.Geese(i).X_Location(Index)=[];
                        EObj.Geese(i).Y_Location(Index)=[];
                        EObj.Geese(i).Z_Location(Index)=[];
                    end
                    
                    %filter to eliminate data points that are not part of
                    %the actual goose
                    %Added by Tim Hills, 9-4-2016
                    if (~isempty(EObj.Geese(i).X_Location) == 1) && (~isempty(EObj.Geese(i).Y_Location) == 1) && (~isempty(EObj.Geese(i).Z_Location) == 1)
                        XRound = round(EObj.Geese(i).X_Location);
                        YRound = round(EObj.Geese(i).Y_Location);
                        ZRound = round(EObj.Geese(i).Z_Location);

                        XMode = mode(XRound);
                        YMode = mode(YRound);
                        ZMode = mode(ZRound);
                        
                        j = length(EObj.Geese(i).X_Location);
                        while j >= 1
                            DifferenceX = abs(XRound(j) - XMode);
                            if DifferenceX > 2
                                EObj.Geese(i).X_Location(j) = [];
                                EObj.Geese(i).Y_Location(j) = [];
                                EObj.Geese(i).Z_Location(j) = [];
                                j = j - 1;
                            elseif DifferenceX <= 2
                                j = j - 1;
                            end
                        end
                        
                        j = length(EObj.Geese(i).X_Location);
                        while j >= 1
                            DifferenceY = abs(YRound(j) - YMode);
                            if DifferenceY > 2
                                EObj.Geese(i).X_Location(j) = [];
                                EObj.Geese(i).Y_Location(j) = [];
                                EObj.Geese(i).Z_Location(j) = [];
                                j = j - 1;
                            elseif DifferenceY <= 2
                                j = j - 1;
                            end
                        end
                        
                        j = length(EObj.Geese(i).X_Location);
                        while j >= 1
                            DifferenceZ = abs(ZRound(j) - ZMode);
                            if DifferenceZ > 2
                                EObj.Geese(i).X_Location(j) = [];
                                EObj.Geese(i).Y_Location(j) = [];
                                EObj.Geese(i).Z_Location(j) = [];
                                j = j - 1;
                            elseif DifferenceZ <= 2
                                j = j - 1;
                            end
                        end
                        
                        %added by Tim Hills, 9-6-2016
                        if strcmp(EObj.Geese(i).ID,'LeadGoose') == 1
                            plot3(EObj.Geese(i).Z_Location,...
                                EObj.Geese(i).X_Location,EObj.Geese(i).Y_Location,'o','LineWidth',5)
                        elseif strcmp(EObj.Geese(i).ID,'RearGooseOne') == 1
                            plot3(EObj.Geese(i).Z_Location,...
                                EObj.Geese(i).X_Location,EObj.Geese(i).Y_Location,'o','LineWidth',4)
                        elseif strcmp(EObj.Geese(i).ID,'RearGooseTwo') == 1
                            plot3(EObj.Geese(i).Z_Location,...
                                EObj.Geese(i).X_Location,EObj.Geese(i).Y_Location,'o','LineWidth',3)
                        else

                            plot3(EObj.Geese(i).Z_Location,...
                                EObj.Geese(i).X_Location,EObj.Geese(i).Y_Location,'o','LineWidth',1)
                        end
                    end
                end
                    grid on
                    clear Index
                %end
                %automatically saves generated figure to a folder 
                %added by Tim Hills, 9-4-2016
                hold on
                axis equal
                [UpperPath, CurrentFolder] = fileparts(cd);
                %gcf: get handle on current figure and save figure
                FolderPath = 'C:\Users\Astex\Documents\MATLAB\Geese Analysis\Raw Geese Data 2';
                saveas(gcf, fullfile(FolderPath, [EObj.PairNumber,'_',CurrentFolder]), 'fig');
            end
        end
        function EObj = CommentBox(EObj)
            EObj.Comments = inputdlg('Enter Comment','Comment',10);
        end      
        
        
    end
    
end

