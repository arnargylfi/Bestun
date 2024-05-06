clear all, close all, clc

% Test 1: Quadratic function
n = 5; % Example dimension
x0 = (1:n)';
f1 = @(x) sum(x.^2);
[x1, fval1, all_x1, all_fval1] = descentTrustRegionMethod(f1, x0, 100, 1e-6);
figure;
plot(all_fval1);
title('Objective Function Values for Quadratic Function');
xlabel('Iteration');
ylabel('Objective Function Value');

% Test 2: Sine function
f2 = @(x) sin(x);
[x2, fval2, all_x2, all_fval2] = descentTrustRegionMethod(f2, 2, 100, 1e-6);
figure;
plot(all_fval2);
title('Objective Function Values for Sine Function');
xlabel('Iteration');
ylabel('Objective Function Value');

% Test 3: Exponential and quadratic function
f3 = @(x) exp(x(1)/5 + x(2)/2) + x(1)^2 + x(2)^2;
[x3, fval3, all_x3, all_fval3] = descentTrustRegionMethod(f3, [5; 3], 100, 1e-6);
figure;
plot(all_fval3);
title('Objective Function Values for Exponential and Quadratic Function');
xlabel('Iteration');
ylabel('Objective Function Value');

% Test 4: Rosenbrock function
f4 = @(x) (1 - x(1))^2 + 100 * (x(2) - x(1)^2)^2;
[x4, fval4, all_x4, all_fval4] = descentTrustRegionMethod(f4, [0; 0], 100, 1e-6);
figure;
plot(all_fval4);
title('Objective Function Values for Rosenbrock Function');
xlabel('Iteration');
ylabel('Objective Function Value');



function [x, fval, iter, all_x, all_fval] = descentTrustRegionMethod(func, x0, maxIter, tol)
    % Initialization
    x = x0;
    iter = 0;
    trust_region = 1.0;
    gr = (sqrt(5) + 1) / 2;
    all_x = x0;
    all_fval = func(x0);
    
    % Main loop
    while iter < maxIter
        grad = estimateGradient(func, x);
        direction = -grad;
        [alpha, ~] = goldenRatioSearch(func, x, direction, trust_region, gr);
        x_new = x + alpha * direction;
        
        if func(x_new) < func(x)
            x = x_new;
            trust_region = min(trust_region * 1.5, 10);
        else
            trust_region = trust_region * 0.5;
        end

        if norm(grad) < tol
            break;
        end
        
        iter = iter + 1;
        all_x = [all_x x];
        all_fval = [all_fval func(x)];
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
