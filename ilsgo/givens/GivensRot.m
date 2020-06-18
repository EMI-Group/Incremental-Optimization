function [ RM ] = GivensRot(N)
% N: rotation matrix size
% K: number of rotated planes 

% initialization
all_IJ = nchoosek(1:N,2); K = size(all_IJ,1); % all combinations of planes (i and j) 
full_list = randperm(size(all_IJ,1)); 
IJ = all_IJ(full_list(1:K),:); % selected planes
RV = rand(K, 2); % rotation vectors

% generate rotation matrix RM
E = eye(N);
RM = E;
for k = 1:K % RM is rotated K times
    i = IJ(k,1); j = IJ(k,2);
    I_mat = [N*(i - 1) + i, N*(j - 1) + i, N*(i - 1) + j, N*(j - 1) + j]; % indices of the elements to be rotated
    R_mat = planerot(RV(k,:)')'; R_mat = R_mat(:); % rotation values of each element
    RM_k = E; RM_k(I_mat) = R_mat;
    RM = RM_k*RM;
end

