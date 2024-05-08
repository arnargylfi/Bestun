function [xbest, fbest, history, all_points, all_values] = smarterRandomSearch(f, n, bounds, kmax)
    % Initialize
    xbest = bounds(1) + (bounds(2) - bounds(1)) * rand(1, n);
    fbest = f(xbest);
    history = zeros(kmax, 1);
    all_points = zeros(kmax, n);
    all_values = zeros(kmax, 1);   
    all_points(1, :) = xbest;
    all_values(1) = fbest;
    history(1) = fbest;

    % Parameters for adaptive strategy
    noImprovementStreak = 0;
    maxStreak = 50; % Max number of iterations without improvement to trigger larger steps
    localSearchProb = 0.1; % Probability of switching to local search mode

    for k = 2:kmax
        if rand < localSearchProb && noImprovementStreak > 10
            % Local search around the current best
            stepSize = 0.01 * (bounds(2) - bounds(1)); % Smaller, more precise step size
            xnew = xbest + stepSize * (2 * rand(1, n) - 1);
        else
            % Normal global search
            stepSize = 0.1 * (bounds(2) - bounds(1));
            stepSize = stepSize * (1 + 0.05 * noImprovementStreak); % Increase step size based on streak
            xnew = bounds(1) + (bounds(2) - bounds(1)) * rand(1, n);
            xnew = xnew * (1 - k/kmax) + xbest * (k/kmax); % Gradual shift from global to local
        end

        xnew = max(min(xnew, bounds(2)), bounds(1)); % Keep within bounds
        fnew = f(xnew);

        all_points(k, :) = xnew;
        all_values(k) = fnew;
        history(k) = fbest;

        if fnew < fbest
            xbest = xnew;
            fbest = fnew;
            noImprovementStreak = 0; % Reset streak counter
        else
            noImprovementStreak = noImprovementStreak + 1;
        end
    end
end