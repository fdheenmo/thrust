% compute least squares
foldername = 'current_images/';
filename = strcat(foldername,'triangulatedPoints.mat');
load(filename);

n_images = 5;

cameraMatrixL = ...
[572.2248516229374, 0, 378.7735080718994 -35.44749952807783;
    0, 572.2248516229374, 239.291540145874, 0;
    0, 0, 1, 0];

cameraMatrixR = ...
[572.2248516229374, 0, 378.7735080718994, 0;
    0, 572.2248516229374, 239.291540145874, 0; 
    0, 0, 1, 0];


radius = 5;

for counter = 1:n_images
    
    filenameImgL = strcat(foldername, int2str(counter), 'L.jpg');
    filenameImgR = strcat(foldername, int2str(counter), 'R.jpg');
    
    P_cam(1:3) = triangulatedPoints(counter, :);
    P_cam(4) = 1;
    
    % now convert P_cam back into the L and R frame
    pixelL = cameraMatrixL * P_cam;
    pixelR = cameraMatrixR * P_cam;
    
    pixelL = pixelL ./ pixelL(3);
    pixelR = pixelR ./ pixelR(3);

    I = imread(filenameImgL);
    imshow(I);
    hold on;
    xl = pixelL(1);
    yl = pixelL(2);
    
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
    
    xr = pixelR(1);
    yr = pixelR(2);
    x = xr + radius*sin(t);
    y = yr + radius*cos(t);
    fill(x,y,'r');
    hold off;
    
    
    
    k = waitforbuttonpress;
    
    
    disp('One pair of images done');
    
    
end

% save all the 2D points

