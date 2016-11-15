% open video feed

% draw circles every often

load('config_file.mat')
load('computed_transform.mat')

% declare topic names and create subscribers
leftImageTopic = '/stereo/left/image_rect_color/compressed';
rightImageTopic = '/stereo/right/image_rect_color/compressed';
poseTopic = '/dvrk/PSM2/position_cartesian_current';

subL = rossubscriber(leftImageTopic);
subR = rossubscriber(rightImageTopic);
subP = rossubscriber(poseTopic);

while 1
    
    
    % fetch images
    msgL = receive(subL, 1);
    msgR = receive(subR, 1);
    
    % fetch 4x4 transformation matrix
    msgP = receive(subP, 1); % second value is timeout
    
    imgL = readImage(msgL);
    imgR = readImage(msgR);
    
    % get PoseStamped message and extract deets
    rosPosition = msgP.Pose.Position;
    rosQuaternion = msgP.Pose.Orientation;
    
    quaternion = [rosQuaternion.W rosQuaternion.X rosQuaternion.Y rosQuaternion.Z];
    position = [rosPosition.X rosPosition.Y rosPosition.Z];
    
    rotm = quat2rotm(quaternion);
    
    % generate 3d0f position vector
    P_robot = zeros(4,1);
    P_robot(4,1) = 1;
    
    P_robot(1:3, 1) = position;
    
    % transform point
    P_cam(1:3) = R * P_robot(1:3) + t(1:3);
    P_cam(4) = 1;
    
    % now convert P_cam back into the L and R frame
    pixelL = cameraMatrixL * P_cam';
    pixelR = cameraMatrixR * P_cam';
    
    pixelL = pixelL ./ pixelL(3);
    pixelR = pixelR ./ pixelR(3);
    
%     subplot(1, 2, 1);
    figure(1);
    imshow(imgL);
    hold on;
    x = pixelL(1) + r_plot*sin(t_plot);
    y = pixelL(2) + r_plot*cos(t_plot);
    fill(x,y,'y');
    hold off;
    
%     subplot(1, 2, 2);
    figure(2);
    imshow(imgR);
    hold on;
    x = pixelR(1) + r_plot*sin(t_plot);
    y = pixelR(2) + r_plot*cos(t_plot);
    fill(x,y,'y');    
    hold off;
    
end