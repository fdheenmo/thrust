n_stereo_pairs = 30;

cameraMatrixL = ...
[572.2248516229374, 0, 378.7735080718994 -35.44749952807783;
    0, 572.2248516229374, 239.291540145874, 0;
    0, 0, 1, 0];

cameraMatrixR = ...
[572.2248516229374, 0, 378.7735080718994, 0;
    0, 572.2248516229374, 239.291540145874, 0; 
    0, 0, 1, 0];

foldername = 'current_images/';

% for plotting
t_plot=0:0.1:2*pi;
r_plot = 5; % radius of the plotted circles



save('config_file.mat');

clc; close all;

