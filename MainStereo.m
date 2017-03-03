
cell_list = {};

fig_number = 1;

title_figure = 'Dynamic Stereoscopic Long Range -- Toolbox';

warning('off','images:initSize:adjustingMag')
warning('off','vision:calibrate:boardShouldBeAsymmetric')
warning('off','Method:NoResults')

cell_list{1,1} = {'Extract Checkerboard','Detect_Checker_GUI;'};
cell_list{2,1} = {'Extract Geese','Detect_Geese_GUI'};
cell_list{3,1} = {'Extract Reflectors','Detect_Reflector_GUI;'};
cell_list{1,2} = {'Calibrate','ext_calib;'};
cell_list{2,2} = {'Calculate Position','reproject_calib;'};
cell_list{3,2} = {'Calculate Velocity','analyse_error;'};
cell_list{1,3} = {'Calculate Focal Length','FocalLengthCalc;'};
cell_list{2,3} = {'Save','loading_calib;'};
cell_list{3,3} = {'Exit',...
    ['clc; disp(''Bye. To run again, type and enter MainStereo.''); close(' num2str(fig_number) '); clear;']};



show_window(cell_list,fig_number,title_figure,130,18,0,'clean',12);

