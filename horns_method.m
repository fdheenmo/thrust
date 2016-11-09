function [R,t] = horns_method(q,p)

%q=R*p+T
%q=nx3
%p=nx3
%R=3x3
%t=1x3

p_bar=mean(p);
q_bar=mean(q); 

% find data centroid and deviations from centroid

q_mark = bsxfun(@minus,q,q_bar);

% find data centroid and deviations from centroid
p_mark = bsxfun(@minus,p,p_bar);
% Apply weights

N = transpose(p_mark)*q_mark; % taking points of q in matched order

[U,~,V] = svd(N); % singular value decomposition

R = V*transpose(U);

t = q_bar' - R*p_bar';

end