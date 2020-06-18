
function [bestval bestmem] = decc(imop, design, get_group, opts, runindex, fhs)

    fid = fhs.trace;
    fid_trace2 = fhs.trace2;

    stage = 1;
    func = @(x)(imop(x', stage));

    dim = design.dims(stage);
    popsize = opts.popsize;
    Lbound = design.lb * ones(popsize, dim);
    Ubound = design.ub * ones(popsize, dim);
    Max_FEs = opts.max_fes;
    display = opts.display;

    sansde_iter = opts.epoch_length;

    % for fitness trace
    tracerst = [];

    % the initial population
    pop = Lbound + rand(popsize, dim) .* (Ubound - Lbound);

    val = func(pop);
    [bestval, ibest] = min(val);
    bestmem = pop(ibest, :);
    fes_total = popsize;
    fes_max = sum(opts.max_fes);
    fes_levels = cumsum(opts.max_fes)

    transition = false;
    
    % [_ fitVector] = feval(fname, func_num, bestmem, runindex);
    % print_vec(fitVector, fid_trace2);

    groups = get_group(design.fid, stage);
    group_num = size(groups, 2)
    
    for i=1:group_num
        OPTS{i}.first = 1;
    end

    Cycle = 0;
    
    while (fes_total < fes_max)
        Cycle = Cycle + 1

        for i = 1:group_num

            if (fes_total + (sansde_iter * popsize) > fes_levels(stage))
                sansde_iter = ceil((fes_levels(stage) - fes_total) / popsize);
            end
            sansde_iter

            if (sansde_iter < 1)
                if (stage ~= design.num_stages)
                    transition = true;
                end
                break;
            end

            dim_index = groups{i};

            subpop = pop(:, dim_index); 
            subLbound = Lbound(:, dim_index);        
            subUbound = Ubound(:, dim_index);


            [subpopnew, bestmemnew, bestvalnew, tracerst, newOPTS, used_FEs] = sansde(func, dim_index, subpop, bestmem, bestval, subLbound, subUbound, sansde_iter, OPTS{i}, group_num, runindex);
            OPTS{i} = newOPTS;
            used_FEs
            fes_total = fes_total + used_FEs

            fprintf(fid, '%e\n', tracerst);

            pop(:, dim_index) = subpopnew;
            bestmem = bestmemnew;
            bestval = bestvalnew;

            if (bestval < opts.threshold)
                transition = true;
            end

            % [_ fitVector] = feval(fname, func_num, bestmem, runindex);
            % print_vec(fitVector, fid_trace2);

            if(display == 1)
                fprintf(1, 'Cycle = %d, bestval = %e, Group = %d *\n',  Cycle, bestval, i);
            end
        end
        
        if (transition)
            stage = stage + 1;
            func = @(x)(imop(x', stage));
            dim = design.dims(stage);
            Lbound = design.lb * ones(popsize, dim);
            Ubound = design.ub * ones(popsize, dim);
            temp_pop = Lbound + rand(popsize, dim) .* (Ubound - Lbound);
            temp_pop(:,1:design.dims(stage-1)) = pop;
            pop = temp_pop;
            temp_best = Lbound(1,:) + rand(1, dim) .* (Ubound(1,:) - Lbound(1,:));
            temp_best(1:design.dims(stage-1)) = bestmem;
            bestmem = temp_best;
            bestval = func(bestmem);

            group_num_old = group_num
            groups = get_group(design.fid, stage)
            group_num = size(groups, 2)
            for(g=group_num_old+1:group_num)
                OPTS{g}.first = 1;
            end

            sansde_iter = opts.epoch_length;

            transition = false;
        end
    end
end

function print_vec(v, fh)
    len = length(v);
    for j=1:len-1
        fprintf(fh, '%e ', v(j));
    end
    fprintf(fh, '%e\n', v(end));
    fflush(fh);
end
