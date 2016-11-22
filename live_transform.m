% open video feed

clc; clear variables; close all;

load('config_file.mat')
load('computed_transform.mat')

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

    positionVector = [rosPosition.X rosPosition.Y rosPosition.Z];

    quaternion = [rosQuaternion.W rosQuaternion.X rosQuaternion.Y rosQuaternion.Z];    
    rotationMatrix = quat2rotm(quaternion);
        
    % generate 6d0f transform matrix
    P_tool_center = zeros(4,4);
    P_tool_center(1:3, 1:3) = rotationMatrix;
    P_tool_center(1:3, end) = positionVector;
    P_tool_center(4,4) = 1;
    
    tooltip_transform = eye(4);
    tooltip_transform(3,4) = tooltip_offset; % measured from center of the circle as 9mm
    % NOTE: above transform will change
    
    transformed_pose = P_tool_center * tooltip_transform;
    
    P_robot = transformed_pose(1:3,4);
    
    
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