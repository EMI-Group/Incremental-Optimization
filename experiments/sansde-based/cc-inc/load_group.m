
function [groups] = load_group(design, stage)
    sizes = design.dims - cumsum(design.increments)
    groups = {};
    for i = 1:stage
        groups{i} = [(i-1):design.dims(i)];
        groups{i} = (1:sizes(i))+cumsum(design.increments)(i);
    end
end
