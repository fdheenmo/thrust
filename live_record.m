% This script will display the video stream and record the images and
% kinematic at a given time using mouse clicks

counter = 1;
while (1)
    
    
    k = waitforbuttonpress;

% declare topic names
    leftImageTopic = '';
    rightImageTopic = '';
    kinematicsTopic = '';
    
% fetch images 

imgL = readImage(msg);
imgR = readImage(msg);

% fetch 4x4 transformation matrix

%TODO store in a time stamped file

% save images and transform matrix
    filenameL = strcat(int2str(counter), 'L');
    filenameR = strcat(int2str(counter), 'R');
    filenameTf = strcat(int2str(counter), 'T.mat');


    imwrite(imgL, filenameL);
    imwrite(imgR, filenameR);
    save(filenameTf,'Tf');
    
    disp('image+transform saved');
    
% increment counter
    counter = counter + 1;
    
end