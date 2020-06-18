
% Test function generator for Incremental Large-Scale Optimization (ILSGO).
function [fx d] = ilsgo(x, varargin)
    persistent increments triggers f fes stage R overlap dims Rotations;
    if isstruct(x)
        desing = x;
        state = rand('state');
        if isfield(desing, 'seed')
            rand('state', desing.seed);
        end
        f = str2func(desing.base_func);
        fes = 0;
        stage = 1;
        overlap = desing.overlap;

        if (~isfield(desing, 'triggers') && ~isfield(desing, 'increments'))
            uniq = 1;
            while uniq
                increase_range = desing.dim_terminal - desing.dim_initial;
                increments = rand(desing.num_stages - 1, 1);
                increments = increments / sum(increments);
                increments = [0 ; round(increments * increase_range)];
                uniq = numel(dims) ~= numel(unique(dims));
            end

            uniq = 1;
            while uniq
                triggers = rand(desing.num_stages - 1, 1);
                triggers = triggers / sum(triggers);
                triggers = round(triggers * desing.max_fes);
                triggers = [cumsum(triggers) ; inf];
                uniq = numel(triggers) ~= numel(unique(triggers));
            end
            desing.triggers   = triggers;
            desing.increments = increments;
        end
        
        triggers = desing.triggers;
        increments = desing.increments;
        dims = desing.dim_initial + cumsum(increments);
        desing.dims = dims;

        Rotations = {};
        Rotations{1} = GivensRot(dims(stage));
        for i=2:numel(increments)
            Rotations{i} = IncreGivensRot2(Rotations{i-1}, increments(i), overlap(i));
        end

        fx = desing;
        d  = [];
        rand('state', state);
    else
        if (nargin == 2)
            stage = varargin{1};
            R = Rotations{stage};
        else
            if (stage == 1)
                R = Rotations{1};
            end
            s = min(find(fes < triggers));
            if (s ~= stage)
                stage = s;
                R = Rotations{stage};
            end
        end
        d = dims(1:stage);

        if size(R, 1) ~= size(x,1)
            fx = nan;
            return;
        end
        fx = f(R*x);
        if (nargin == 1)
            fes = fes + 1;
        end
    end
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% BASE FUNCTIONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%------------------------------------------------------------------------------
% Sphere Function 
%------------------------------------------------------------------------------
function fit = sphere(x)
    fit = sum(x.*x);
end


%------------------------------------------------------------------------------
% Elliptic Function
%------------------------------------------------------------------------------
function fit = elliptic(x)
    [D ps] = size(x);
    condition = 1e+6;
    coefficients = condition .^ linspace(0, 1, D); 
    fit = coefficients * x.^2; 
end


%------------------------------------------------------------------------------
% Rastrigin's Function
%------------------------------------------------------------------------------
function fit = rastrigin(x)
    [D ps] = size(x);
    A = 10;
    fit = A*(D - sum(cos(2*pi*x), 1)) + sum(x.^2, 1);
end


%------------------------------------------------------------------------------
% Ackley's Function
%------------------------------------------------------------------------------
function fit = ackley(x)
    [D ps] = size(x);
    fit = sum(x.^2,1);
    fit = 20-20.*exp(-0.2.*sqrt(fit./D))-exp(sum(cos(2.*pi.*x),1)./D)+exp(1);
end


% %------------------------------------------------------------------------------
% % Schwefel's Problem 1.2  % non-separable
% %------------------------------------------------------------------------------
% function fit = schwefel(x)
%     [D ps] = size(x);
%     fit = 0;
%     for i = 1:D
%         fit = fit + sum(x(1:i,:),1).^2;
%     end
% end

%------------------------------------------------------------------------------
% Schwefel's Problem 2.21 % separable
%------------------------------------------------------------------------------
function fit = schwefel(x)
    fit = max(abs(x), [], 1);
end


%------------------------------------------------------------------------------
% Rosenbrock's Function
%------------------------------------------------------------------------------
function fit = rosenbrock(x)
    [D ps] = size(x);
    fit = sum(100.*(x(1:D-1,:).^2-x(2:D, :)).^2+(x(1:D-1, :)-1).^2);
end

