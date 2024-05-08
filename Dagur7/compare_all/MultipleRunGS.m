function [fbest] = MultipleRunGS(f, n, range, max_points)
    fbest = Inf;
    k = 0;
    while k < max_points
        xnew = (range(2) - range(1)) * rand(1, n) + range(1);
        [xnew, fnew] = perform_gradient_search(xnew, f, n);
        if fnew < fbest
            xbest = xnew;
            fbest = fnew;
        end
        k = k + 1;
    end
end

function [x, f] = perform_gradient_search(x, objective_function, n)
    alpha = 0.05;
    max_iterations = 10;
    epsilon = 1e-5;
    iter = 0;
    while iter < max_iterations
        gradient = zeros(size(x));
        for i = 1:numel(x)
            x_plus_delta = x;
            x_plus_delta(i) = x_plus_delta(i) + epsilon;
            gradient(i) = (objective_function(x_plus_delta) - objective_function(x)) / epsilon;
        end
        xny = x - alpha * gradient / norm(gradient);
        x = xny;
        f = objective_function(xny);
        iter = iter + 1;
    end
end
