function [xbest, fbest] = GAFP(func,N,tournament_size,range,pc,pm,max_gens,dimensions)




pm0 = pm;
Population = rand(N, dimensions) * (range(2) - range(1)) + range(1); % Random initialization between -ub and lb
function_evaluations = 0;
fbest = Inf;

if dimensions == 2
    xplot = linspace(range(1), range(2), 400);
    yplot = linspace(range(1), range(2), 400);
    [X, Y] = meshgrid(xplot, yplot);
    Z = arrayfun(@(ix, iy) func([ix, iy]), X, Y); 

    figure;
    contour(X, Y, Z, 20);
    colorbar
    hold on;
    pop = scatter(Population(:, 1), Population(:, 2), 50, 'x', 'r');
end

xbest = [0 0];
for k = 1:max_gens
    %tournament selection:
    if dimensions ==2
        set(pop,'MarkerEdgeColor','black','SizeData',10)
        pop = scatter(Population(:, 1), Population(:, 2), 80, 'x', 'r','LineWidth',1.2);
        best = scatter(xbest(1), xbest(2),150, 'o','Color',"#EDB120",'LineWidth',2);
        pause(0.2)
        set(best,'Visible','Off')
    end

    parents = zeros(N,dimensions);
    for i = 1:N
        %Select tournament_size number of random indeces between one and population size
        individuals = randperm(length(Population),tournament_size);
        %evaluate the function for each of the chosen individuals, negative because the fitness is worse the higher the function value is
        Population(individuals,:);
        func_eval = arrayfun(@(j) func(Population(j,:)), individuals);
        function_evaluations = function_evaluations+tournament_size*dimensions;
        [fbestnow, most_fit_index] = min(func_eval);
        if fbestnow < fbest
            fbest = fbestnow;
            xbest = Population(individuals(most_fit_index),:);
        end
        
        parents(i,:) = Population(individuals(most_fit_index),:);
    end
    %cross over each child
    children = zeros(N,dimensions);
    for i = 1:N-2
            children(i,:) = crossover(parents(i,:),parents(i+1,:),pc);
    end
    
    %mutate children
    mutant_children = zeros(size(children));
    %ADJUST MUTATION RATE
    pop_diversity = std(Population(:));
    if k < max_gens/2
        if pop_diversity <0.2
            pm = pm*1.3;
        else
            pm = pm/1.2;
        end
    else
        pm = pm0*(2*(max_gens-k)/max_gens)^2;
    end
    for i = 1:length(children)
        mutant_children(i,:) = mutate(children(i,:),pm);
    end
    Population = mutant_children;
    Population(1,:) = xbest;
    fprintf('Iteration: %d, function evaluations: %d xbest: %s, fbest: %f\n',k,function_evaluations,mat2str(xbest),fbest)
end

if dimensions == 2
scatter(xbest(1), xbest(2),150, 'o','Color',"#EDB120",'LineWidth',2);
end

function child = crossover(parent1, parent2, pc)
    alpha = rand(size(parent1));
    alpha(alpha > pc) = 0;
    
    child = alpha .* parent1 + (1 - alpha) .* parent2;
end

%Mutation operator for floating point slide 12
function mutant = mutate(individual,pm)
    r = rand(1,length(individual));
    r_larger_than05 = r>0.5;
    mutate_these = rand(1,length(individual))<pm;
    beta =4;
    mutant = individual...
             + mutate_these.*(r_larger_than05.*(max(individual)-individual).*(2*(r-0.5)).^beta...
             + ~r_larger_than05.*(min(individual)-individual).*(2*(0.5-r)).^beta); 
    
end



end
