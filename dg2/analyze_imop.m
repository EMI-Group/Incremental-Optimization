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

addpath(genpath('../ilsgo'))

for fun_id = 2:7
    design = imop(fun_id);
    opts.lbound  = design.lb;
    opts.ubound  = design.ub;
    for stage=1:design.num_stages
        f = @(x)(imop(x', stage));
        opts.dim = design.dims(stage);

        [delta, lambda, evaluations] = ism(f, opts);
        [nonseps, seps, theta, epsilon] = dg2(evaluations, lambda, opts.dim);
%         theta
         evaluations.count;
%         pause
        
        filename = sprintf('./results/imop%d-s%d.mat', fun_id, stage);
        save (filename, 'delta', 'lambda', 'evaluations', 'nonseps', 'seps', 'theta', 'epsilon', '-v7');
        
        
        interaction_plot(theta,fun_id);
        figname = sprintf('./results/imop%d-s%d', fun_id, stage);
        print(gcf,figname,'-depsc');
    end
end



