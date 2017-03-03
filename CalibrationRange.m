function [Images] = CalibrationRange(Images)
% Range is in feet
[Images] = FindCheckerCorners(Images);
EXIF_Data=imfinfo(char(strcat(cellstr(Images.Left(1).Name),'.tif')));
Camera=EXIF_Data.Model;
switch Camera
    case 'NIKON D7000'
        ImageWidth=4928;            %[Pixels]
        SensorWidth=23.6;           %[mm]
        ImageHeight=3264;           %[Pixels]
        SensorHeight=15.6;          %[mm]
    case 'NIKON D7100'
        ImageWidth=6000;            %[Pixels]
        SensorWidth=23.5;           %[mm]   
        ImageHeight=4000;           %[Pixels]
        SensorHeight=15.6;          %[mm]
end
FocalLength=EXIF_Data.DigitalCamera.FocalLength;

for i=1:length(Images.Num)
    % Left
    Width(1)=Images.Left(i).Corners(1,1)-Images.Left(i).Corners(3,1);
    Width(2)=Images.Left(i).Corners(2,1)-Images.Left(i).Corners(4,1);
    Height(1)=Images.Left(i).Corners(1,2)-Images.Left(i).Corners(2,2);
    Height(2)=Images.Left(i).Corners(3,2)-Images.Left(i).Corners(4,2);
    ObjectWidthPIX=mean(abs(Width));
    ObjectHeightPIX=mean(abs(Height));
    
    ObjectHeightReal=207.7466;          %[mm] from current checkerboard
    DistanceHeight=(FocalLength.*ObjectHeightReal.*ImageHeight)./(ObjectHeightPIX.*SensorHeight);

    ObjectWidthReal=291.4142;           %[mm] from current checkerboard
    DistanceWidth=(FocalLength.*ObjectWidthReal.*ImageWidth)./(ObjectWidthPIX.*SensorWidth);

    Diff=abs(DistanceHeight-DistanceWidth);
    Distance=mean([DistanceHeight,DistanceWidth]);
    Distance=(Distance/1000)*3.28;
    Diff=(Diff/1000)*3.28;
    Images.Left(i).CalDistance=Distance;
    % Right
    clear Width Height Distance
    Width(1)=Images.Right(i).Corners(1,1)-Images.Right(i).Corners(3,1);
    Width(2)=Images.Right(i).Corners(2,1)-Images.Right(i).Corners(4,1);
    Height(1)=Images.Right(i).Corners(1,2)-Images.Right(i).Corners(2,2);
    Height(2)=Images.Right(i).Corners(3,2)-Images.Right(i).Corners(4,2);
    ObjectWidthPIX=mean(abs(Width));
    ObjectHeightPIX=mean(abs(Height));
    
    ObjectHeightReal=207.7466;          %[mm] from current checkerboard
    DistanceHeight=(FocalLength.*ObjectHeightReal.*ImageHeight)./(ObjectHeightPIX.*SensorHeight);

    ObjectWidthReal=291.4142;           %[mm] from current checkerboard
    DistanceWidth=(FocalLength.*ObjectWidthReal.*ImageWidth)./(ObjectWidthPIX.*SensorWidth);

    Diff=abs(DistanceHeight-DistanceWidth);
    Distance=mean([DistanceHeight,DistanceWidth]);
    Distance=(Distance/1000)*3.28;
    Diff=(Diff/1000)*3.28;
    Images.Right(i).CalDistance=Distance;
end

end

