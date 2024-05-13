clear all; close all; clc;

% Objective functions definitions
ff1 = @(x) 1 - exp(-sum((x - 1/sqrt(8)).^2));
ff2 = @(x) 1 - exp(-sum((x + 1/sqrt(8)).^2));
ff_range = [-2, 2];  % Range for ff function

% Set parameters for the MOEA
N = 100;  % Number of individuals in the population
max_gens = 50;  % Maximum number of generations
dimensions = 2;  % Number of dimensions of the problem

% Call the MOEA function
[Pareto_front, Pareto_set] = MOEA(ff1, ff2, N, ff_range, max_gens, dimensions);

% Optionally, display results
disp('Pareto front values:');
disp(Pareto_front);
disp('Pareto optimal set:');
disp(Pareto_set);

function [Pareto_front, Pareto_set, allPareto_sets] = MOEA(func1, func2, N, range, max_gens, dimensions)
    % Initialize population randomly within the given range
    Population = bsxfun(@plus, bsxfun(@times, rand(N, dimensions), (range(2) - range(1))), range(1));
    Pareto_front = [];
    Pareto_set = [];
    allPareto_sets = [];  % Initialize to store all non-dominated solutions across generations

    for k = 1:max_gens
        % Evaluate objective functions
        func_eval1 = arrayfun(@(j) func1(Population(j,:)), 1:N);
        func_eval2 = arrayfun(@(j) func2(Population(j,:)), 1:N);

        % Assign ranks and update Pareto front and set
        [Pareto_front, Pareto_set] = updateParetoFront(Population, func_eval1, func_eval2);
        allPareto_sets = [allPareto_sets; Pareto_set];  % Accumulate all non-dominated solutions

        % Selection and reproduction
        [Population] = reproduce(Population, func_eval1, func_eval2, dimensions, range);

        % Visualization of the population
        plotParetoFront(Population, allPareto_sets, func_eval1, func_eval2, func1, func2, k);

    end
end

function [Pareto_front, Pareto_set] = updateParetoFront(Population, func_eval1, func_eval2)
    num_individuals = size(Population, 1);
    dominated = false(num_individuals, 1);  % Boolean array to track dominance

    for i = 1:num_individuals
        for j = 1:num_individuals
            if i ~= j
                if all(func_eval1(i) <= func_eval1(j) & func_eval2(i) <= func_eval2(j)) && ...
                   any(func_eval1(i) < func_eval1(j) | func_eval2(i) < func_eval2(j))
                    dominated(j) = true;  % j is dominated by i
                end
            end
        end
    end

    non_dominated_indices = ~dominated;
    Pareto_front = [func_eval1(non_dominated_indices)', func_eval2(non_dominated_indices)'];
    Pareto_set = Population(non_dominated_indices, :);
end


function [new_population] = reproduce(Population, func_eval1, func_eval2, dimensions, range)
    % Parameters for crossover and mutation
    pc = 0.7;  % Probability of crossover
    pm = 0.1;  % Probability of mutation
    new_population = zeros(size(Population));
    combined_eval = (func_eval1 + func_eval2) / 2;  % Simple average, adjust weighting as necessary

    for i = 1:size(Population, 1)
        if rand <= pc
            % Perform crossover
            parent1 = Population(tournamentSelect(combined_eval), :);
            parent2 = Population(tournamentSelect(combined_eval), :);
            crossover_point = randi([1, dimensions - 1]);
            new_population(i, :) = [parent1(1:crossover_point), parent2(crossover_point + 1:end)];
        else
            % No crossover, random individual
            new_population(i, :) = Population(tournamentSelect(combined_eval), :);
        end

        % Mutation with probability pm
        for j = 1:dimensions
            if rand <= pm
                mutation_shift = (range(2) - range(1)) * 0.1 * randn;
                new_population(i, j) = new_population(i, j) + mutation_shift;
            end
        end
    end
end


function idx = tournamentSelect(func_eval)
    % Binary tournament selection
    candidate1 = randi(numel(func_eval));
    candidate2 = randi(numel(func_eval));
    if func_eval(candidate1) < func_eval(candidate2)
        idx = candidate1;
    else
        idx = candidate2;
    end
end


function plotParetoFront(Population, allPareto_sets, func_eval1, func_eval2, func1, func2, generation)
    % Visualization of the current population and the Pareto front
    figure(1); clf;
    hold on;
    % Plot current population
    scatter(func_eval1, func_eval2, 'bo');
    % Plot Pareto front
    Pareto_scores1 = arrayfun(@(j) func1(allPareto_sets(j,:)), 1:size(allPareto_sets, 1));
    Pareto_scores2 = arrayfun(@(j) func2(allPareto_sets(j,:)), 1:size(allPareto_sets, 1));
    scatter(Pareto_scores1, Pareto_scores2, 'ro', 'MarkerFaceColor', 'r');
    
    title(sprintf('Pareto Front and Current Population at Generation %d', generation));
    xlabel('Objective 1');
    ylabel('Objective 2');
    legend('Current Population', 'Pareto Front');
    grid on;
    xlim([0 1]);
    ylim([0 1]);
    hold off;
    drawnow;
end