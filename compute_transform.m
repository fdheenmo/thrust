% compute least squares

clc; clear all


foldername = 'current_images/';
filename = strcat(foldername,'triangulatedPoints.mat');
load(filename);

n_images = 30;

P_cam = zeros(4, n_images);
P_cam(4,:) = 1;
P_robot = zeros(4, n_images);
P_robot(4,:) = 1;


for counter = 1:n_images
    
    filenameImgT = strcat(foldername, int2str(counter), 'T.mat');
    load(filenameImgT);
    
    P_cam(1:3, counter) = triangulatedPoints(counter, :);
    P_robot(1:3, counter) = T(1:3, 4)';
end
% we have one 3D point, and one 6DOF point. FIGHT!

% set up an optimization problem with 9 variables.

%%
Tf = zeros(4, 1);
Tf(4,:) = 1;
for counter = 1:n_images
    Tf(1:3) = Tf(1:3) + P_robot(1:3, counter) - P_cam(1:3, counter);
end
Tf(1:3, :) = Tf(1:3, :) ./ n_images;

%% calc error