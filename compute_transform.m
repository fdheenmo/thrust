% compute least squares

clc; clear all;

load('config_file.mat')

filename = strcat(foldername,'triangulatedPoints.mat');
load(filename);

P_cam = zeros(n_stereo_pairs, 3);
P_robot = zeros(n_stereo_pairs, 3);

for counter = 1:n_stereo_pairs
    
    filenameImgT = strcat(foldername, int2str(counter), 'T.mat');
    load(filenameImgT);
    
    P_cam(counter,:) = triangulatedPoints(counter, :);
    
    P_tool_center_robot = T(1:3, 4)'; % take only last column - xyz
    P_tool_center_robot(4) = 1; % make it homogenous
    
    horizontal_Tf = eye(4);
    horizontal_Tf(3,4) = 0.009; % measured from center of the circle as 9mm
    % NOTE: above transform will change
    
    transformed_point = horizontal_Tf * P_tool_center_robot';
    
    P_robot(counter, 1:3) = transformed_point(1:3);
    
    % TODO add transformation
end

% use horns method to compute 3d transform
[R,t] = horns_method(P_cam,P_robot);

save('computed_transform.mat', 'R', 't')
disp('Transformed computed and saved');

clc; clear all; close all;
