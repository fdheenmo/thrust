% reads corresponding_points.at file and does stuff

foldername = 'current_images/';
saveFile = strcat(foldername, 'matchedPoints.mat');
load(saveFile)

% cameraMatrix1 - camera projection matrix?

cameraMatrixl = ...
[572.2248516229374, 0, 378.7735080718994 -35.44749952807783;
    0, 572.2248516229374, 239.291540145874, 0;
    0, 0, 1, 0];

cameraMatrixr = ...
[572.2248516229374, 0, 378.7735080718994, 0;
    0, 572.2248516229374, 239.291540145874, 0; 
    0, 0, 1, 0];

%%

triangulatedPoints = triangulate(matchedPointsL,matchedPointsR,cameraMatrixl',cameraMatrixr');

save(strcat(foldername,'triangulatedPoints.mat'), 'triangulatedPoints');
