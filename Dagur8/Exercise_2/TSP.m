function tsp_evolutionary_algorithm()
    N = 50; % Number of cities
    pop_size = 100; % Population size
    generations = 500; % Number of generations
    pc = 0.8; % Crossover probability
    pm = 0.2; % Initial mutation probability
    mutation_adjust_period = 20; % Period to adjust mutation rate
    
    % Generate random distances between cities
    city_locs = rand(N, 2) * 100;
    dist_matrix = squareform(pdist(city_locs));
    
    % Initialize population
    population = cell(1, pop_size);
    for i = 1:pop_size
        population{i} = randperm(N);
    end
    
    best_distance = inf;
    best_route = [];
    
    for gen = 1:generations
        % Evaluate
        [fitness, indices] = sort(cellfun(@(x) path_length(x, dist_matrix), population));
        if fitness(1) < best_distance
            best_distance = fitness(1);
            best_route = population{indices(1)};
        end
        
        % Selection (Tournament)
        mating_pool = tournament_selection(population, fitness, 3, ceil(pop_size/2));
        
        % Crossover
        new_population = cell(1, pop_size);
        for i = 1:2:length(mating_pool)-1
            if rand() < pc
                [new_population{i}, new_population{i+1}] = order_crossover(mating_pool{i}, mating_pool{i+1});
            else
                new_population{i} = mating_pool{i};
                new_population{i+1} = mating_pool{i+1};
            end
        end
        
        % Mutation
        for i = 1:pop_size
            if rand() < pm
                new_population{i} = mutate(new_population{i});
            end
        end
        
        % Adaptive mutation rate
        if mod(gen, mutation_adjust_period) == 0
            pm = adjust_mutation_rate(pm, fitness);
        end
        
        population = new_population;
    end
    
    % Visualization
    visualize_route(city_locs, best_route);
end

function len = path_length(route, dist_matrix)
    indices = [route route(1)];
    len = sum(dist_matrix(sub2ind(size(dist_matrix), indices(1:end-1), indices(2:end))));
end

function new_pm = adjust_mutation_rate(current_pm, fitness)
    diversity = std(fitness);
    if diversity < 0.1
        new_pm = current_pm * 1.1;
    else
        new_pm = current_pm * 0.9;
    end
end

function [child1, child2] = order_crossover(parent1, parent2)
    % Implementation of Order Crossover (OX)
    point1 = randi(length(parent1));
    point2 = mod(point1 + randi(length(parent1)), length(parent1)) + 1;
    if point2 < point1
        [point1, point2] = deal(point2, point1);
    end
    % Middle segment
    middle1 = parent1(point1:point2);
    middle2 = parent2(point1:point2);
    child1 = [parent1(~ismember(parent1, middle2)) middle2];
    child2 = [parent2(~ismember(parent2, middle1)) middle1];
end

function mutated = mutate(route)
    swap_indices = randperm(length(route), 2);
    mutated = route;
    mutated(swap_indices) = route(fliplr(swap_indices));
end

function visualize_route(locs, route)
    plot(locs(route, 1), locs(route, 2), 'o-');
    hold on;
    plot([locs(route(end), 1) locs(route(1), 1)], [locs(route(end), 2) locs(route(1), 2)], 'ro-');
    title('Best Route Found');
    xlabel('X Coordinate');
    ylabel('Y Coordinate');
    hold off;
end
