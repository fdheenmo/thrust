clc; clear variables; close all;

n_stereo_pairs = 30;

% stereo parameters

cameraMatrixL = ...
[572.2248516229374, 0, 378.7735080718994 -35.44749952807783;
    0, 572.2248516229374, 239.291540145874, 0;
    0, 0, 1, 0];

cameraMatrixR = ...
[572.2248516229374, 0, 378.7735080718994, 0;
    0, 572.2248516229374, 239.291540145874, 0; 
    0, 0, 1, 0];

currentFoldername = 'current_images/';

% for plotting
t_plot=0:0.1:2*pi;
r_plot = 5; % radius of the plotted circles

% declare topic names and create subscribers
leftImageTopic = '/stereo/left/image_rect_color/compressed';
rightImageTopic = '/stereo/right/image_rect_color/compressed';
poseTopic = '/dvrk/PSM2/position_cartesian_current';

tooltip_offset = 0.0009; % measured from tooltip axis as 9mm

save('config_file.mat');

clc; clear variables; close all;

