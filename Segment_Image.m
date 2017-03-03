function [segmented_images] = Segment_Image(Icrop,color_markers,nColors)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

%RGB image into an L*a*b* image
cform=makecform('srgb2lab');
lab=applycform(Icrop,cform);

a = lab(:,:,2);
b = lab(:,:,3);

color_labels = 1:nColors;

a = double(a);
b = double(b);
distance = zeros([size(a), nColors]);

for count = 1:nColors
  distance(:,:,count) = ( (a - color_markers(count,1)).^2 + ...
                      (b - color_markers(count,2)).^2 ).^0.5;
end

[~, label] = min(distance,[],3);
label = color_labels(label);
clear distance;

rgb_label = repmat(label,[1 1 3]);
segmented_images = repmat(uint8(0),[size(Icrop), nColors]);

for count = 1:nColors
  color = Icrop;
  color(rgb_label ~= color_labels(count)) = 0;
  segmented_images(:,:,:,count) = color;
end

end

