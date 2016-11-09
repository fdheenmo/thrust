% compute least squares

clc; clear all;

load('config_file.mat')

filename = strcat(foldername,'triangulatedPoints.mat');
load(filename);

P_cam = zeros(4, n_stereo_pairs);
P_cam(4,:) = 1;
P_robot = zeros(4, n_stereo_pairs);
P_robot(4,:) = 1;


for counter = 1:n_stereo_pairs
    
    filenameImgT = strcat(foldername, int2str(counter), 'T.mat');
    load(filenameImgT);
    
    P_cam(1:3, counter) = triangulatedPoints(counter, :);
    P_tool_center_robot = T(1:3, 4)';
    
    horizontal_Tf = eye(4);
    horizontal_Tf(1,4) = 0.009; % measured from center of the circle as 9mm
    % note above transform will change
    
    P_robot(1:3, counter) = horizontal_Tf * P_tool_center_robot;
    
    % TODO add transformation
end
% we have one 3D point, and one 6DOF point. FIGHT!

% set up an optimization problem with 9 variables.

save('optimization_dataset.mat', 'P_robot', 'P_cam');

%% Compute average for a starting point for optimization
Tf = zeros(4, 1);
Tf(4,:) = 1;
for counter = 1:n_stereo_pairs
    Tf(1:3) = Tf(1:3) + P_robot(1:3, counter) - P_cam(1:3, counter);
end
Tf(1:3, :) = Tf(1:3, :) ./ n_stereo_pairs;

%% calc error

e = error_function(P_robot, P_cam, Tf, n_stereo_pairs)