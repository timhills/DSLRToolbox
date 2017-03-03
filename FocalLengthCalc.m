function [FocalDiff,FocalLeft,FocalRight,Error,RangeFinal] = FocalLengthCalc
load('Stereo_Data.mat')
load('Calib_Results')
a=Calib.CorrectionAngle;
for i=1:length(Calib.Image.Num) 
    PLY(i)=mean(Calib.Image.Left(i).CheckerPoints(:,2));
end
A = RollCalc(PLY,a);
clear PLY
for iii=1:length(Images.Num)
    for k=1:size(Images.Locations{iii}.Refl,3)
        PL(k)=Images.Locations{iii}.Refl(1,1,k); %#ok<*AGROW>
        PLY(k)=Images.Locations{iii}.Refl(1,2,k);
        PR(k)=Images.Locations{iii}.Refl(2,1,k);
        R(k)=Images.Ranges{iii}.Refl(k);
    end
    EXIF_Data=imfinfo(char(strcat(cellstr(Images.Left(1).Name),'.JPG')));
    System=EXIF_Data.Model;
    switch System
        case 'NIKON D7000'
            pix=4928/2;         %Number of pixels in horizontal divided by two
            pixY=3264/2;
            X=10/12;            %Seperation distance [ft]
            H=23.6/2;           %Half dimension of image [mm]
        case 'NIKON D7100'
            pix=6000/2;         %Number of pixels in horizontal divided by two
            pixY=4000/2;
            X=15/12;            %Seperation distance [ft]
            H=23.5/2;           %Half dimension of image [mm]
    end
    FocalLength=EXIF_Data.DigitalCamera.FocalLength;
    switch FocalLength
        case 50
            w=0.0266; %0.050788;
            FL=54.5; %51.5;  
            FR=FL+w;
        case 105
            w=-0.0273;
            FL=104.55;  
            FR=FL+w; 
        case 200
            w=1.575;
            FL=200.5;
            FR=FL+w;
        case 300
            w=-0.75;
            FL=300;
            FR=FL+w;
    end
    clear FocalLength


    step=0.0001;
    step2=0.1;
    err=100*ones(size(PL,1),size(PL,2));
    errold2=100;
    q=1;
    r=1;
    s=1;
    iter2=0;
    while max(max(err))>5
        n=1;
        m=1;
        p=1;
        iter=0;
        while max(max(err))>5
            clear Rcalc theta1 theta2
            theta1=atan(H/FL);    %Half angle of view [Radians]
            theta2=atan(H/FR);
            iter=iter+1;
            z=zeros(size(PL));
            x=zeros(size(PL));
            for i=1:size(PL,2)
                clear a
                a=A(2)+A(1)*PLY(i);
                z(i)=RangeCalc(PL(i),PR(i),a,X,theta1,pix,theta2);
                y(i)=YCalc(z(i),PLY(1)-pixY,FL,System);
                x(i)=XCalc(z(i),PL(i)-pix,FL,System);
            end
            Rcalc=sqrt(z.^2+y.^2+x.^2);
            errold=err;
            err=abs(R-Rcalc);
            if iter>1000
    %             warning('Maximum number of iterations reached.')
    %             fprintf('The final max error was %.2ffeet.\n',max(max(err)))
                break
            end
            if max(max(err))>max(max(errold)) && n<=2
                w=w+step;
                n=n+1;
                m=1;
                p=0;
            elseif max(max(err))>max(max(errold)) && m<=2
                w=w-step;
                n=1;
                m=m+1;
                p=1;        
            elseif max(max(err))<max(max(errold)) && p==0
                w=w+step;
                n=1;
                m=1;
                p=0;        
            else
                w=w-step;
                n=1;
                m=1;
                p=1;        
            end
            FR=FL+w;
        end
            if max(max(err))>max(max(errold2)) && q<=2
                FL=FL+step2;
                q=n+1;
                r=1;
                s=0;
            elseif max(max(err))>max(max(errold2)) && r<=2
                FL=FL-step2;
                q=1;
                r=m+1;
                s=1;        
            elseif max(max(err))<max(max(errold2)) && s==0
                FL=FL+step2;
                q=1;
                r=1;
                s=0;        
            else
                FL=FL-step2;
                q=1;
                r=1;
                s=1;        
            end
            errold2=err;
                if iter2>30
    %             warning('Maximum number of iterations reached.')
    %             fprintf('The final max error was %.2ffeet.\n',max(max(err)))
                break
                end
            iter2=iter2+1;
    end
    FocalDiff(iii)=w;
    FocalRight(iii)=FR;
    FocalLeft(iii)=FL;
    RangeFinal(iii,:)=Rcalc;
    Error(iii,:)=err;
end
FocalLength.Diff=FocalDiff;
FocalLength.Left=FocalLeft;
FocalLength.Right=FocalRight;
FocalLength.Range=RangeFinal;
FocalLength.Error=Error;
save('FocalLengthResults','FocalLength')
end