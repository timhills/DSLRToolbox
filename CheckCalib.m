function [Images]=CheckCalib(handles,Images)
[Images] = Image_Names_GUI(handles,Images);
Check_Num=length(Images.Num);

for i=1:Check_Num
    IL=Image_Read(Images,i,'Left');
    PointsL=CheckDetect(IL);
    clear IL
    Images.Left(i).CheckerPoints=PointsL;
    
    IR=Image_Read(Images,i,'Right');
    PointsR=CheckDetect(IR);
    clear IR
    Images.Right(i).CheckerPoints=PointsR;
end
% In a future release all of the following will be held in a System object 
% similar to the goose detection algorithm. 
Images=CalibrationRange(Images);
EXIF_Data=imfinfo(char(strcat(cellstr(Images.Left(1).Name),'.tif')));
System=EXIF_Data.Model;
switch System
    case 'NIKON D7000'
        pix=4928/2;         %Number of pixels in horizontal divided by two
        PixY=3264/2;
        X=10/12;            %Seperation distance [ft]
        H=23.6/2;           %Half dimension of image [mm]
    case 'NIKON D7100'
        pix=6000/2;         %Number of pixels in horizontal divided by two
        PixY=4000/2;
        X=15/12;            %Seperation distance [ft]
        H=23.5/2;           %Half dimension of image [mm]
end
FocalLength=EXIF_Data.DigitalCamera.FocalLength;
switch FocalLength
    case 50
        PixL=pix;
        PixR=pix;        
        w=0.050788;
        FL=54.5;  
        FR=FL+w;
    case 105
        %This is an example of how it should work in the future release.
        %Eventually an object should be created at the very begining that
        %can be refernced from every function to allow easier control over
        %future iterations.
        load('D7100_105mm.mat');
        PixL=Parameters(1);
        PixR=Parameters(2);
        FL=Parameters(3);
        FR=Parameters(4);
%         w=-0.0273;
%         FL=104.55;  
%         FR=FL+w; 
    case 200
        PixL=pix;
        PixR=pix;  
        w=1.575;
        FL=200.5;
        FR=FL+w;
    case 300
        PixL=pix;
        PixR=pix;  
        w=-0.75;
        FL=300;
        FR=FL+w;
end
theta1=atan(H/FL);    %Half angle of view [Radians]
theta2=atan(H/FR);

for i=1:length(Images.Num)
    Range=(Images.Left(i).CalDistance+Images.Right(i).CalDistance)/2;
    PL=mean(Images.Left(i).CheckerPoints(:,1));
    PLY=mean(Images.Left(i).CheckerPoints(:,2));
    PR=mean(Images.Right(i).CheckerPoints(:,1));
    [a(i),R(i)]=Calibration(PL,PR,PLY,Range,PixL,PixR,PixY,theta1,theta2,X,FL,System);     %#ok<AGROW>
end
%The correction angle asymptotes as the range increases. If the difference
%in correction angles is large then the correction angle for the greatest
%distance will be used for the most accuracy instead of averaging.
% Diff=a-mean(a);
% if max(Diff)>0.0015
%     [~,Index]=max(R);
%     Calib.CorrectionAngle=a(Index); %#ok<*STRNU>
% else
%     Calib.CorrectionAngle=mean(a);
% end
Calib.CorrectionAngle=a;
Calib.Range=R;
Calib.Image=Images;
save('Calib_Results','Calib')
MainStereo;
end











