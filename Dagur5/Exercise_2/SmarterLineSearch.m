function [xmin, fmin, path] = ImprovedPatternSearch(func, bounds, start_point, max_iter, tol)
    x = start_point;
    grid_size = 1.0;
    fmin = func(x(1), x(2));
    xmin = x;
    path = [];
    improved_cnt = 1;
    path(1,:) = xmin;
    for iter = 1:max_iter
        improved = false;
        % Explore neighboring points
        for dx = -1:1
            for dy = -1:1
                if dx ~= 0 || dy ~= 0
                    xn = x + grid_size * [dx; dy];
                    if all(xn >= bounds(:,1) & xn <= bounds(:,2))
                        fn = func(xn(1), xn(2));
                        if fn < fmin
                            xmin = xn;
                            fmin = fn;
                            improved = true;
                            improved_cnt = improved_cnt + 1;
                            path(improved_cnt,:) = xmin;
                            disp('Number of iterations:');
                            disp(iter);
                            disp('Xmin: ');
                            disp(xmin);
                            disp('Fmin');
                            disp(fmin);
                        end
                    end
                end
            end
        end
        
        % Perform line search if improvement found
        if improved
            direction = xmin - x;
            while true
                xn = xmin + grid_size * direction;
                if all(xn >= bounds(:,1) & xn <= bounds(:,2))
                    fn = func(xn(1), xn(2));
                    if fn < fmin
                        xmin = xn;
                        fmin = fn;
                        improved_cnt = improved_cnt + 1;
                        path(improved_cnt,:) = xmin;
                        disp('Number of iterations:');
                        disp(iter);
                        disp('Xmin: ');
                        disp(xmin);
                        disp('Fmin');
                        disp(fmin);
                    else
                        break;
                    end
                else
                    break;
                end
            end
        end
        
        % Update current point and adjust grid size
        x = xmin;
        if improved
            grid_size = min(grid_size * 1.1, max(bounds(:,2) - bounds(:,1)));
        else
            grid_size = grid_size/3;
            if grid_size < tol
                break;
            end
        end
    end
end
