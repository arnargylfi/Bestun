function [x, fval, iter] = descentTrustRegionMethod(func, x0, maxIter, tol)
    % Inputs:
    %   func - Function handle for the objective function
    %   x0 - Initial guess
    %   maxIter - Maximum number of iterations
    %   tol - Tolerance for stopping criterion

    % Golden ratio
    gr = (sqrt(5) + 1) / 2;

    % Initialization
    x = x0;
    iter = 0;
    trust_region = 1.0;
    
    % Main loop
    while iter < maxIter
        % Estimate gradient using finite differences
        grad = estimateGradient(func, x);
        
        % Choose the step direction and size
        direction = -grad; % Descent direction
        [alpha, ~] = goldenRatioSearch(func, x, direction, trust_region, gr);
        
        % Update the point
        x_new = x + alpha * direction;
        
        % Update or reset the trust region based on improvement
        if func(x_new) < func(x)
            x = x_new;
            trust_region = min(trust_region * 1.5, 10); % Expand trust region
        else
            trust_region = trust_region * 0.5; % Contract trust region
        end
        
        % Check convergence (using norm of the gradient here)
        if norm(grad) < tol
            break;
        end
        
        iter = iter + 1;
    end
    
    fval = func(x);
end

function grad = estimateGradient(f, x)
    eps = 1e-6; % Small perturbation
    grad = zeros(length(x), 1);
    fx = f(x);
    for i = 1:length(x)
        x_eps = x;
        x_eps(i) = x_eps(i) + eps;
        grad(i) = (f(x_eps) - fx) / eps;
    end
end

function [alpha, f_alpha] = goldenRatioSearch(func, x, d, region, gr)
    a = 0;
    b = region;
    c = b - (b - a) / gr;
    d = a + (b - a) / gr;
    while abs(c - d) > 1e-5
        fc = func(x + c * d);
        fd = func(x + d * d);
        if fc < fd
            b = d;
        else
            a = c;
        end
        c = b - (b - a) / gr;
        d = a + (b - a) / gr;
    end
    alpha = (b + a) / 2;
    f_alpha = func(x + alpha * d);
end
