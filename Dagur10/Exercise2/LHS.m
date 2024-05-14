function samples = LHS(N, bounds)    
    n = size(bounds, 1);
    samples = zeros(N, n);
    %loop over all dimensions
    for i = 1:n
        lower = bounds(i, 1);
        upper = bounds(i, 2);
        intervals = linspace(lower, upper, N + 1);
        perm = randperm(N);
        %loop over number of samples
        for j = 1:N
            samples(j, i) = (intervals(perm(j)) + intervals(perm(j) + 1)) / 2 ...
                            + (intervals(perm(j) + 1) - intervals(perm(j))) * (rand() - 0.5);
        end
    end
    samples = samples(randperm(N), :);
end