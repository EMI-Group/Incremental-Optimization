
function [groups] = load_group(fun_id, stage, path)
    filename = fullfile(path, sprintf('imop%d-s%d.mat', fun_id, stage));
    load(filename);
    
    if(isempty(seps))
        groups = nonseps;
    else
        groups = {nonseps{1:end} seps}; 
    end
end
