
function [bestval sols] = cbcc(imop, design, get_group, opts, runindex, fhs)

    sols = {};
    fid = fhs.trace;
    fid_groups = fhs.groups;
    fid_gcount = fhs.gcount;

    stage = 1;
    func = @(x)(imop(x', stage));

    dim = design.dims(stage);
    popsize = opts.popsize;
    Lbound = design.lb * ones(1, dim);
    Ubound = design.ub * ones(1, dim);
    Max_FEs = opts.max_fes;
    display = opts.display;

    sansde_iter = opts.epoch_length;

    % for fitness trace
    tracerst = [];

    % the initial population
    pop = Lbound + rand(popsize, dim) .* (Ubound - Lbound);
    v = zeros(popsize, dim); 

    val = func(pop);
    [bestval, ibest] = min(val);
    bestmem = pop(ibest, :);
    prev_best_val = bestval;
    fes_total = popsize;
    fes_max = sum(opts.max_fes);
    fes_levels = cumsum(opts.max_fes);

    transition = false;

    groups = get_group(stage);
    group_num = size(groups, 2);
    
    df = inf(1, group_num);
    [df_sorted, df_ind] = sort(df, 'descend');
    
    groups_count = zeros(1, group_num);
    exploration = true;
    
    Cycle = 0;
    while (fes_total < fes_max)
        Cycle = Cycle + 1;

    	[df_sorted, df_ind] = sort(df, 'descend');
    
    	dim_index = groups{df_ind(1)};

        ind_rest = [1:group_num] ~= df_ind(1);
        second_best = max(df(ind_rest));
        if(isempty(second_best))
            second_best = 0;
        end
    
        td = inf;
        while(td ~= 0 && fes_total < fes_max && td >= second_best  && sansde_iter > 0)

            if (fes_total + (sansde_iter * popsize) > fes_levels(stage))
                sansde_iter = ceil((fes_levels(stage) - fes_total) / popsize);
            end

            if (sansde_iter < 1)
                if (stage ~= design.num_stages)
                    transition = true;
                end
                break;
            end

            groups_count(df_ind(1)) = groups_count(df_ind(1))+1;
    
            subpop = pop(:, dim_index); 
            subv = v(:, dim_index);
            subLbound = Lbound(:, dim_index);        
            subUbound = Ubound(:, dim_index);

            [subpopnew, subvnew, bestmemnew, bestvalnew, tracerst, used_FEs] = cso(func, dim_index, subpop, subv, bestmem, bestval, subLbound, subUbound, sansde_iter, group_num);

            fes_total = fes_total + used_FEs;

            fprintf(fid, '%e\n', tracerst);

            prev_best_val = bestval;
            pop(:, dim_index) = subpopnew;
            subv(:, dim_index) = subvnew;
            bestmem = bestmemnew;
            bestval = bestvalnew;

            td = prev_best_val - bestval;
            if(td > 0 || exploration)
                df(df_ind(1)) = td;
            end

            if (bestval < opts.threshold)
                transition = true;
                break;
            end

            if(display == 1)
                fprintf(1, 'Cycle = %d, bestval = %e, Group = %d\n',  Cycle, bestval, df_ind(1));
            end
    
            fprintf(fid_groups, '%d\n', df_ind(1) );


            if (max(df) ~= inf)
                exploration = false;
            end
            if (rand < opts.pexplore && ~exploration)
                % 'EXPLORATION'
                exploration = true;
                df = inf(1, group_num);
                break;
            end
       	end
     
        if (transition)
            sols{stage} = bestmem;
            if(stage == design.num_stages)
                break;
            end
            stage = stage + 1;
            func = @(x)(imop(x', stage));
            dim = design.dims(stage);
            Lbound = design.lb * ones(1, dim);
            Ubound = design.ub * ones(1, dim);
            temp_pop = Lbound + rand(popsize, dim) .* (Ubound - Lbound);
            temp_pop(:,1:design.dims(stage-1)) = pop;
            pop = temp_pop;
            temp_v = zeros(popsize, dim);
            temp_v(:, 1:design.dims(stage-1)) = v;
            v = temp_v;
            temp_best = Lbound + rand(1, dim) .* (Ubound - Lbound);
            temp_best(1:design.dims(stage-1)) = bestmem;
            bestmem = temp_best;
            bestval = func(bestmem);

            group_num_old = group_num;
            groups = get_group(stage);
            group_num = size(groups, 2);

            sansde_iter = opts.epoch_length;

            df(group_num) = inf;
            groups_count(group_num) = 0;

            transition = false;
        end
    end
    fprintf(fid_gcount, '%d ', groups_count);
    fprintf(fid_gcount, '\n', groups_count);
end

function print_vec(v, fh)
    len = length(v);
    for j=1:len-1
        fprintf(fh, '%e ', v(j));
    end
    fprintf(fh, '%e\n', v(end));
    fflush(fh);
end
