%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Implementation of a competitive swarm optimizer (CSO) for large scale optimization
%%
%%  See the details of CSO in the following paper
%%  R. Cheng and Y. Jin, A Competitive Swarm Optimizer for Large Scale Optmization,
%%  IEEE Transactions on Cybernetics, 2014
%%
%%  The test instances are the CEC'08 benchmark functions for large scale optimization
%%
%%  The source code CSO is implemented by Ran Cheng
%%
%%  If you have any questions about the code, please contact:
%%  Ran Cheng at r.cheng@surrey.ac.uk
%%  Prof. Yaochu Jin at yaochu.jin@surrey.ac.uk
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%function [bestx, bestf] = cso(d, funcid, maxfes, lbounds, ubounds)
% function [p, v, bestmem, bestval, tracerst, OPTS, FES] = cso(func, dim_index, pop, v, bestmem, bestval, lbounds, ubounds, itermax, OPTS, gcount)
function [p, v, bestmem, bestval, tracerst, FES] = cso(func, dim_index, pop, v, bestmem, bestval, lbounds, ubounds, itermax, gcount)
% d: number of decision variables
% funcid: the function to be optimized
% maxfes: maximum number of fitness evaluations
% lbounds: lower boundaries, e.g, [-1 -1]'
% ubounds: upper boundaries, e.g. [1 1]'
% example input: [bestx, bestf] = CSO_Nabi(2, 1, 10000, [-1 -1]', [1 1]')

%lu = [lbounds'; ubounds'];
lu = [lbounds; ubounds];
[m d] = size(pop); % population size
phi = 0.0; % convergence parameter, no need to be changed
tracerst = [];

% % initialization
% XRRmin = repmat(lu(1, :), m, 1);
% XRRmax = repmat(lu(2, :), m, 1);
% %p = XRRmin + (XRRmax - XRRmin) .* rand(m, d);% Random
% p = XRRmin + (XRRmax - XRRmin) .* lhsdesign(m,d); % Latin
% fitness = yao_func(p, funcid);

% if (OPTS.first == 1)
%     v = zeros(m,d); 
%     OPTS.first = 0;
% else
%     v = OPTS.v;
% end

gpop = ones(m, 1) * bestmem;
gpop(:, dim_index) = pop;
p = pop;
fitness = func(gpop);
fitness = fitness';
[bestf I] = min(fitness);
bestx = p(I,:);
FES = 0;
if(gcount > 1) 
    FES = m;
end

if (bestf < bestval)
	bestval = bestf;
	bestmem = gpop(I, :);
end


tic;
% main loop
for iter=1:itermax

    % generate random pairs
    rlist = randperm(m);
    rpairs = [rlist(1:ceil(m/2)); rlist(floor(m/2) + 1:m)]';
    
    % calculate the center position
    center = ones(ceil(m/2),1)*mean(p);
    
    % do pairwise competitions
    %size(fitness)
    mask = (fitness(rpairs(:,1)) > fitness(rpairs(:,2)));
    losers = mask.*rpairs(:,1) + ~mask.*rpairs(:,2);
    winners = ~mask.*rpairs(:,1) + mask.*rpairs(:,2);
    
    %random matrix
    randco1 = rand(ceil(m/2), d);
    randco2 = rand(ceil(m/2), d);
    randco3 = rand(ceil(m/2), d);
    
    % losers learn from winners
    % size(losers)
    % size(v)
    % size(p)
    v(losers,:) = randco1.*v(losers,:) ...,
        + randco2.*(p(winners,:) - p(losers,:)) ...,
        + phi*randco3.*(center - p(losers,:));
    p(losers,:) = p(losers,:) + v(losers,:);
    
    % boundary control
    for i = 1:ceil(m/2)
        p(losers(i),:) = max(p(losers(i),:), lu(1,:));
        p(losers(i),:) = min(p(losers(i),:), lu(2,:));
    end

    gpop(:, dim_index) = p;
    
    % fitness evaluation
    %fitness(losers,:) = func(p(losers,:))
    fitness(losers,:) = func(gpop(losers,:));
    % best solution
    [B,I] = min(fitness);
    if(B < bestf)
        bestf = B;
        bestx = p(I,:);
    end;
    if(bestf < bestval)
        bestmem(dim_index) = pop(I, :);
	    bestval = bestf;
    end;
    FES = FES + ceil(m/2);
    tracerst = [tracerst; bestf];
    
end;

% OPTS.v = v;

end

