function MOEA(fun, bounds, N, generations, pc, pm, sigmas, dimensions, animate)
    % Initialize population within bounds
    population = initializePopulation(N, dimensions, bounds);
    history = zeros(generations,N,dimensions);
    if animate
        figure;
        hold on;
        scatter(population(:, 1), population(:, 2), 'b', 'filled');
        xlabel('Objective 1');
        ylabel('Objective 2');
        title('Population and Archive Visualization');
    end
    % Evolutionary loop
    for gen = 1:generations
        % Assess individuals
        ranks = paretoRanking(population, fun);

        % Selection and generation of offspring
        mating_pool = [];
        cnt = 1;
        for i = 1:2:N-1
            c1 = population(i,:);
            c2 = population(i+1,:);
            selected = tournamentSelection(population, c1, c2, i, ranks, N, sigmas);
            mating_pool(cnt,:) = selected; % Collect offspring
            cnt = cnt + 1;
        end
    
        offspring = crossoverAndMutation(mating_pool, pc, pm);

        % % Dynamic Sharing (if applicable)
        % applySharing(offspring, sigmas);

        % Update population
        population = [population; offspring];
        population = reducePopulation(population, N, ranks);

        % Archive non-dominated solutions
        archive = updateArchive(population, ranks);

        % % Visualization
        % if animate
        %     scatter(history(gen,:, 1), history(gen,:, 2), 'r', 'filled');
        % end
        % % Check termination condition
        % if convergenceCriteriaMet(archive)
        %     break;
        % end
        history(gen,:,:) = population;
    end
    if animate
        prevPopulationColor = 'b';
        for gen = 1:generations
            % Plot current generation
            scatter(history(gen,:,1), history(gen,:,2), prevPopulationColor, 'filled');
            pause(0.1); % Pause for visualization
            
            % Update previous color
            if strcmp(prevPopulationColor, 'b')
                prevPopulationColor = 'r';
            else
                prevPopulationColor = 'b';
            end
        end
    end
end

function population = initializePopulation(N, dimensions, bounds)
    population = zeros(N, dimensions);
    for i = 1:N
        for d = 1:dimensions
            population(i, d) = bounds(d,1) + (bounds(d,2) - bounds(d,1)) * rand();
        end
    end
end

% Tournament Selection Function
function s = tournamentSelection(population, c1, c2, idx, ranks, N, sigmas)
    comp_set = randi([1 N],1,(N/10));
    c1_dom = false; c2_dom = false;
    if any(ranks(idx)<ranks(comp_set))
        c1_dom = true;
    end
    if any(ranks(idx+1)<ranks(comp_set))
        c2_dom = true;
    end
    if c1_dom == c2_dom
        f1 = sharedFitness(c1,population(comp_set,:), sigmas);
        f2 = sharedFitness(c2,population(comp_set,:), sigmas);
        if f1 > f2
            s = c1;
        else
            s = c2;
        end
    else
        if c1_dom == false
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
    
    if size(population, 1) > N
        newPopulation = population(1:N, :);
    else
        newPopulation = population;
    end
end

function archive = updateArchive(population, ranks)
    nonDominatedIndices = find(ranks == 0);
    archive = population(nonDominatedIndices, :);
end

function visualizePopulation(population, archive)
      
    % Plot population
    scatter(population(:, 1), population(:, 2), 'b', 'filled');    
end

function offspring = crossoverAndMutation(parents, pc, pm)
    numParents = size(parents, 1);
    numVars = size(parents, 2);
    offspring = [];
    
    for i = 1:2:numParents-1
        if rand() < pc
            % Arithmetic crossover
            alpha = rand();
            child1 = alpha * parents(i,:) + (1-alpha) * parents(i+1,:);
            child2 = alpha * parents(i+1,:) + (1-alpha) * parents(i,:);
            offspring = [offspring; child1; child2];
        else
            offspring = [offspring; parents(i,:); parents(i+1,:)];
        end
    end
    
    % Mutation
    for i = 1:size(offspring, 1)
        if rand() < pm
            mutationPoint = randi(numVars);
            offspring(i, mutationPoint) = offspring(i, mutationPoint) + randn();
        end
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

