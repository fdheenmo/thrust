% compute least squares

clc; clear variables; close all;

load('config_file.mat')

filename = strcat(currentFoldername,'triangulatedPoints.mat');
load(filename);

P_cam = zeros(n_stereo_pairs, 3);
P_robot = zeros(n_stereo_pairs, 3);

for counter = 1:n_stereo_pairs
    
    filenameP = strcat(currentFoldername, int2str(counter), '_P.mat');
    load(filenameP);
    
    P_cam(counter,:) = triangulatedPoints(counter, :);
       
    tooltip_transform = eye(4);
    
    % change z access - m
    tooltip_transform(3,4) = tooltip_offset; % measured from center of the circle as 9mm
    
    transformed_point = P * tooltip_transform;
    
    % this is the tool-tip
    P_robot(counter, 1:3) = transformed_point(1:3, 4);
    
end

% use horns method to compute 3d transform
[R,t] = horns_method(P_cam,P_robot);

save('computed_transform.mat', 'R', 't');

clc; clear all; close all;

disp('Transformed computed and saved');

