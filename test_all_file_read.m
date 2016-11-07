% This script opens the image files, shows them side by side and allows
% user to annotate pics
n_images = 30;


matchedPointsL = zeros(n_images,2);
matchedPointsR = zeros(n_images,2);

foldername = 'current_images/';
saveFile = strcat(foldername, 'matchedPoints.mat');
load(saveFile);

radius = 5;

for counter = 1:n_images
    
    filenameImgL = strcat(foldername, int2str(counter), 'L.jpg');
    filenameImgR = strcat(foldername, int2str(counter), 'R.jpg');
    
    
    I = imread(filenameImgL);
    imshow(I);
    hold on;
    P = matchedPointsL(counter, :);
    xl = P(1);
    yl = P(2);
    
    t=0:0.1:2*pi;
    %x_o and y_o = center of circle
    x = xl + radius*sin(t);
    y = yl + radius*cos(t);
    fill(x,y,'r');
    hold off;
    
    k = waitforbuttonpress;
    
    I = imread(filenameImgR);
    imshow(I);
    hold on;
    P = matchedPointsR(counter, :);
    xr = P(1);
    yr = P(2);
    x = xr + radius*sin(t);
    y = yr + radius*cos(t);
    fill(x,y,'r');
    hold off;
    
    
    
    k = waitforbuttonpress;
    
    
    disp('One pair of images done');
    
    
end

% save all the 2D points

