function SURF_Method_Refl(IGrayL,IGrayR)
%UNTITLED41 Summary of this function goes here
%   Detailed explanation goes here
global I1 I2
I1=IGrayL;
I2=IGrayR;
waitfor(SURF_GUI_refl)
%% Original Code
% function [Location,J1,J2] = SURF_Method_Refl(IGrayL,IGrayR)
% blobs1 = detectSURFFeatures(IGrayL, 'MetricThreshold', 2000);
% blobs2 = detectSURFFeatures(IGrayR, 'MetricThreshold', 2000);
% Strong1=blobs1.selectStrongest(10);
% Strong2=blobs2.selectStrongest(10);
% 
% J1=insertMarker(IGrayL,Strong1.Location);
% J2=insertMarker(IGrayR,Strong2.Location);
% fig=figure();
% imshowpair(J1,J2,'montage');
% set(fig,'Units', 'normalized', 'OuterPosition', [0,0,1,1]);

% ConfirmPoints=menu('Are there matching points for the reflector?','Yes','No');
% switch ConfirmPoints
%     case 1
%         text(10,1,'Select a pixel on the left reflector. Hit enter when ready to process.',...
%             'BackgroundColor',[1 1 1])
%         K=impoint;
%         pause()
%         J=getPosition(K);
%         [SelectedPoint1] = ClosestPoint(J,Strong1.Location);
%         clear K J
% 
%         text(size(IGrayL,2)+10,1,'Select the same pixel on the right reflector. Hit enter when ready to process.',...
%             'BackgroundColor',[1 1 1])
%         K=impoint;
%         pause()
%         J=getPosition(K);
%         J(1)=J(1)-size(IGrayL,2);
%         [SelectedPoint2] = ClosestPoint(J,Strong2.Location);
%         clear K J1 J2
%         fig=figure();
%         J1=insertMarker(IGrayL,SelectedPoint1);
%         J2=insertMarker(IGrayR,SelectedPoint2); 
%         Location(1,1)=SelectedPoint1(1);
%         Location(2,1)=SelectedPoint2(1);
%         Location(1,2)=SelectedPoint1(2);
%         Location(2,2)=SelectedPoint2(2);
%     otherwise
%         Location=[];
%         J1=IGrayL;
%         J2=IGrayR;
% end
% end
end

