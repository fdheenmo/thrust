function e = error_function(Tf)
load dataset
Tf = [Tf;1];
% NOT HOMOGENOUS
replicatedTf = repmat(Tf, 1, n_images);

predicted_P_cam = P_robot + replicatedTf;

errorVec = P_cam - predicted_P_cam;
 
e = norm(errorVec(1:3, :));

end