function Diff_Evolution(fun, n, bounds, F, CR)
    N = 100;
    maxGens = 50;
    lb = bounds(1);
    ub = bounds(2);

    pop = lb + (ub - lb) .* rand(N, n);

    costs = zeros(maxGens,100);

    % Optimization loop
    for gen = 1:maxGens
        for i = 1:N
            % Choose three random indices excluding the current index i
            indices = [1:i-1, i+1:N];
            idx = indices(randperm(length(indices), 3));
            y1 = pop(idx(1), :);
            y2 = pop(idx(2), :);
            y3 = pop(idx(3), :);
            
            %New individual
            new_ind = zeros(1, n);
            p = randi([1 n]);
            for j = 1:n
                r = rand();
                if j == p || r < CR
                    new_ind(j) = y1(j) + F * (y2(j) - y3(j));
                else
                    new_ind(j) = pop(i, j);
                end
                %Select
                if fun(new_ind) < fun(pop(i, :))
                    pop(i, :) = new_ind;
                end
            end
        end

        % Calculate best and worst cost in current generation
        costs(gen,:) = arrayfun(@(idx) fun(pop(idx, :)), 1:N);

        % fprintf('Generation %d: Best Cost = %.5f\n', gen, bestValues(gen));
    end
    bestValues = min(costs);
    worstValues = max(costs);
    avgValues = mean(costs);
    stdValues = std(costs);
    
    fprintf('\nSummary with F= %.2f & CR= %.2f:\n', F, CR);
    fprintf('Best Value: %.5f\n', min(bestValues));
    fprintf('Worst Value: %.5f\n', max(worstValues));
    fprintf('Average Value: %.5f\n', mean(avgValues));
    fprintf('Std of Values: %.5f\n', mean(stdValues));
end
