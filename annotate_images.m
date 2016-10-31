% This script opens the image files, shows them side by side and allows
% user to annotate pics

matchedPointsL = zeros(n_images,2);
matchedPointsR = zeros(n_images,2);

n_images = 9;
for counter = 1:n_images
    
    filenameImgL = strcat(int2str(counter), 'L.jpg');
    filenameImgR = strcat(int2str(counter), 'R.jpg');
    
    I = imread(filenameImgL);
    imshow(I);
    [xl, yl] = ginput(1);
    matchedPointsL(counter, :) = [xl, yl];
    
    
    I = imread(filenameImgR);
    imshow(I);
    [xr, yr] = ginput(1);
    matchedPointsR(counter, :) = [xr, yr];

    
    
    disp('One pair of images done');
    
    
end

% save all the 2D points
save('matchedPoints.mat','matchedPointsL', 'matchedPointsR');
