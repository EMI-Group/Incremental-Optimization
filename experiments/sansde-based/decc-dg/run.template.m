% Nabi Omidvar

tic;
clear;
% set random seed
rand('state', sum(100*clock));
randn('state', sum(100*clock));

addpath(genpath('../../ilsgo'))

arg_list = argv();
runindex = str2num(arg_list{1});

func_num     = %FUN%;
popsize      = 50;
max_fes      = 3e4;
epoch_length = 50;

design = imop(func_num);

opts.popsize = popsize;
opts.max_fes = max_fes;
opts.epoch_length = epoch_length;
opts.display = 1;
opts.threshold = eps;
opts.fail_count = 1;
opts.max_fes = design.dims * 5000;

fhs.trace  = fopen(sprintf('trace/tracef%02d_%02d.txt',  func_num, runindex), 'w');
fhs.trace2 = fopen(sprintf('trace2/trace%02d_%02d.txt',  func_num, runindex), 'w');

get_groups = @(a, b)(load_group(a, b, './dg2'));

[bestval bestmem] = decc(@imop, design, get_groups, opts, runindex, fhs);

fid = fopen(sprintf('sols/sol%02d_%02d.txt', func_num, runindex), 'w');
fprintf(fid, '%g\n', bestmem);

fclose(fhs.trace);
fclose(fhs.trace2);
toc;
