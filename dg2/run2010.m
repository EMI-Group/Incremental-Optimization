% Author: Mohammad Nabi Omidvar
% email address: mn.omidvar AT gmail.com
%
% ------------
% Description:
% ------------
% This files is the entry point for running the differential gropuing algorithm.

clear all;

% Specify the functions that you want the differential grouping algorithm to 
% identify its underlying grouping structure.

addpath('cec2010');
addpath('cec2010/datafiles');

arg_list = argv();
func_num = str2num(arg_list{1});

global initial_flag;
initial_flag = 0;

t1 = [1 4 7 8 9 12 13 14 17 18 19 20];
t2 = [2 5 10 15];
t3 = [3 6 11 16];

if (ismember(func_num, t1))
    lb = -100;
    ub = 100;
elseif (ismember(func_num, t2))
    lb = -5;
    ub = 5;
elseif (ismember(func_num, t3))
    lb = -32;
    ub = 32;
end

opts.lbound  = lb;
opts.ubound  = ub;
opts.dim     = 1000;

objfun = @(x)(benchmark_func(x, func_num));

[delta, lambda, evaluations] = ism(objfun, opts);
[nonseps, seps, theta, epsilon] = dg2(evaluations, lambda, opts.dim);

filename = sprintf('./results/2010/F%02d.mat', func_num);
save (filename, 'delta', 'lambda', 'evaluations', 'nonseps', 'seps', 'theta', 'epsilon', '-v7');

