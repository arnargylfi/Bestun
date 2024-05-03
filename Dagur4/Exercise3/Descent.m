function x_min = trust_region_descent(f, x, delta, kmax, tol)
    k = 0;
    found = false;
    h=1e-5;
    hvec = min(x):h:max(x);
    
    while ~found && k <= kmax
        k = k + 1;
        
        grad = finite_diff_gradient(f, x, h);
        if norm(grad) == 0
            disp('Norm(grad)=0');
            x_min = x;
            break;
        end
        disp(size(hvec))
        disp(size(grad))
        % htr = -delta * grad / norm(grad);
        q = f(x) + grad.*hvec;
        disp(size(q));
        htr = min(q);
        disp(size(htr))
        
        q0 = f(x);
        qhtr = f(x + htr);
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

