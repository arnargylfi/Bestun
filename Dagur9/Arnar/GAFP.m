function [xbest, fbest] = GAFP(func1,func2,N,tournament_size,range,pc,pm,max_gens,dimensions)




pm0 = pm;
Population = rand(N, dimensions) * (range(2) - range(1)) + range(1); % Random initialization between -ub and lb

function_evaluations = 0;
alpha = rand;
xbest = [0 0];
m = 1.5;
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
   d = (d_max+d_min)/2;
   sigma = 0.5*d*N^(1/(1-2.5));
   %FITNESS SHARING
   SF = Distances<sigma;
   SF = SF.*(1-(Distances./sigma).^alpha);
   f_shared = fitness./sum(SF,2);
   
    %TOURNAMENT SELECTION
    for i = 1:N
        comp_set = randperm(length(Population),tournament_size);
        [~,tournament_rankings] = order(rank(comp_set)); %fæ index minnstu rank
        if sum(rank(comp_set)==tournament_rankings(1))>1 %checka ef fleiri eru með jafn lítið rank og fremsti gaurinn
            [~,best_comp_set_index] = max(f_shared(comp_set));   % og vel besta shared fitness í því tilfelli
            s = Population(comp_set(best_comp_set_index));
        else %%Ef besta rank er unique þá er hann selected
            s = Population(comp_set(tournament_rankings(1)));
        end
    end
    



    parents(i,:) = Population(individuals(most_fit_index),:);

    
end


end
