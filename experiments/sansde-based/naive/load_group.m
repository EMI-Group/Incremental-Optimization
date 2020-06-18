function [groups] = load_group(design, stage)
    groups{1} = [1:design.dims(stage)];
end
