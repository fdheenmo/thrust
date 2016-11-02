% compute least squares

foldername = 'current_images/';
filename = strcat(foldername,'triangulatedPoints.mat');
load(filename);

n_images = 30;

for counter = 1:n_images
    
    filenameImgT = strcat(foldername, int2str(counter), 'T.mat');
    load(filenameImgT);
    
    cam_3d = triangulatedPoints(counter, :);
    robot_3d = T(1:3, 4)';
    
    tf_3d = cam_3d - robot_3d;
 
end
% we have one 3D point, and one 6DOF point. FIGHT!

% set up an optimization problem with 9 variables.