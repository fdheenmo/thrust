function e = error_function(Tf)

load('config_file.mat');
load('optimization_dataset.mat');
Tf = [Tf;1];

% NOT HOMOGENOUS
replicatedTf = repmat(Tf, 1, n_stereo_pairs);

predicted_P_cam = P_robot + replicatedTf;

errorVec = P_cam - predicted_P_cam;
 
e = norm(errorVec(1:3, :));

end