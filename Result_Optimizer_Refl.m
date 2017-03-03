function [Avg_Location] = Result_Optimizer_Refl(Segement,SURF,Template,...
    Difference,handles)
%Segement and SURF return the most accurate results so their outputs will
%be weighted higher than the Template and Differencing methods.

%Check each method for results

if isempty(Segement) || ~get(handles.Color_Seg,'Value')
    A=0;
    Segement=[0,0;0,0];
    warning('Method:NoResults','Segment did not return results') %#ok<*CTPCT>
else
    A=10;
end
if isempty(SURF) || ~get(handles.SURF,'Value')
    B=0;
    SURF=[0,0;0,0];
    warning('Method:NoResults','SURf did not return results')
else
    B=10;
end
if isempty(Template) || ~get(handles.Template,'Value')
    C=0;
    Template=[0,0;0,0];
    warning('Method:NoResults','Template Match did not return results')
else
    C=1;
end
if isempty(Difference) || ~get(handles.Difference,'Value')
    D=0;
    Difference=[0,0;0,0];
else
    D=1;
end


Total=A+B+C+D;

Avg_Location=(A*Segement+B*SURF+C*Template+D*Difference)/Total;


end

