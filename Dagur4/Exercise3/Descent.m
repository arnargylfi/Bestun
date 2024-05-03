function x_min = trust_region_descent(f, x, delta, kmax, tol)
    k = 0;
    found = false;
    
    while ~found && k <= kmax
        k = k + 1;
        
        grad = finite_diff_gradient(f, x, 1e-5);
        htr = -delta * grad / norm(grad);
        
        q0 = f(x);
        qhtr = f(x + htr);
        actual_reduction = q0 - f(x + htr);
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
        end
    end
    
    x_min = x;
end

function grad = finite_diff_gradient(f, x, h)
    n = length(x);
    grad = zeros(n, 1);
    for i = 1:n
        x_forward = x;
        x_forward(i) = x_forward(i) + h;
        f_forward = f(x_forward);
        f_current = f(x);
        grad(i) = (f_forward - f_current) / h;
    end
end
