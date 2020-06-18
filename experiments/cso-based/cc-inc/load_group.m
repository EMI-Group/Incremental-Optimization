
function [groups] = load_group(design, stage)
    sizes = design.increments;
    sizes(1) = design.dim_initial;
    groups = {};
    for i = 1:stage
        cs = [0 ; cumsum(sizes)];
        groups{i} = (1:sizes(i))+cs(i);
    end
end
