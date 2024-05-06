function [xmin, fmin, path] = HookeJeeves(func, bounds, start_point, max_iter, tol)
    x = start_point;
    grid_size = 1.0; % Initial grid size
    fmin = func(x(1), x(2));
    xmin = x;
    improved_cnt = 1;
    path(1,:) = xmin;

    for iter = 1:max_iter
        xn = x;
        % Explore along each dimension
        for d = 1:length(x)
            xp = xn;
            xp(d) = xp(d) + grid_size; % Move up in dimension d
            if xp(d) <= bounds(d,2) && func(xp(1), xp(2)) < fmin
                fmin = func(xp(1), xp(2));
                xn = xp;
                improved_cnt = improved_cnt + 1;
                path(improved_cnt,:) = xn;
                disp('Number of iterations:');
                disp(iter);
                disp('Xmin: ');
                disp(xmin);
                disp('Fmin');
                disp(fmin);
            else
                xp(d) = x(d) - grid_size; % Move down in dimension d
                if xp(d) >= bounds(d,1) && func(xp(1), xp(2)) < fmin
                    fmin = func(xp(1), xp(2));
                    xn = xp;
                    improved_cnt = improved_cnt + 1;
                    path(improved_cnt,:) = xn;
                    disp('Number of iterations:');
                    disp(iter);
                    disp('Xmin: ');
                    disp(xmin);
                    disp('Fmin');
                    disp(fmin);
                end
            end
        end
        
        if any(xn ~= x)
            % Successful exploratory move, perform pattern move
            direction = xn - x;
            while true
                xp = xn + direction;
                if all(xp >= bounds(:,1) & xp <= bounds(:,2)) && func(xp(1), xp(2)) < fmin
                    fmin = func(xp(1), xp(2));
                    xn = xp; % Update current point
                    improved_cnt = improved_cnt + 1;
                    path(improved_cnt,:) = xn;
                    disp('Number of iterations:');
                    disp(iter);
                    disp('Xmin: ');
                    disp(xmin);
                    disp('Fmin');
                    disp(fmin);
                else
                    break;
                end
            end
            x = xn; % Update base point
        else
            % No improvement found, reduce grid size
            grid_size = grid_size/3;
            if grid_size < tol
                break;
            end
        end
    end
    xmin = xn;
end
