function [meanBest, stdBest, maxBest, minBest] = evaluate_algorithm(algorithm, func, n, bounds, kmax, n_runs, true_min, F, CR)
    bestValues = zeros(n_runs, 1);
    for run = 1:n_runs
        [~, fbest, ~] = algorithm(func, n, bounds, F, CR, kmax);
        bestValues(run) = fbest; % Absolute error from the true minimum
    end
    meanBest = mean(bestValues);
    stdBest = std(bestValues);
    minBest = min(bestValues);
    maxBest = max(bestValues);
end