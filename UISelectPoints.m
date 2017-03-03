function UISelectPoints(handles)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
global I1 I2 Location2
J1=I1; J2=I2;
Num_Points=str2double(get(handles.edit1,'String'));
if round(Num_Points) ~= Num_Points
    disp('Number of points must be an integer.'); 
    return
end

if Num_Points==0
    Location2=[];
    close('SURF_GUI_refl')
else
    axes(handles.axes1) 
    for i=1:Num_Points        
        text(10,1,'Select features on the left reflector.',...
            'BackgroundColor',[1 1 1])
        K=impoint;
        J=getPosition(K);
        [SelectedPoint1] = ClosestPoint(J,handles.Strong1.Location);
        clear K J
        Location_Select(1,1,i)=SelectedPoint1(1);
        Location_Select(1,2,i)=SelectedPoint1(2);
        J1=insertMarker(J1,Location_Select(1,:,i));
    end
    axes(handles.axes2) 
    for i=1:Num_Points
        text(10,1,'Select the same features on the right reflector.',...
            'BackgroundColor',[1 1 1])
        K=impoint;
        J=getPosition(K);
        [SelectedPoint2] = ClosestPoint(J,handles.Strong2.Location);
        clear K J  
        Location_Select(2,1,i)=SelectedPoint2(1); 
        Location_Select(2,2,i)=SelectedPoint2(2); %#ok<*AGROW>
        J2=insertMarker(J2,Location_Select(2,:,i)); 
    end   
    axes(handles.axes1)
    imshow(J1)
    axes(handles.axes2)
    imshow(J2)  
    pause(1)
    Location2=sum(Location_Select,3)/Num_Points;
    J1=insertMarker(I1,Location2(1,:));
    J2=insertMarker(I2,Location2(2,:)); 
    axes(handles.axes1)
    imshow(J1)
    axes(handles.axes2)
    imshow(J2)  
    pause(1)
    close('SURF_GUI_refl')
end



end

