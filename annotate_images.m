% This script opens the image files, shows them side by side and allows
% user to annotate pics
load('config_file.mat')


matchedPointsL = zeros(n_stereo_pairs,2);
matchedPointsR = zeros(n_stereo_pairs,2);

foldername = 'current_images/';


for counter = 1:n_stereo_pairs
    
    filenameImgL = strcat(foldername, int2str(counter), 'L.jpg');
    filenameImgR = strcat(foldername, int2str(counter), 'R.jpg');
    
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
saveFile = strcat(foldername, 'matchedPoints.mat');
save(saveFile,'matchedPointsL', 'matchedPointsR');
