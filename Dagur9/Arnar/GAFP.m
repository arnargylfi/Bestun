function [xbest, fbest] = GAFP(func1,func2,N,sigma,range,pc,pm,max_gens,dimensions)




pm0 = pm;
Population = rand(N, dimensions) * (range(2) - range(1)) + range(1); % Random initialization between -ub and lb

function_evaluations = 0;
fbest = Inf;
alpha = rand    
xbest = [0 0];
for k = 1:max_gens
    %Dominance ranking
    func_eval1 = arrayfun(@(j) func1(Population(j,:)), 1:N);
    func_eval2 = arrayfun(@(j) func2(Population(j,:)), 1:N);
    rank = zeros(N,1);
    for i = 1:N
        rank(i) = 1+sum(func_eval1 < func_eval1(i) & func_eval2<func_eval2(i));
    end
    fitness = 1./rank;
%     fprintf('func_eval1 = %s\n', mat2str(func_eval1))
%     fprintf('func_eval2 = %s\n', mat2str(func_eval2))
% 
%     fprintf('Rank = %s \n', mat2str(rank))
%     fprintf('Rank = %s \n', mat2str(rank))
%     fprintf('Fitnesses = %s\n', mat2str(fitness))
    
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
    
   %FITNESS SHARING
   SF = Distances<sigma;
   SF = SF.*(1-(Distances./sigma).^alpha);
   f_shared = fitness./sum(SF,2);
   

%     [fbestnow, most_fit_index] = min(func_eval);
%     if fbestnow < fbest
%         fbest = fbestnow;
%         xbest = Population(individuals(most_fit_index),:);
%     end
%         
%     %cross over each child
%     children = zeros(N,dimensions);
%     for i = 1:N-2
%             children(i,:) = crossover(parents(i,:),parents(i+1,:),pc);
%     end
%     
%     %mutate children
%     mutant_children = zeros(size(children));
%     %ADJUST MUTATION RATE
%     pop_diversity = std(Population(:));
%     if k < max_gens/2
%         if pop_diversity <0.2
%             pm = pm*1.3;
%         else
%             pm = pm/1.2;
%         end
%     else
%         pm = pm0*(2*(max_gens-k)/max_gens)^2;
%     end
%     for i = 1:length(children)
%         mutant_children(i,:) = mutate(children(i,:),pm);
%     end
%     Population = mutant_children;
%     Population(1,:) = xbest;
%     fprintf('Iteration: %d, function evaluations: %d xbest: %s, fbest: %f\n',k,function_evaluations,mat2str(xbest),fbest)
% end
% 
% 
% function child = crossover(parent1, parent2, pc)
%     alpha = rand(size(parent1));
%     alpha(alpha > pc) = 0;
%     
%     child = alpha .* parent1 + (1 - alpha) .* parent2;
% end
% 
% %Mutation operator for floating point slide 12
% function mutant = mutate(individual,pm)
%     r = rand(1,length(individual));
%     r_larger_than05 = r>0.5;
%     mutate_these = rand(1,length(individual))<pm;
%     beta =4;
%     mutant = individual...
%              + mutate_these.*(r_larger_than05.*(max(individual)-individual).*(2*(r-0.5)).^beta...
%              + ~r_larger_than05.*(min(individual)-individual).*(2*(0.5-r)).^beta); 
    
end


end
