function [history,fbest,xbest] = Diff_Evolution(fun, n, bounds, F, CR, maxGens)
    N = 50;
    lb = bounds(1);
    ub = bounds(2);

    pop = lb + (ub - lb) .* rand(N, n);
    history = zeros(maxGens, N, n);
    costs = zeros(maxGens, N);

    % Optimization loop
    last = inf;
    for gen = 1:maxGens
        history(gen, :, :) = pop;
        for i = 1:N
            %Choose three randoms
            indices = [1:i-1, i+1:N];
            idx = indices(randperm(length(indices), 3));
            y1 = pop(idx(1), :);
            y2 = pop(idx(2), :);
            y3 = pop(idx(3), :);

            %New individual
            new_ind = pop(i, :);
            p = randi([1 n]);
            for j = 1:n
                if j == p || rand() < CR
                    new_ind(j) = y1(j) + F * (y2(j) - y3(j));
                end
            end

            %Enforce bounds and select
            new_ind = min(max(new_ind, lb), ub);
            if fun(new_ind) < fun(pop(i, :))
                pop(i, :) = new_ind;
            end
        end
        costs(gen, :) = arrayfun(@(idx) fun(pop(idx, :)), 1:N);
        current = mean(costs(gen, :));

        %Check for convergence
        if abs(last - current) < 1e-10
            break;
        end
        last = current;
    end

    history = history(1:gen, :, :);
    costs = costs(1:gen, :);
     % Find the best solution in the final population
    [fbest, idx] = min(costs(gen, :));  % Min value and its index
    xbest = pop(idx, :);  % Best individual coordinates
    fbest = min(min(costs, [], 2));
    % worstValues = max(costs, [], 2);
    % avgValues = mean(costs, 2);
    % stdValues = std(costs, 0, 2);
    % 
    % fprintf('Summary with F= %.2f & CR= %.2f:\n', F, CR);
    % fprintf('Best Value: %.5f\n', min(bestValues));
    % fprintf('Worst Value: %.5f\n', max(worstValues));
    % fprintf('Average Value: %.5f\n', mean(avgValues));
    % fprintf('Std of Values: %.5f\n', mean(stdValues));
    % fprintf('Stopped at generation %.d\n',gen);
end