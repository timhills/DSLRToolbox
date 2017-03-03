classdef Image
    %UNTITLED14 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Name        
        Original
        Cropped
        Crop_Location
    end
    
    methods
        function EObj = Image(Input_Image)
            if nargin>0
                if ischar(Input_Image)
                    EObj.Original=imread(Input_Image);
                    EObj.Name=Input_Image;
                else
                    EObj.Original=Input_Image;
                    EObj.Name='NA';
                end
            end
        end
        function EObj = Crop(EObj)
            if nargin>0
                %Allow the user to select a ROI to improve results
                imshow(EObj.Original)
                %Rectangle ROI selected by the user
                h=imrect; 
                %Hold the ROI until the interior is double clicked with the mouse.
                wait(h); 
                %The position of the rectangle to be used for all images.
                EObj.Crop_Location=floor(getPosition(h)); 
                EObj.Cropped=imcrop(EObj.Original,[EObj.Crop_Location(1)...
                    EObj.Crop_Location(2) EObj.Crop_Location(3)...
                    EObj.Crop_Location(4)]);
            end
        end
    end
    
end

