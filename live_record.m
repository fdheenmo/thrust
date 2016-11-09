% This script will display the video stream and record the images and
% kinematic at a given time using mouse clicks

% rosrun image_view image_view image:=/stereo/left/image_rect_color


foldername = datestr(now, 'dd-mmm-HH-MM-SS');
mkdir(foldername);

% declare topic names and create subscribers
leftImageTopic = '/stereo/left/image_rect_color/compressed';
rightImageTopic = '/stereo/right/image_rect_color/compressed';
transformTopic = '/dvrk/PSM2/position_cartesian_current';

subL = rossubscriber(leftImageTopic);
subR = rossubscriber(rightImageTopic);
subT = rossubscriber(transformTopic);

n_images = 1;

for counter = 1:n_images
    
    
    k = waitforbuttonpress;
    
    % fetch images
    msgL = receive(subL);
    msgR = receive(subR);
    
    imgL = readImage(msgL);
    imgR = readImage(msgR);
    
    % fetch 4x4 transformation matrix
    msgT = receive(subT, 1); % second value is timeout
    
    % gen filesnames
    filenameL = strcat(foldername, '/', int2str(counter), 'L.jpg');
    filenameR = strcat(foldername, '/', int2str(counter), 'R.jpg');
    filenameT = strcat(foldername, '/', int2str(counter), 'T.mat');
    
    % save images
    imwrite(imgL, filenameL);
    imwrite(imgR, filenameR);
    
    % get PoseStamped message and extract deets
    rosPosition = msgT.Pose.Position;
    rosQuaternion = msgT.Pose.Orientation;
    
    quaternion = [rosQuaternion.W rosQuaternion.X rosQuaternion.Y rosQuaternion.Z];
    position = [rosPosition.X rosPosition.Y rosPosition.Z];
    
    rotm = quat2rotm(quaternion);
    
    % generate 6d0f transform matrix
    T = zeros(4,4);
    T(1:3, 1:3) = rotm;
    T(1:3, end) = position;
    T(4,4) = 1;
    
    
    % save transform matrix
    save(filenameT,'T');
    
    fprintf('image+transform saved. %d images left\n', n_images-counter);
        
end
fprintf('\n%d images saved!\n', n_images);
close all;