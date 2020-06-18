function [ RM ] = IncreGivensRot2(R, inc_size, overlap_rate)
% N: rotation matrix size
% inc_size: incremental size
% overlap_rate: 0 - 1 of inc_size

% initialization
N = size(R, 1) + inc_size;
all_IJ = nchoosek(1:N,2); % all combinations of planes (i and j) 
%overlap_rate = 0.5;
%RM = GivensRot(inc_size);
RM = R;


%for n = inc_size*2:inc_size:N % RM is extended N/incr_size - 1 times
    n = N;
    RM_temp = eye(n); RM_temp(1:n-inc_size,1:n-inc_size) = RM; 
    RM = RM_temp; % previous rotation matrix;
    overlap_size = ceil(overlap_rate*inc_size); % the number of variables in overlap with previous matrix
    IJ_t = all_IJ(find(all_IJ(:,2) >= n - inc_size + 1 & all_IJ(:,2) <=n),:);
    d1 = (n - inc_size) - overlap_size; % threshold for the first element of overlapped block
    d2 = n - (inc_size - overlap_size); % threshold for the first element of indepdent block
    IJ_overlap = IJ_t(find(IJ_t(:,1) > d1 & IJ_t(:,1) <= d2 & IJ_t(:,2) > d1 & IJ_t(:,2) <= d2),:);   % overlapped rotations with previous matrix
    IJ_independent = IJ_t(find(IJ_t(:,1) > d2 & IJ_t(:,2) > d2),:);  % independent rotations in the increased matrix
    IJ = [IJ_overlap; IJ_independent];
    % IJ = [n - 1,n];
    K = size(IJ,1);
    RV = rand(K,2);
    
    for k = 1:K % K rotations applied to RM_n
        RM_k = eye(n);
        i = IJ(k,1); j = IJ(k,2);
        I_mat = [sub2ind([n n], i, i), sub2ind([n n], i, j), sub2ind([n n], j, i), sub2ind([n n], j, j)];
        %I_mat = [n*(i - 1) + i, n*(j - 1) + i, n*(i - 1) + j, n*(j - 1) + j]; % indices of the elements to be rotated
        R_mat = planerot(RV(k,:)')'; R_mat = R_mat(:); % rotation values of each element
        RM_k(I_mat) = R_mat;
        RM = RM_k*RM;
    end;
end

%end

