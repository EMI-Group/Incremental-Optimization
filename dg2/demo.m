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

opts.lbound  = -100;
opts.ubound  = 100;
opts.dim     = 12;
increment    = 6;
overlap      = .5;

addpath('../givens')
addpath('./benchmark')

global initial_flag;
initial_flag = 0;
fun_num = 4;
R = IncreGivensRot(opts.dim, increment, overlap);
f = @(x)(TestFunc(x, fun_num, R));

[delta, lambda, evaluations] = ism(f, opts);
[nonseps, seps, theta, epsilon] = dg2(evaluations, lambda, opts.dim);
theta
evaluations.count

filename = sprintf('./results/test1.mat');
save (filename, 'delta', 'lambda', 'evaluations', 'nonseps', 'seps', 'theta', 'epsilon', '-v7');


