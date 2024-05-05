function [x_min, k] = trust_region_descent(f, x, delta, kmax, tol, golden_ratio)
    k = 0;
    found = false;
    h=1e-5;
    % Initialize a matrix to store x values for plotting
    x_values = zeros(length(x), kmax);

    while ~found && k <= kmax
        k = k + 1;
        
        grad = finite_diff_gradient(f, x, h);
        if norm(grad) == 0
            disp('Norm(grad)=0');
        end

        
        q = @(h) f(x) + h'*grad;
        if golden_ratio
            [alpha_min, ~, ~] = golden_ratio_search(q, 0, delta*2, 1e-3, ((1 + sqrt(5)) / 2), false);
            htr = -alpha_min * grad;
            % golden_ratio = false;
        else
           htr = -delta * grad / norm(grad);
        end
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
        
        % Store the current x for plotting
        x_values(:, k) = x;

        % Check convergence
        if norm(grad) < tol || norm(htr) < tol
            found = true;
            disp('found solution!');
        end
    end
    
    x_values = x_values(:, 1:k);
    %Plot
    figure;
    plot(1:k, x_values');
    legend(arrayfun(@(i) sprintf('x(%d)', i), 1:length(x), 'UniformOutput', false));
    title('Convergence of components of x over iterations');
    xlabel('Iteration');
    ylabel('Component values');
    grid on;

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

function [xmin, fmin, iterations] = golden_ratio_search(f, x1, x2, tol, ratio, animate)
    d = (x2 - x1) / ratio;
    x3 = x2 - d;
    x4 = x1 + d;
    f1 = f(x1);
    f2 = f(x2);
    f3 = f(x3);
    f4 = f(x4);
    iterations = 0;
    
    if animate
    % Plot initial points
    h1 = plot(x1, f1, 'ro', 'MarkerFaceColor', 'r');
    h2 = plot(x2, f2, 'bo', 'MarkerFaceColor', 'b');
    h3 = plot(x3, f3, 'go', 'MarkerFaceColor', 'g');
    h4 = plot(x4, f4, 'mo', 'MarkerFaceColor', 'm');
    end

    while abs(x2 - x1) > tol
        iterations = iterations + 1;
        % Update points
        if f3 < f4
            x2 = x4;
            f2 = f4;
            x4 = x3;
            f4 = f3;
            d = (x2 - x1) / ratio;
            x3 = x2 - d;
            f3 = f(x3);
        else
            x1 = x3;
            f1 = f3;
            x3 = x4;
            f3 = f4;
            d = (x2 - x1) / ratio;
            x4 = x1 + d;
            f4 = f(x4);
        end
        
        if animate
        drawnow;
        pause(0.2)
        delete([h1, h2, h3, h4]);
      
        % Plot updated points
        h1 = plot(x1, f1, 'ro', 'MarkerFaceColor', 'r');
        h2 = plot(x2, f2, 'bo', 'MarkerFaceColor', 'b');
        h3 = plot(x3, f3, 'go', 'MarkerFaceColor', 'g');
        h4 = plot(x4, f4, 'mo', 'MarkerFaceColor', 'm');
        end
    end
    xmin = (x1 + x2) / 2;
    fmin = f(xmin);
end



