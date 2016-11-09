% reads corresponding_points.at file and does stuff

load('config_file.mat')


saveFile = strcat(foldername, 'matchedPoints.mat');
load(saveFile)

% cameraMatrix1 - load from config file


%%
% use ROS parame
triangulatedPoints = triangulate(matchedPointsL,matchedPointsR,cameraMatrixL',cameraMatrixR');

% use params from matlab
% triangulatedPoints = triangulate(matchedPointsL,matchedPointsR, stereoParams);


save(strcat(foldername,'triangulatedPoints.mat'), 'triangulatedPoints');
