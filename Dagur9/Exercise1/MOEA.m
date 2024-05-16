function [Pareto_front, Pareto_set] = MOEA(objective_funcs, dimensions, bounds, N, max_gens, pc, pm, sigma_share, sigma_m, plotxlim, plotylim, share_res, mate_res)
    % Initialize population
    Population = initialize_population(N, dimensions, bounds);
    Pareto_front = [];
    Pareto_set = [];
    archive_set = [];
    p = zeros(max_gens, 1);
    figure;
    
    for gen = 1:max_gens
        % Evaluate population
        Obj_values = evaluate_population(Population, objective_funcs);
        
        % Update Pareto front and Pareto set
        [Pareto_front, Pareto_set] = update_pareto_front(Population, Obj_values);

        % Archive non-dominated individuals
        % [archive_front,archive_set] = update_archive(archive_set, Population, Obj_values);
        if share_res
            [archive_front,archive_set] = update_archive_shared_fitness(archive_set, Population, Obj_values, sigma_share);
        else
            [archive_front,archive_set] = update_archive(archive_set, Population, Obj_values);
        end
        Population(1:size(archive_set,1),:) = archive_set; 
        Population = Population(1:N,:);

        % Selection with Pareto dominance tournament
        mating_pool = selection(Population, Obj_values, sigma_m, mate_res);
        
        % Crossover and mutation
        Offspring = crossover_and_mutation(mating_pool, pc, pm, bounds);
        Population = Offspring;

        % Dynamic sharing adjustment
        sigma_share = dynamic_sharing(sigma_share, Pareto_front, N);
        sigma_m = dynamic_sharing(sigma_m, Pareto_front, N);
        % % Convergence measure
        % if gen > 1
        %     p(gen) = convergence_measure(Pareto_front, prev_pareto_front);
        % end
        % prev_pareto_front = Pareto_front;
        N_nondom_current = size(archive_front, 1);
        if gen > 1
            p(gen) = convergence_measure_p(N_nondom_current, N_nondom_prev);
        end
        N_nondom_prev = N_nondom_current;
        
        % Plot current generation
        clf;
        hold on;
        grid on
        % scatter(Obj_values(:, 1), Obj_values(:, 2), 'bo');
        scatter(Pareto_front(:, 1), Pareto_front(:, 2), 'ro');
        scatter(archive_front(:, 1), archive_front(:, 2), 'go', 'filled');
        xlim(plotxlim);
        ylim(plotylim);
        title(sprintf('Generation %d', gen));
        xlabel('Objective 1');
        ylabel('Objective 2');
        drawnow;
        hold off;
        
        % Termination condition based on convergence measure
        if gen > 1 && (abs(p(gen)-1)) < 0.001
            break;
        end
    end
end

function Population = initialize_population(N, dimensions, bounds)
    Population = zeros(N, dimensions);
    for i = 1:dimensions
        Population(:, i) = bounds(i, 1) + (bounds(i, 2) - bounds(i, 1)) * rand(N, 1);
    end
end

function Obj_values = evaluate_population(Population, objective_funcs)
    N = size(Population, 1);
    Obj_values = zeros(N, 2);
    for i = 1:N
        Obj_values(i, :) = objective_funcs(Population(i, :));
    end
end

function [Pareto_front, Pareto_set] = update_pareto_front(Population, Obj_values)
    N = size(Population, 1);
    dominated = false(N, 1);
    for i = 1:N
        for j = 1:N
            if i ~= j
                if all(Obj_values(i, :) <= Obj_values(j, :)) && any(Obj_values(i, :) < Obj_values(j, :))
                    dominated(j) = true;
                end
            end
        end
    end
    non_dominated_indices = ~dominated;
    Pareto_front = Obj_values(non_dominated_indices, :);
    Pareto_set = Population(non_dominated_indices, :);
end

function [archive_front,archive_set] = update_archive(archive_set, Population, Obj_values)
    % Add current non-dominated individuals to archive
    [~, current_pareto_set] = update_pareto_front(Population, Obj_values);
    archive_set = [archive_set; current_pareto_set];
    archive_obj_values = evaluate_population(archive_set, @ff);
    % Remove dominated individuals from archive
    [archive_pareto_front, ~] = update_pareto_front(archive_set, archive_obj_values);
    archive_front = archive_pareto_front;
end

function [archive_front, archive_set] = update_archive_shared_fitness(archive_set, Population, Obj_values, sigma_share)
    % Add current non-dominated individuals to archive
    [current_pareto_front, current_pareto_set] = update_pareto_front(Population, Obj_values);
    archive_set = [archive_set; current_pareto_set];
    archive_obj_values = evaluate_population(archive_set, @ff);

    % Calculate shared fitness values
    fitness_shared = shared_fitness(archive_obj_values, sigma_share);
    [~, sorted_indices] = sort(fitness_shared, 'descend');
    archive_set = archive_set(sorted_indices, :);
    archive_front = evaluate_population(archive_set, @ff);
    % Remove dominated individuals from archive
    [archive_pareto_front, ~] = update_pareto_front(archive_set, archive_obj_values);
    archive_front = archive_pareto_front;
end

function fitness_shared = shared_fitness(Obj_values, sigma_share)
    N = size(Obj_values, 1);
    fitness_shared = ones(N, 1);
    for i = 1:N
        for j = 1:N
            if i ~= j
                distance = norm(Obj_values(i, :) - Obj_values(j, :));
                if distance < sigma_share
                    fitness_shared(i) = fitness_shared(i) + 1 - (distance / sigma_share)^2;
                end
            end
        end
    end
end

function mating_pool = selection(Population, Obj_values, sigma_m, mate_res)
    N = size(Population,1);
    mating_pool = zeros(size(Population));
    for i = 1:2:N
        parents = tournament_selection(Population, Obj_values, sigma_m, mate_res);
        mating_pool(i:i+1, :) = parents();
    end
end

function parents = tournament_selection(Population, Obj_values, sigma_m)
    % Select two candidates
    N = size(Population, 1);
    candidate1 = randi(N);
    if mate_res
        for i=1:N
            candidate2 = randi(N);
            mating_range = pdist2(Obj_values(candidate1), Obj_values(candidate2));
            if mating_range <= sigma_m
                break;
            end
        end
    else
        candidate2 = randi(N);
    end
    
    if dominates(Obj_values(candidate1, :), Obj_values(candidate2, :))
        parents = Population(candidate1, :);
        parents = [parents; Population(randi(size(Population, 1)), :)]; % Ensure two parents
    elseif dominates(Obj_values(candidate2, :), Obj_values(candidate1, :))
        parents = Population(candidate2, :);
        parents = [parents; Population(randi(size(Population, 1)), :)]; % Ensure two parents
    else
        parents = Population(candidate_indices, :);
    end
end

function is_dominating = dominates(obj1, obj2)
    is_dominating = all(obj1 <= obj2) && any(obj1 < obj2);
end

function Offspring = crossover_and_mutation(mating_pool, pc, pm, bounds)
    N = size(mating_pool, 1);
    dimensions = size(mating_pool, 2);
    Offspring = zeros(N, dimensions);
    for i = 1:N
        if rand < pc
            parent1 = mating_pool(randi([1, N]), :);
            parent2 = mating_pool(randi([1, N]), :);
            alpha = rand;
            Offspring(i, :) = alpha * parent1 + (1 - alpha) * parent2;
        else
            Offspring(i, :) = mating_pool(i, :);
        end
        
        for j = 1:dimensions
            if rand < pm
                Offspring(i, j) = Offspring(i, j) + (bounds(j, 2) - bounds(j, 1)) * randn;
                Offspring(i, j) = min(max(Offspring(i, j), bounds(j, 1)), bounds(j, 2));
            end
        end
    end
end

function sigma_share = dynamic_sharing(sigma_share, Pareto_front, N)
    d_max = max(pdist(Pareto_front));
    d_min = min(pdist(Pareto_front));
    d_avg = (d_max + d_min) / 2;
    sigma_share = (N^(1 / (1 - size(Pareto_front, 2)))) * d_avg / 2;
end

function conv_measure = convergence_measure(current_pareto, prev_pareto)
    % Compute the set difference in the Pareto fronts to get the convergence measure
    current_size = size(current_pareto, 1);
    prev_size = size(prev_pareto, 1);
    diff_matrix = zeros(current_size, prev_size);
    for i = 1:current_size
        for j = 1:prev_size
            diff_matrix(i, j) = norm(current_pareto(i, :) - prev_pareto(j, :));
        end
    end
    conv_measure = mean(min(diff_matrix, [], 2));
end

function p = convergence_measure_p(N_nondom_k, N_nondom_k_1)
    if N_nondom_k_1 == 0
        p = 1;
    else
        p = N_nondom_k / N_nondom_k_1;
    end
end
