% paste the computed transform here. replay on a set of test images
% open all images and the T from kinematics
clc; clear all

Tf = [-0.0310812333748081;0.0417728684476922;0.0636546382443061;1];


Tf = [0.025013103324925536; -0.037918691033665575; -0.051348798036702024];

cameraMatrixL = ...
[572.2248516229374, 0, 378.7735080718994 -35.44749952807783;
    0, 572.2248516229374, 239.291540145874, 0;
    0, 0, 1, 0];

cameraMatrixR = ...
[572.2248516229374, 0, 378.7735080718994, 0;
    0, 572.2248516229374, 239.291540145874, 0; 
    0, 0, 1, 0];


foldername = 'test_images/';

n_images = 30;
t=0:0.1:2*pi;
radius = 5;


for counter = 1:n_images
    
    filenameImgL = strcat(foldername, int2str(counter), 'L.jpg');
    filenameImgR = strcat(foldername, int2str(counter), 'R.jpg');
    
    filenameImgT = strcat(foldername, int2str(counter), 'T.mat');
    load(filenameImgT);
    
    
    % P_robot = P_cam + Tf. we have P_robot and Tf
    % Tf(1:3) = Tf(1:3) + P_robot(1:3, counter) - P_cam(1:3, counter);

    P_robot = T(1:4, 4); % T is point from file
    
    P_cam(1:3) = P_robot(1:3)- Tf(1:3);
    P_cam(4) = 1;
    
    % now convert P_cam back into the L and R frame
    pixelL = cameraMatrixL * P_cam'
    pixelR = cameraMatrixR * P_cam'
    
    
    I = imread(filenameImgL);
    imshow(I);
    hold on;
    x = pixelL(1) + radius*sin(t);
    y = pixelL(2) + radius*cos(t);
    fill(x,y,'r');
    hold off;
    
    k = waitforbuttonpress;
    
    I = imread(filenameImgR);
    imshow(I);
    hold on;
    x = pixelR(1) + radius*sin(t);
    y = pixelR(2) + radius*cos(t);
    fill(x,y,'r');
    hold off;
    
    k = waitforbuttonpress;
    
    disp('One pair of images done');
    
end

% save all the 2D points

