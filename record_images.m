% This script will display the video stream and record the images and
% kinematic at a given time using mouse clicks

clc; clear variables; close all;

load('config_file.mat')
load audio % audio.mat for sound

recordFoldername = datestr(now, 'dd-mmm-HH-MM-SS');
mkdir(recordFoldername);

subL = rossubscriber(leftImageTopic);
subR = rossubscriber(rightImageTopic);
subP = rossubscriber(poseTopic);

for counter = 1:n_stereo_pairs
    
    
    k = waitforbuttonpress;
    
    % fetch images
    msgL = receive(subL);
    msgR = receive(subR);
    
    % fetch 4x4 pose matrix
    msgT = receive(subP, 1); % second value is timeout
    
    imgL = readImage(msgL);
    imgR = readImage(msgR);
        
    % gen filesnames
    filenameL = strcat(recordFoldername, '/', int2str(counter), '_L.jpg');
    filenameR = strcat(recordFoldername, '/', int2str(counter), '_R.jpg');
    filenameP = strcat(recordFoldername, '/', int2str(counter), '_P.mat');
    
    % save images
    imwrite(imgL, filenameL);
    imwrite(imgR, filenameR);
    
    % get PoseStamped message and extract deets
    rosPosition = msgT.Pose.Position;
    rosQuaternion = msgT.Pose.Orientation;
    
    quaternion = [rosQuaternion.W rosQuaternion.X rosQuaternion.Y rosQuaternion.Z];
    positionVector = [rosPosition.X rosPosition.Y rosPosition.Z];
    
    rotationMatrix = quat2rotm(quaternion);
    
    % generate 6d0f transform matrix
    P = zeros(4,4);
    P(1:3, 1:3) = rotationMatrix;
    P(1:3, end) = positionVector;
    P(4,4) = 1;
        
    % save pose matrix of tooltip origin
    save(filenameP,'P');
    
    fprintf('image+transform saved. %d image pairs left\n', n_stereo_pairs-counter);
    play(Audio)
end

fprintf('\n%d images saved!\n', n_stereo_pairs);
play(EndAudio)

close all;