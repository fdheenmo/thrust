% This script opens the image files, shows them side by side and allows
% user to annotate pics

clc; clear variables; close all;

load('config_file.mat')

matchedPointsL = zeros(n_stereo_pairs,2);
matchedPointsR = zeros(n_stereo_pairs,2);

for counter = 1:n_stereo_pairs
    
    filenameImgL = strcat(currentFoldername, int2str(counter), '_L.jpg');
    
    I = imread(filenameImgL);
    imshow(I);
    [xl, yl] = ginput(1);
    matchedPointsL(counter, :) = [xl, yl];
    
    fprintf('One image annotated. %d images left\n', 2 * n_stereo_pairs-counter);
end

for counter = 1:n_stereo_pairs
    
    filenameImgR = strcat(currentFoldername, int2str(counter), '_R.jpg');
      
    I = imread(filenameImgR);
    imshow(I);
    [xr, yr] = ginput(1);
    matchedPointsR(counter, :) = [xr, yr];
    
    fprintf('One image annotated. %d images left\n', n_stereo_pairs-counter);
end


% save all the 2D points
saveFile = strcat(currentFoldername, 'matchedPoints.mat');
save(saveFile,'matchedPointsL', 'matchedPointsR');

fprintf('All matchedPoints saved!\n', n_stereo_pairs);
close all;