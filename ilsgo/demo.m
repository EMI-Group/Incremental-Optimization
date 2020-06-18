% This structure contains the relevant fields to instantiate a test function.
% The number of times that the dimension will increase is determined by
% 'num_changes' and the increments will be generated randomly. The changes
% will not occur at regular intervals; they rather occur randomly.

policy.base_func    = 'sphere';  % The name of the base function. Options: 'sphere', 'elliptic', 'rastrigin', 'ackley', rosenbrock', 'schwefel'.
policy.num_changes  = 4;         % The number of times the dimension of f(x) will change.
policy.dim_initial  = 3;         % The initial dimensionality of f(x).
policy.dim_terminal = 15;        % The final dimensionality of f(x).
policy.max_fes      = 10;        % The dimensionality will reach up to dim_terminal after this number of evaluations. The dimension stays the sames indefinitely after this.
policy.overlap      = 0;         % The overlap rate.
policy.seed         = 0;         % Random seed (for reproducibility).

% policy.triggers = [3 5 9 11 Inf]';
% policy.increments = [0 4 4 2 1]';

addpath('../givens')


% ilsgo is the function handle. If it is invoked with a structure, it will instantiate a problem. 
% output:
%   - triggers   : the intervals at which the dimension will increase. The units are in FEs.
%   - increments : the increment sizes are returned in this vector.
[policy] = ilsgo(policy)

x = rand(policy.dim_initial, 1);
for i=1:15
    [f d] = ilsgo(x);
    %[f d] = ilsgo(x, 4);
    
    % each time an increment happens an element is added to d which
    % determines the final dimensionality of f(x), and the function value
    % will be set to NaN. This is the way to detect a change.
    if isnan(f)
        x = rand(d(end), 1); % the last element of d determines the latest dim of f(x).
        [f d] = ilsgo(x);
    end

    fprintf(1, 'FEs: %03d, f(x)=%.2e, Stage: %02d, dims:[ %s]\n', i, f, numel(d), sprintf('%g ', d));
end


