function [Pareto_front, Pareto_set] = MOEA(func1, func2, N, sigma_share, range, pc, pm, max_gens, dimensions)
    % Initialize population randomly within the given range
    Population = bsxfun(@plus, bsxfun(@times, rand(N, dimensions), (range(2) - range(1))), range(1));
    Pareto_front = [];
    Pareto_set = [];

    for k = 1:max_gens
        % Evaluate objective functions
        func_eval1 = arrayfun(@(j) func1(Population(j,:)), 1:N);
        func_eval2 = arrayfun(@(j) func2(Population(j,:)), 1:N);

        % Assign ranks using Pareto dominance
        [rank, isNonDominated] = paretoRank([func_eval1', func_eval2']);

        % Update Pareto front and set
        Pareto_front = [func_eval1(isNonDominated)', func_eval2(isNonDominated)'];
        Pareto_set = [Pareto_set; Population(isNonDominated, :)];

        % Perform tournament selection based on rank
        selected_indices = tournamentSelection(rank, N);
        matingPool = Population(selected_indices, :);

        % Generate offspring via crossover and mutation
        children = reproduce(matingPool, pc, pm, dimensions, range);

        % Replace the old population with new children
        Population = children;

        % Visualization of the population
        plotParetoFront(Population, Pareto_set, func1, func2, k);
    end
end

function [rank, isNonDominated] = paretoRank(vals)
    % Determine Pareto ranks and find non-dominated solutions
    N = size(vals, 1);
    rank = zeros(N, 1);
    isNonDominated = true(N, 1);

    for i = 1:N
        for j = 1:N
            if all(vals(i, :) >= vals(j, :)) && any(vals(i, :) > vals(j, :))
                rank(i) = rank(i) + 1;
                if rank(i) == 1
                    isNonDominated(i) = false;
                end
            end
        end
    end
end

function indices = tournamentSelection(rank, N)
    % Perform binary tournament selection
    indices = zeros(N, 1);
    for i = 1:N
        candidates = randperm(N, 2);
        if rank(candidates(1)) < rank(candidates(2))
            indices(i) = candidates(1);
        else
            indices(i) = candidates(2);
        end
    end
end

function children = reproduce(pool, pc, pm, dimensions, range)
    % Crossover and mutate to produce new children
    children = zeros(size(pool));
    for i = 1:size(pool, 1)
        % Simple one-point crossover
        if rand < pc
            point = randi([1, dimensions-1]);
            partner = mod(i + randi([1, size(pool, 1)-1]), size(pool, 1)) + 1;
            children(i, :) = [pool(i, 1:point), pool(partner, point+1:end)];
        else
            children(i, :) = pool(i, :);
        end

        % Mutation
        mutation_mask = rand(1, dimensions) < pm;
        mutation_amount = randn(1, dimensions) .* (range(2) - range(1)) / 10;
        children(i, :) = children(i, :) + mutation_mask .* mutation_amount;
    end
end

function plotParetoFront(Population, Pareto_set, func1, func2, generation)
    % Select figure with a specific identifier, create if it does not exist
    figure(1);  % Use a consistent figure number to prevent new windows
    clf;  % Clear the figure to refresh the plot
    
    % Evaluate the current population
    current_scores = [arrayfun(func1, Population), arrayfun(func2, Population)];
    
    % Evaluate the Pareto set (elitist individuals)
    if ~isempty(Pareto_set)
        pareto_scores = [arrayfun(func1, Pareto_set), arrayfun(func2, Pareto_set)];
    else
        pareto_scores = [];
    end
    
    hold on;
   
    % Plot current population as blue circles
    plot(current_scores(:,1), current_scores(:,2), 'bo', 'DisplayName', 'Current Population');
    
    % Plot Pareto set as red stars
    plot(pareto_scores(:,1), pareto_scores(:,2), 'r.', 'MarkerSize', 8, 'DisplayName', 'Pareto Set');
    
    % Add title, labels, and legend
    title(sprintf('Generation: %d', generation));
    xlabel('Function 1 Score');
    ylabel('Function 2 Score');
    legend show;
    
    % Adjust axis limits for better visualization
    xlim([0 1]);
    ylim([0 1]);
    
    hold off;
    drawnow;
end


