% reads corresponding_points.at file and does stuff

saveFile = strcat(foldername, 'matchedPoints.mat');
load(saveFile)

% cameraMatrix1 - load from config file
load('config_file.mat')


%%

triangulatedPoints = triangulate(matchedPointsL,matchedPointsR,cameraMatrixL',cameraMatrixR');

save(strcat(foldername,'triangulatedPoints.mat'), 'triangulatedPoints');
