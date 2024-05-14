clear all; close all; clc;

% Objective functions definitions
ff1 = @(x) 1 - exp(-sum((x - 1/sqrt(8)).^2));
ff2 = @(x) 1 - exp(-sum((x + 1/sqrt(8)).^2));
ff_range = [-2, 2];  % Range for ff function

% Set parameters for the MOEA
N = 100;  % Number of individuals in the population
max_gens = 60;  % Maximum number of generations
dimensions = 2;  % Number of dimensions of the problem
pc = 0.1;  % Crossover probability
pm = 0.7;  % Mutation probability
sigma_share = 0.5; % Sharing radius

% Call the MOEA function
[Pareto_front, Pareto_set] = MOEA(ff1, ff2, N, ff_range, max_gens, dimensions, pc, pm, sigma_share);

% Optionally, display results
disp('Pareto front values:');
disp(Pareto_front);
disp('Pareto optimal set:');
disp(Pareto_set);

function [Pareto_front, Pareto_set] = MOEA(func1, func2, N, range, max_gens, dimensions, pc, pm, sigma_share)
    Population = bsxfun(@plus, bsxfun(@times, rand(N, dimensions), (range(2) - range(1))), range(1));
    Pareto_front = [];
    Pareto_set = [];

    for k = 1:max_gens
        func_eval1 = arrayfun(@(j) func1(Population(j,:)), 1:N);
        func_eval2 = arrayfun(@(j) func2(Population(j,:)), 1:N);
        [Pareto_front, Pareto_set] = updateParetoFront(Population, func_eval1, func_eval2);
        Population = reproduce(Population, func_eval1, func_eval2, dimensions, range, pc, pm, sigma_share, Pareto_set, N);
        plotParetoFront(Population, Pareto_set, func_eval1, func_eval2, func1, func2, k);
    end
end

function [Pareto_front, Pareto_set] = updateParetoFront(Population, func_eval1, func_eval2)
    dominated = false(size(Population, 1), 1);
    for i = 1:numel(dominated)
        for j = 1:numel(dominated)
            if all(func_eval1(i) <= func_eval1(j) & func_eval2(i) <= func_eval2(j)) && ...
               any(func_eval1(i) < func_eval1(j) | func_eval2(i) < func_eval2(j))
                dominated(j) = true;
            end
        end
    end
    Pareto_front = [func_eval1(~dominated)', func_eval2(~dominated)'];
    Pareto_set = Population(~dominated, :);
end

function new_population = reproduce(Population, func_eval1, func_eval2, dimensions, range, pc, pm, sigma_share, Pareto_set, N)
    new_population = zeros(size(Population));
    ranks = rankIndividuals(Population, func_eval1, func_eval2);
    for i = 1:size(Population, 1)
        if rand <= pc
            % Perform crossover
            idx = randi(size(Population, 1));
            parent1 = tournamentSelection(Population, Population(idx,:), ranks, N, sigma_share);
            parent2 = tournamentSelection(Population, Population(idx,:), ranks, N, sigma_share);
            crossover_point = randi([1, dimensions - 1]);
            new_population(i, :) = [parent1(1:crossover_point), parent2(crossover_point + 1:end)];
        else
            % No crossover, random individual
            new_population(i, :) = Population(i, :);
        end
        % Mutation
        for j = 1:dimensions
            if rand <= pm
                mutation_shift = (range(2) - range(1)) * 0.1 * randn;
                new_population(i, j) = new_population(i, j) + mutation_shift;
            end
        end
    end
end

function idx = tournamentSelection(Population, individual, ranks, N, sigma_share)
    competitors = randi(N, [1, N/10]);  % Select a random set of competitors
    individual_index = find(ismembertol(Population, individual, 1e-5, 'ByRows', true), 1);  % Robust floating point comparison
    rank_individual = ranks(individual_index);
    dominated = ranks(competitors) > rank_individual;
    
    if any(dominated)
        idx = competitors(find(dominated, 1));  % Select the first dominated competitor
    else
        idx = individual_index;  % If none dominated, select the individual itself
    end
    idx = Population(idx, :);  % Return the actual individual not the index
end

function ranks = rankIndividuals(Population, func_eval1, func_eval2)
    ranks = zeros(size(Population, 1), 1);
    for i = 1:size(Population, 1)
        for j = 1:size(Population, 1)
            if (func_eval1(j) < func_eval1(i) && func_eval2(j) < func_eval2(i))
                ranks(i) = ranks(i) + 1;
            end
        end
    end
end


function plotParetoFront(Population, Pareto_set, func_eval1, func_eval2, func1, func2, generation)
    figure(1); clf; hold on;
    scatter(func_eval1, func_eval2, 'bo');
    Pareto_scores1 = arrayfun(@(j) func1(Pareto_set(j,:)), 1:size(Pareto_set, 1));
    Pareto_scores2 = arrayfun(@(j) func2(Pareto_set(j,:)), 1:size(Pareto_set, 1));
    scatter(Pareto_scores1, Pareto_scores2, 'ro', 'MarkerFaceColor', 'r');
    title(sprintf('Pareto Front and Current Population at Generation %d', generation));
    xlabel('Objective 1'); ylabel('Objective 2');
    legend('Current Population', 'Pareto Front'); grid on;
    xlim([0 1]); ylim([0 1]);
    hold off; drawnow;
end


