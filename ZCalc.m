function [RCalc] = ZCalc(PixelLeft,PixelRight,CorrectionAngle,SeperationDistance,...
    HalfAngleofViewLeft,HalfAngleofViewRight,HalfPictureWidthPIXLeft,...
    HalfPictureWidthPIXRight)
B=SeperationDistance;
theta1=HalfAngleofViewLeft;
theta2=HalfAngleofViewRight;
pixL=HalfPictureWidthPIXLeft;
pixR=HalfPictureWidthPIXRight;
PL=PixelLeft;
PR=PixelRight;
a=CorrectionAngle;

RCalc=[];

for ii=1:size(PL,2)
            if PL(ii)>pixL && PR(ii)<pixL
                a1=atan((PL(ii)-(pixL))/(pixL)*tan(theta1));
                a2=atan((pixR-PR(ii))/pixR*tan(theta2))+a; 
                R=(tan(pi/2-a1)*tan(pi/2-a2)*B)/(tan(pi/2-a1)+tan(pi/2-a2));   
            elseif PL(ii)<pixL
                a1=atan(((pixL)-PL(ii))/(pixL)*tan(theta1));
                a2=atan((pixR-PR(ii))/pixR*tan(theta2))+a;
                R=(sin(pi/2-a1)*sin(pi/2-a2)*B)/sin(a2-a1);
            else
                a1=atan((PL(ii)-(pixL))/(pixL)*tan(theta1));
                a2=atan((PR(ii)-pixR)/pixR*tan(theta2))-a;
                R=(sin(pi/2-a1)*sin(pi/2-a2)*B)/sin(a1-a2);    
            end
        RCalc=[RCalc,R];             
end

end