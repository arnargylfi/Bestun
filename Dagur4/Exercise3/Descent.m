close all; clear all ; clc;
%Test
% Test functions
f1 = @(x) sum(x.^2);          % Quadratic function
g = @(x) sin(x);              % Sin function
h = @(x) exp(x(1)/5 + x(2)/2) + x(1)^2 + x(2)^2; % Exponential and quadratic
rosenbrock = @(x) (1-x(1))^2 + 100*(x(2)-x(1)^2)^2; % Rosenbrock function

% Starting points
x0_1 = (1:10)'; % For f1 with n = 10
x0_2 = 2;       % For g
x0_3 = [5; 3];  % For h
x0_4 = [0; 0];  % For Rosenbrock

% Call the trust region method
x_min_1 = trust_region_descent(f1, x0_1, 0.001, 100, 1e-8);
x_min_2 = trust_region_descent(g, x0_2, 0.001, 100, 1e-8);
x_min_3 = trust_region_descent(h, x0_3, 0.001, 1000, 1e-8);
x_min_4 = trust_region_descent(rosenbrock, x0_4, 0.001, 1000, 1e-8);

% Display results
disp('Results for f1:');
disp(x_min_1);
disp('Results for g:');
disp(x_min_2);
disp('Results for h:');
disp(x_min_3);
disp('Results for Rosenbrock:');
disp(x_min_4);

function x_min = trust_region_descent(f, x, delta, kmax, tol)
    k = 0;
    found = false;
    h=1e-5;
    % hvec = min(x):delta:max(x);
    % x_min_counter;
    while ~found && k <= kmax
        k = k + 1;
        
        grad = finite_diff_gradient(f, x, h);
        if norm(grad) == 0
            disp('Norm(grad)=0');
        end

        htr = -delta * grad / norm(grad);
        q = @(h) f(x) + h'*grad;
        
        q0 = q(x);
        qhtr = q(x + htr);
        actual_reduction = f(x) - f(x + htr);
        predicted_reduction = q0 - qhtr;
    
        if predicted_reduction == 0
            r = 0;
        else
            r = actual_reduction / predicted_reduction;
        end
        
        % Update the trust region radius
        if r > 0.75
            delta = 2 * delta;
        elseif r < 0.25
            delta = delta / 3;
        end
        
        % Update the solution
        if r > 0
            x = x + htr;
        end
        
        % Check convergence (norm of the gradient or change in x could be used)
        if norm(grad) < tol || norm(htr) < tol
            found = true;
            disp('found solution!');
        end
    end
    
    x_min = x;
end

function grad = finite_diff_gradient(f, x, h)
    n = length(x);
    grad = zeros(n, 1);
    for i = 1:n
        x_plus = x;
        x_minus = x;
        x_plus(i) = x_plus(i) + h;
        x_minus(i) = x_minus(i) - h;
        f_plus = f(x_plus);
        f_minus = f(x_minus);
        grad(i) = (f_plus - f_minus) / (2 * h);
    end
end

