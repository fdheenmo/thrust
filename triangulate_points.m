% reads corresponding_points.at file and does stuff

clc; clear variables; close all;

load('config_file.mat')

saveFile = strcat(currentFoldername, 'matchedPoints.mat');
load(saveFile)

triangulatedPoints = triangulate(matchedPointsL,matchedPointsR,cameraMatrixL',cameraMatrixR');

% use params from matlab
% triangulatedPoints = triangulate(matchedPointsL,matchedPointsR, stereoParams);

save(strcat(currentFoldername,'triangulatedPoints.mat'), 'triangulatedPoints');

disp('Annotated points have been triangulated');
