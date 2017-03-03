function [a,z] = Calibration(PL,PR,PLY,Range,PixL,PixR,PixY,theta1,theta2,X,FL,System)


c=linspace(-0.01,0.01,10000);
for i=1:10000
    z=ZCalc(PL,PR,c(i),X,theta1,theta2,PixL,PixR);
    err(i)=abs(Range-z)./Range*100;
end
[~,Index]=min(err);
a=c(Index);

% %Range is in feet beacuse of the seperation distance in feet
% a=0.008;    %Initial Guess of Correction Angle
% iter=0;
% step=0.001;%0.000001;
% err=5;
% n=1;
% m=1;
% p=1;
% Tol=Range/300;      %The tolerance is set as a function of range because 
%                     %closer calibrations have less error so to achieve
%                     %similar corrections angles at all distances the
%                     %tolerance shall be a function of Range. 300 is an
%                     %arbitrary number choosen because it gave good results.
% while err>Tol
%     clear Rcalc
%     iter=iter+1;
% 
%     z=ZCalc(PL,PR,a,X,theta1,theta2,PixL,PixR);   
% %     y=YCalc(z,PLY-pixY,FL,System);
% %     x=XCalc(z,PL-pix,FL,System); 
% %     R=sqrt(x.^2+y.^2+z.^2);
% 
%     errold=err;
%     err=abs(Range-z)./Range*100;
%     if iter>100000
%         warning('Maximum number of iterations was reached.')
%         fprintf('The final percent error was %.4f%%.\n',err(1))
%         break
%     end
%     if err>errold && n<=2
%         a=a+step;
%         n=n+1;
%         m=1;
%         p=0;
%     elseif err>errold && m<=2
%         a=a-step;
%         n=1;
%         m=m+1;
%         p=1;        
%     elseif err<errold && p==0
%         a=a+step;
%         n=1;
%         m=1;
%         p=0;        
%     else
%         a=a-step;
%         n=1;
%         m=1;
%         p=1;        
%     end
%     if iter>10000
%         step=0.00001;
%     end
% end
%     y=YCalc(z,PLY-PixY,FL,System);
%     x=XCalc(z,PL-PixL,FL,System); 
%     R=sqrt(x.^2+y.^2+z.^2);
end