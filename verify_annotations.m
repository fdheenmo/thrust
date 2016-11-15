% This script opens the image files, shows them side by side and allows
% user to annotate pics

clc; clear variables; close all;

load('config_file.mat')

saveFile = strcat(currentFoldername, 'matchedPoints.mat');
load(saveFile);

for counter = 1:n_stereo_pairs
    
    filenameImgL = strcat(currentFoldername, int2str(counter), '_L.jpg');
    filenameImgR = strcat(currentFoldername, int2str(counter), '_R.jpg');
    
    I = imread(filenameImgL);
    imshow(I);
    hold on;
    P = matchedPointsL(counter, :);
    xl = P(1);
    yl = P(2);
    
    %x_o and y_o = center of circle
    x = xl + r_plot*sin(t_plot);
    y = yl + r_plot*cos(t_plot);
    fill(x,y,'r');
    hold off;
    
    k = waitforbuttonpress;
    
    I = imread(filenameImgR);
    imshow(I);
    hold on;
    P = matchedPointsR(counter, :);
    xr = P(1);
    yr = P(2);
    x = xr + r_plot*sin(t_plot);
    y = yr + r_plot*cos(t_plot);
    fill(x,y,'r');
    hold off;   
    
    k = waitforbuttonpress;
    
    fprintf('One image pair verified. %d image pairs left\n', n_stereo_pairs-counter);
end

close all;