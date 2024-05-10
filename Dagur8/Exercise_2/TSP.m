function [population, best_distance, best_route] = tsp_evolutionary_algorithm(N, generations, pc, pm, mutation_adjust_period, crossover, animate)
    pop_size = N;
    hold on
    city_locs = rand(N, 2) * 100;
    dist_matrix = create_distance_matrix(city_locs);
    
    population = cell(1, pop_size);
    for i = 1:pop_size
        population{i} = randperm(N);
    end
    
    best_distance = inf;
    best_route = [];
    best_distances = zeros(generations, 1);
    average_fitness = zeros(generations, 1);
    
    for gen = 1:generations
        % Evaluate
        fitness = cellfun(@(x) path_length(x, dist_matrix), population);
        [sorted_fitness, indices] = sort(fitness);
        average_fitness(gen) = mean(fitness);
        if sorted_fitness(1) < best_distance
            best_distance = sorted_fitness(1);
            best_route = population{indices(1)};
            if animate
                visualize_route(city_locs, best_route, gen, N);
                pause(0.1); % Pause for a brief moment to allow visualization to be seen
            end
        end
        best_distances(gen) = best_distance;
        
        % Selection (Tournament)
        mating_pool = tournament_selection(population, fitness, 3, ceil(pop_size/2));
        
        % Crossover
        new_population = population;
        for i = 1:2:length(mating_pool)-1
            if rand() < pc
                switch crossover
                    case 0
                        [new_population{i}, new_population{i+1}] = crossover(mating_pool{i}, mating_pool{i+1}, pc);
                    case 1
                        [new_population{i}, new_population{i+1}] = crossover2(mating_pool{i}, mating_pool{i+1}, pc);
                    case 2
                        [new_population{i}, new_population{i+1}] = OXcrossover(mating_pool{i}, mating_pool{i+1});
                end
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
        % Eliteism
        if best_distance < sorted_fitness(end)
            new_population{indices(end)} = best_route;
        end        

        % Adaptive mutation rate
        if mod(gen, mutation_adjust_period) == 0
            pm = adjust_mutation_rate(pm, new_population);
        end
        population = new_population;
        % disp(['Generation ', num2str(gen), ': Best Distance = ', num2str(best_distance), ', Average Fitness = ', num2str(average_fitness(gen))]);
        % 
    end
    disp(['Generation ', num2str(gen), ': Best Distance = ', num2str(best_distance), ', Average Fitness = ', num2str(average_fitness(gen))]);
    if animate        
        %Plotting convergence for debugging and to monitor if changes are
        %benefitial
        figure;
        subplot(2,1,1);
        plot(best_distances);
        title('Best Distance over Generations, best distance overall: ',best_distance);
        xlabel('Generation');
        ylabel('Best Distance');
        
        subplot(2,1,2);
        plot(average_fitness);
        title('Average Fitness over Generations');
        xlabel('Generation');
        ylabel('Fitness (Distance)');
    end
end

function len = path_length(route, dist_matrix)
    if any(route < 1 | route > size(dist_matrix, 1))
        disp(route);
        disp(size(dist_matrix))
        error('Invalid route: indices out of bounds');
    end
    indices = [route, route(1)];  % Close the route
    len = sum(dist_matrix(sub2ind(size(dist_matrix), indices(1:end-1), indices(2:end))));
end

function dist_matrix = create_distance_matrix(locs)
    n = size(locs, 1);
    dist_matrix = zeros(n, n);
    for i = 1:n
        for j = i+1:n
            dist_matrix(i, j) = sqrt(sum((locs(i,:) - locs(j,:)).^2));
            dist_matrix(j, i) = dist_matrix(i, j);
        end
    end
end

function new_pm = adjust_mutation_rate(current_pm, P)
    diversity = population_diversity(P);
    if diversity < 0.1
        new_pm = current_pm * 1.2;
    else
        new_pm = current_pm * 0.9;
    end
end

function [child1, child2] = OXcrossover(parent1, parent2)
    n = length(parent1);
    point1 = randi(n);
    point2 = randi(n);
    while point1 == point2
        point2 = randi(n);
    end
    if (point2 < point1)
        [point1, point2] = deal(point2, point1);
    end
    child1 = zeros(size(parent1));
    child2 = zeros(size(parent1));
    child1(point1:point2) = parent1(point1:point2);
    child2(point1:point2) = parent1(point1:point2);
    % Fill in the rest of child1
    fill_index = 1;
    for i = 1:n
        if ~ismember(parent1(i), child1)
            while child1(fill_index) ~= 0
                fill_index = mod(fill_index, n) + 1;
                if fill_index == 0  % To handle wrap-around correctly
                    fill_index = 1;
                end
            end
            child1(fill_index) = parent1(i);
        end
    end

    % Fill in the rest of child2
    fill_index = 1;
    for i = 1:n
        if ~ismember(parent2(i), child2)
            while child2(fill_index) ~= 0
                fill_index = mod(fill_index, n) + 1;
                if fill_index == 0  % To handle wrap-around correctly
                    fill_index = 1;
                end
            end
            child2(fill_index) = parent2(i);
        end
    end 
end

function [child1, child2] = crossover(parent1, parent2, pc)
    n = length(parent1);
    num_swaps = floor(pc * n / 5);

    child1 = parent1;
    child2 = parent2;

    swap_indices = randperm(n, num_swaps);

    for idx = swap_indices
        % Get the values from parents
        value1 = parent1(idx);
        value2 = parent2(idx);

        % Find the positions in child1
        pos1_child1 = find(child1 == value1, 1);
        pos2_child1 = find(child1 == value2, 1);

        % Swap these values in child1
        child1(pos1_child1) = value2;
        child1(pos2_child1) = value1;

        % Same for child
        pos1_child2 = find(child2 == value1, 1);
        pos2_child2 = find(child2 == value2, 1);
        child2(pos2_child2) = value1;
        child2(pos1_child2) = value2;
    end
end

function [child1, child2] = crossover2(parent1, parent2, pc)
    n = length(parent1);
    num_swaps = randi(floor(n/2));

    child1 = zeros(1, n);
    child2 = zeros(1, n);

    % Place the selected elements from each parent into the corresponding positions in the children
    child1(1:num_swaps) = parent1(1:num_swaps);
    child2(1:num_swaps) = parent2(1:num_swaps);

    % Remaining indices start from num_swaps+1 to n
    remaining_indices = (num_swaps + 1):n;

    % Fill in the remaining positions in child1 with the remaining values from parent2
    % Using setdiff to find values in parent2 not yet in child1, preserving order
    remaining_values_child1 = setdiff(parent2, child1(1:num_swaps), 'stable');
    child1(remaining_indices) = remaining_values_child1;

    % Fill in the remaining positions in child2 with the remaining values from parent1
    % Using setdiff to find values in parent1 not yet in child2, preserving order
    remaining_values_child2 = setdiff(parent1, child2(1:num_swaps), 'stable');
    child2(remaining_indices) = remaining_values_child2;
end



function route = mutate(route)
    n = length(route);
    swap_indices = randperm(n, 2);
    temp = route(swap_indices(1));
    route(swap_indices(1)) = route(swap_indices(2));
    route(swap_indices(2)) = temp;
end


function S = population_diversity(P)
    N = length(P);
    n = length(P{1});
    for j = 1:n
        for k = 1:N
            L(k) = P{k}(j);
        end
        R(j) = std(L);
    end
    S = sum(R)/n;
end

function mating_pool = tournament_selection(population, fitness, tournament_size, num_parents)
    % Initialize
    mating_pool = cell(1, num_parents);
    num_individuals = length(population);

    for i = 1:num_parents
        % Select random individuals
        indices = randperm(num_individuals, tournament_size);
        tournament = population(indices);
        tournament_fitness = fitness(indices);

        % Find the best individual and add to mating pool
        [~, best_index] = min(tournament_fitness);
        mating_pool{i} = tournament{best_index};
    end
end

function visualize_route(locs, route, gen, N)
    clf; % Clear the current figure
    hold on;
    plot(locs(route, 1), locs(route, 2), 'o-');
    plot([locs(route(end), 1) locs(route(1), 1)], [locs(route(end), 2) locs(route(1), 2)], 'ro-');
    title(sprintf('Best Route Found for N=%d, Generation: %d', N, gen));
    xlabel('X Coordinate');
    ylabel('Y Coordinate');
    drawnow; % Force MATLAB to draw the updated plot
end
