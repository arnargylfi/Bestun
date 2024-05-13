% Parameters
populationSize = 100;
numGenerations = 200;
pc = 0.7;
pm = 0.1;
sigmas = 0.5; % Sharing distance
% MOEA entry point
function MOEA(fun, bounds, N, generations, pc, pm, sigmas, dimensions)
    % Initialize population within bounds
    population = initializePopulation(N, dimensions, bounds)

    % Evolutionary loop
    for gen = 1:generations
        % Assess individuals
        ranks = paretoRanking(population, fun);

        % Selection and generation of offspring
        offspring = [];
        cnt = 1;
        for i = 1:2:N-1
            c1 = population(i,:);
            c2 = population(i+1,:);
            selected = tournamentSelection(c1, c2, i, ranks, N, sigmas);
            offspring(cnt) = selected; % Collect offspring
            cnt = cnt + 1;
        end

        % % Dynamic Sharing (if applicable)
        % applySharing(offspring, sigmas);

        % Update population
        population = [population; offspring];
        population = reducePopulation(population, N);

        % Archive non-dominated solutions
        archive = updateArchive(population);

        % Visualization
        visualizePopulation(population, archive);

        % Check termination condition
        if convergenceCriteriaMet(archive)
            break;
        end
    end
end

function population = initializePopulation(N, dimensions, bounds)
    population = zeros(N, dimensions);
    for i = 1:N
        for d = 1:dimensions
            population(i, d) = bounds(1, d) + (bounds(2, d) - bounds(1, d)) * rand();
        end
    end
end

% Tournament Selection Function
function s = tournamentSelection(c1, c2, i, ranks, N, sigmas)
    comp_set = randi([0 N],1,(N/10));
    c1_dom = false; c2_dom = false;
    if any(ranks(i)<ranks(comp_set))
        c1_dom = true;
    end
    if any(ranks(i+1)<ranks(comp_set))
        c2_dom = true;
    end
    if c1_dom == c2_dom
        f1 = sharedFitness(c1,comp_set, sigmas);
        f2 = sharedFitness(c2,comp_set, sigmas);
        if f1 > f2
            s = c1;
        else
            s = c2;
        end
    else
        if c1_dominated == false
            s = c1;
        else
            s = c2;
        end
    end
end

% Shared Fitness Function
function fitness = sharedFitness(individual, population, sigma_share)
    alpha = 1; % Decay coefficient
    distances = pdist2(individual, population);
    sh = sum((1 - (distances / sigma_share).^alpha) .* (distances < sigma_share));
    if sh == 0
        sh = 1; % To avoid division by zero
    end
    fitness = 1 / sh; % Simplified shared fitness
end

function ranks = paretoRanking(population, fun)
    numIndividuals = size(population, 1);
    ranks = zeros(numIndividuals, 1);
    
    for i = 1:numIndividuals
        for j = 1:numIndividuals
            if i ~= j && dominates(fun, population(j,:), population(i,:))
                ranks(i) = ranks(i) + 1;
            end
        end
    end
end

% Dominance Function
function isDom = dominates(fun, ind1, ind2)
    results1 = evaluateObjectives(ind1, fun);
    results2 = evaluateObjectives(ind2, fun);
    isDom = all(results1 <= results2) && any(results1 < results2);
end

% Objective Evaluation
function results = evaluateObjectives(individual, fun)
    results = fun(individual);
end

function newPopulation = reducePopulation(population, N, ranks)
    [~, sortedIndices] = sort(ranks);
    population = population(sortedIndices, :);
    
    if size(population, 1) > maxSize
        newPopulation = population(1:maxSize, :);
    else
        newPopulation = population;
    end
end


% function sharedFitness = dynamicSharing(population, ranks, sigmaShare)
%     numIndividuals = size(population, 1);
%     distances = pdist2(population, population);
%     sharedFitness = zeros(numIndividuals, 1);
% 
%     for i = 1:numIndividuals
%         sh = sum((1 - (distances(i,:) / sigmaShare).^2) .* (distances(i,:) < sigmaShare));
%         if sh == 0
%             sh = 1; % To avoid division by zero
%         end
%         sharedFitness(i) = 1 / (ranks(i) + 1) / sh;
%     end
% end

