function paretoset = GAFP(func1,func2,N,tournament_size,range,pc,pm,max_gens,dimensions)




pm0 = pm;
Population = rand(N, dimensions) * (range(2) - range(1)) + range(1); % Random initialization between -ub and lb

function_evaluations = 0;
alpha = rand;
xbest = [0 0];
m = 1.5;
paretoset = [];
for k = 1:max_gens
    %Dominance ranking
    func_eval1 = arrayfun(@(j) func1(Population(j,:)), 1:N);
    func_eval2 = arrayfun(@(j) func2(Population(j,:)), 1:N);
    rank = zeros(N,1);
    for i = 1:N
        rank(i) = 1+sum(func_eval1 < func_eval1(i) & func_eval2<func_eval2(i));
    end
    paretosetindex = find(rank==1);
    for i = 1:length(paretosetindex)
        paretoset = [paretoset;func_eval1(paretosetindex(i)),func_eval2(paretosetindex(i))];
    end

    fitness = 1./rank;

    %Distances
    Distances = zeros(N);
    for i = 1:N
        for j = i:N
            Distances(i,j) = norm([func_eval1(i),func_eval2(i)]-[func_eval1(j),func_eval2(j)]);
        end
    end
   Distances = Distances+Distances'; %geri symmetrical
   %DYNAMIC SHARING SIGMA CALC
   [d_min,max_dist_index] = max(Distances(:));
   [Fx, Fy] = ind2sub(size(Distances), max_dist_index); % Convert linear index to row and column indices
   d_max = abs(func_eval2(Fx)-func_eval2(Fy))+abs(func_eval1(Fx)-func_eval1(Fy));
   d = (d_max+d_min)/2;
   sigma = 0.5*d*N^(1/(1-2.5));
   sigma_mate = 3*sigma;
   %FITNESS SHARING
   SF = Distances<sigma;
   SF = SF.*(1-(Distances./sigma).^alpha);
   f_shared = fitness./sum(SF,2);
   
    %TOURNAMENT SELECTION
    parents = zeros(N,1);
    for i = 1:N
        comp_set = randperm(length(Population),tournament_size);
        [~,tournament_rankings] = sort(rank(comp_set)); %fæ index minnstu rank
        if sum(rank(comp_set)==tournament_rankings(1))>1 %checka ef fleiri eru með jafn lítið rank og fremsti gaurinn
            [~,best_comp_set_index] = max(f_shared(comp_set));   % og vel besta shared fitness í því tilfelli
            s = Population(comp_set(best_comp_set_index));
        else %%Ef besta rank er unique þá er hann selected
            s = Population(comp_set(tournament_rankings(1)));
        end
        parents(i) = s;
    end
    
        children = zeros(N,dimensions);
    for i = 1:N
        mate = find(Distances(i,:)<sigma_mate);
        if ~isempty(mate)
            children(i,:) = crossover(parents(i,:),parents(mate(1),:),pc);
        else
            children(i,:) = crossover(parents(i,:),parents(randi([1,N]),:),pc);
        end
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
