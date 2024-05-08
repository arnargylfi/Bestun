function [meanBest, stdBest, maxBest, minBest] = evaluate_algorithm(algorithm, func, n, bounds, kmax, n_runs, true_min)
    bestValues = zeros(n_runs, 1);
    for run = 1:n_runs
        [~, fbest, ~, ~, ~] = algorithm(func, n, bounds, kmax);
        bestValues(run) = abs(fbest - true_min); % Absolute error from the true minimum
    end
    meanBest = mean(bestValues);
    stdBest = std(bestValues);
    minBest = min(bestValues);
    maxBest = max(bestValues);
end