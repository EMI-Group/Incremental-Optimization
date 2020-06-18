function [fx] = imop(varargin)
    
    if (nargin == 1)
        %addpath('./givens');
        policy.seed         = 1;
        policy.num_stages   = 3;
%         policy.dim_initial  = 40;
%         policy.increments   = [0 10 10]';
        policy.triggers = [];
        %policy.dim_terminal = 15;
        %policy.max_fes      = 10;
        id = varargin{1};
        policy.fid = id;
        
        switch id
            case 0
                policy.base_func = 'elliptic';
                policy.ub = 100;
                policy.lb = -100;
                
                policy.dim_initial  = 20;
                policy.increments   = [0 20 20]';
                policy.overlap = [0 0 0];
                
            % fully separable 
            case 1
                policy.base_func = 'sphere';
                policy.ub = 100;
                policy.lb = -100;
                
                policy.dim_initial  = 20;
                policy.increments   = [0 20 20]';
                policy.overlap = [0 0 0];
            case 2
                policy.base_func = 'rastrigin';
                policy.ub = 5;
                policy.lb = -5;
                
                policy.dim_initial  = 20;
                policy.increments   = [0 20 20]';
                policy.overlap = [0 0 0]';
             case 3
                policy.base_func = 'elliptic';
                policy.ub = 100;
                policy.lb = -100;
                
                policy.dim_initial  = 35;
                policy.increments   = [0 15 10]';
                policy.overlap = [0 0.2 0.2]';
            case 4
                policy.base_func = 'rastrigin';
                policy.ub = 5;
                policy.lb = -5;
                
                policy.dim_initial  = 5;
                policy.increments   = [0 15 40]';
                policy.overlap = [0 0.2 0.2]';
            case 5
                policy.base_func = 'elliptic';
                policy.ub = 100;
                policy.lb = -100;
                
                policy.dim_initial  = 20;
                policy.increments   = [0 20 20]';
                policy.overlap = [0 0.5 0.5]';
            case 6
                policy.base_func = 'rastrigin';
                policy.ub = 5;
                policy.lb = -5;
                
                policy.dim_initial  = 20;
                policy.increments   = [0 20 20]';
                policy.overlap = [0 0.5 0.5]';
            case 7
                policy.base_func = 'rosenbrock';
                policy.ub = 5;
                policy.lb = -5;
                
                policy.dim_initial  = 20;
                policy.increments   = [0 20 20]';
                policy.overlap = [0 1 1]';
            otherwise
                display('the function does not exist!');
        end
        fx = ilsgo(policy);
    else
        fx = ilsgo(varargin{1}, varargin{2});
    end
end
