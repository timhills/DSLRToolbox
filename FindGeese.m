function stats = FindGeese(IM,imageName)
% Phase Congruency is used to find edges within an image. Then the image is
% processed to remove noise and obvious objects that are not Geese.

IM_Original=IM;
IM=IM(:,:,3);
[IM] = phasecongmono(IM);

%Increase brightness of image
IM = 10*IM; 

%Remove noise
IM = medfilt2(IM);

%Increase brightness of image again 
IM = 10*IM;

%Threshold image (0.4 seems to return good results for most images)
BW = im2bw(IM,0.3); 
clear IM

%The binary gradient mask shows lines of high contrast in the image. 
%These lines do not quite delineate the outline of the object of 
%interest. Compared to the original image, you can see gaps in the 
%lines surrounding the object in the gradient mask. These linear gaps 
%will disappear if the Sobel image is dilated using linear structuring 
%elements, which we can create with the strel function.
se90 = strel('line', 14, 90);
se0 = strel('line', 14, 0);
BW = imdilate(BW, [se90 se0]);

%Fill holes within image
BW = imfill(BW,'holes');

%Remove objects on the border of the image
BW = imclearborder(BW, 4);

%Erode image back to original once holes are filled
BW = imerode(BW, [se90 se0]);  

%Remove objects outside of specified area range
BW = bwareafilt(BW,[300,100000]); % was [300,10000]

%Find the centriod and bounding box of each object 
stats = regionprops(BW, 'BoundingBox', 'Centroid', ...
    'Area', 'Perimeter');
if ~isempty(stats)
    if size(stats,1)~=1
        A = zeros(1,size(stats,1));
        for i=1:size(stats,1)
            A(i)=stats(i).Area;
        end
        Amean=mean(A);
        Astd=std(A);
        Double=A(A>Amean+1.2*Astd);
        se90 = strel('line', 2, 90);
        se0 = strel('line', 2, 0);
        if ~isempty(Double)
            for j=1:length(Double)
                Index(j)=find(A==Double(j));
            end
            for i=1:length(Index) %was i for some reason...
                BB=floor(stats(Index(i)).BoundingBox);
                BW2 = imcrop(BW,BB);
                N=1;
                while N==1
                    BW2 = imerode(BW2, [se90 se0]);
                    BW2 = bwareafilt(BW2,[300,10000]);                    
                    stats2 = regionprops(BW2,'Area');
                    N=size(stats2,1);
                end
                BW(BB(2):(BB(2)+BB(4)),BB(1):(BB(1)+BB(3)))=BW2;
                clear stats
                stats = regionprops(BW, 'BoundingBox', 'Centroid', ...
                    'Area', 'Perimeter');
            end
        end
    end
clear se90 se0 Amean Astd
clear BW
clear A
    if size(stats,1)~=1
        for i=1:size(stats,1)
            P(i)=stats(i).Perimeter;
            L(i)=stats(i).BoundingBox(3);
            H(i)=stats(i).BoundingBox(4);
            A(i)=stats(i).Area;
        end
        Asp=L./H;
        %Shapefactor is a unitless variable for comparison
%         SF=P.^2.*L./(A.*H);
%         filename='Z:\Researchers\Corbin\Old\ImageProcessing\ShapeFactor';
%         fileID=fopen([filename,'\sf.txt'],'a');
%         fprintf(fileID,'\nImage: %s',imageName);
%         fprintf(fileID,'\n   Goose      ASP    Perimeter      Area      Length     Height  \n');
%         for i=1:length(P)
%             fprintf(fileID,'  %5.0f\t%8.2f\t%8.2f\t%8.2f\t%8.2f\t%8.2f\n',i,Asp(i),...
%                 P(i),A(i),L(i),H(i));
%         end
%         fclose(fileID);
        % Create image with SF results to build up stats for better detection
%         J=IM_Original;
%         if ~isempty(stats)
%             for i=1:length(stats)
%                 Box(1,:)=stats(i).BoundingBox;
%                 J=insertObjectAnnotation(J,'Rectangle',...
%                     Box,['AR:',num2str(round(Asp(i)*10)/10),' ',...
%                     'A:',num2str(round(A(i))),' ',...
%                     'P:',num2str(round(P(i))),' '],'FontSize',22);
%             end
%             imwrite(J,[filename,'\',imageName],'jpg')
%         end
        %Remove objects that don't fit within the boundaries
    %     [Index]=find(SF>75 | SF<160 & SF>175);
    %     [Index]=find(SF>75 & SF<160 | SF>175 & SF<200 | SF>400);
        
        IndArea=find(A<1.4779e+03 | A>5.0729e+04); %was A>1.0729
        IndPerim=find(P<247 | P>2400); %was P>1272
        IndAspect=find(Asp<0.6429 | Asp>5.7143);
        newArea=A;
        newArea(IndArea)=0;
        newPerim=P;
        newPerim(IndPerim)=0;
        newAspect=Asp;
        newAspect(IndAspect)=0;
        Matrix=[newArea',newPerim',newAspect'];
        [Index,~]=find(Matrix==0); 
        Index=unique(Index);
        if ~isempty(stats)   
            for i=length(Index):-1:1            
                stats(Index(i))=[];
            end
        end
    end
end

end

