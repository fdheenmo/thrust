% paste the computed transform here. replay on a set of test images
% open all images and the T from kinematics

load('computed_transform.mat')
load('config_file.mat')

matchedPointsFile = strcat(currentFoldername, 'matchedPoints.mat');
load(matchedPointsFile);

triangulatedPointsFile = strcat(currentFoldername,'triangulatedPoints.mat');
load(triangulatedPointsFile);

sum_error = 0;

showPlot = true;


for counter = 1:n_stereo_pairs
    
    filenameImgL = strcat(currentFoldername, int2str(counter), '_L.jpg');
    filenameImgR = strcat(currentFoldername, int2str(counter), '_R.jpg');
    
    filenameP = strcat(currentFoldername, int2str(counter), '_P.mat');
    load(filenameP);
    
    % this is the tool-axis
    P_tool_center = P(1:3, 4);
    
    tooltip_transform = eye(4);
    
    % change z access - m
    tooltip_transform(3,4) = tooltip_offset;
    
    transformed_point = tooltip_transform * P_tool_center';
    
    % this is the tool-tip
    P_robot(1:3) = transformed_point(1:3);

    
    % transform point from robot to camera frame
    P_cam(1:3) = R * P_robot(1:3) + t(1:3);
    P_cam(4) = 1;
    
    error = pdist2(triangulatedPoints(counter, :), P_cam(1:3));
    sum_error = sum_error + error;
    
    if showPlot
        % now convert P_cam back into the L and R frame
        pixelL = cameraMatrixL * P_cam';
        pixelR = cameraMatrixR * P_cam';
        
        pixelL = pixelL ./ pixelL(3);
        pixelR = pixelR ./ pixelR(3);
        
        
        I = imread(filenameImgL);
        imshow(I);
        hold on;
        % computed point
        x = pixelL(1) + r_plot*sin(t_plot);
        y = pixelL(2) + r_plot*cos(t_plot);
        fill(x,y,'y');
        
        P = matchedPointsL(counter, :);
        xl = P(1);
        yl = P(2);
        x = xl + r_plot*sin(t_plot);
        y = yl + r_plot*cos(t_plot);
        fill(x,y,'r');
        
        hold off;
        k = waitforbuttonpress;
        
        I = imread(filenameImgR);
        imshow(I);
        hold on;
        x = pixelR(1) + r_plot*sin(t_plot);
        y = pixelR(2) + r_plot*cos(t_plot);
        fill(x,y,'y');
        
        P = matchedPointsR(counter, :);
        xr = P(1);
        yr = P(2);
        x = xr + r_plot*sin(t_plot);
        y = yr + r_plot*cos(t_plot);
        fill(x,y,'r');
        
        hold off;
        k = waitforbuttonpress;
        
        disp('One pair of images done');
    end
    
end

mean_error = sum_error / n_stereo_pairs;
fprintf('Mean error = %d\n', mean_error);

