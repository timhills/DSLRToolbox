function [A] = RollCalc(YPixCoordinates,YawCorrectionAngles)
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here
[A]=polyfit(YPixCoordinates,YawCorrectionAngles,1);

end

