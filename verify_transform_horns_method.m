% paste the computed transform here. replay on a set of test images
% open all images and the T from kinematics

load('computed_transform.mat')

load('config_file.mat')

foldername = 'test_images/';

t_diag=0:0.1:2*pi;
radius = 5;


for counter = 1:n_stereo_pairs
    
    filenameImgL = strcat(foldername, int2str(counter), 'L.jpg');
    filenameImgR = strcat(foldername, int2str(counter), 'R.jpg');
    
    filenameImgT = strcat(foldername, int2str(counter), 'T.mat');
    load(filenameImgT);
    
    
    % P_robot = P_cam + Tf. we have P_robot and Tf
    % Tf(1:3) = Tf(1:3) + P_robot(1:3, counter) - P_cam(1:3, counter);

    P_robot = T(1:3, 4); % T is point from file
    
    P_cam(1:3) = R * P_robot(1:3) + t(1:3);
    P_cam(4) = 1;
    
    % now convert P_cam back into the L and R frame
    pixelL = cameraMatrixL * P_cam';
    pixelR = cameraMatrixR * P_cam';
    
    pixelL = pixelL ./ pixelL(3)
    pixelR = pixelR ./ pixelR(3)
    
    
    I = imread(filenameImgL);
    imshow(I);
    hold on;
    x = pixelL(1) + radius*sin(t_diag);
    y = pixelL(2) + radius*cos(t_diag);
    fill(x,y,'r');
    hold off;
    k = waitforbuttonpress;
    
    I = imread(filenameImgR);
    imshow(I);
    hold on;
    x = pixelR(1) + radius*sin(t_diag);
    y = pixelR(2) + radius*cos(t_diag);
    fill(x,y,'r');
    hold off;
    k = waitforbuttonpress;
    
    disp('One pair of images done');
    
end

% save all the 2D points

