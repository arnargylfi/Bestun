close all;
generations = 50;
pc = 0.7;
pm = 0.2;
mutation_adjust_period = 10;
%Syntax for the tsp, crossover means which algorithm, 0 is the
%'NotAnActualCrossover' algorithm we made, 1 is our crossover algorithm and
%2 is OX Crossover, for more details see report
% [population, best_distance, best_route] = TSP(N, generations, pc, pm, mutation_adjust_period, crossover, animate)
%Ox vs Our crossover
% N = 50;
% [pop, d, route] = TSP(N,generations, pc, pm, mutation_adjust_period,1, false);
% [pop, d, route] = TSP(N,generations, pc, pm, mutation_adjust_period,2, false);

N = randi([20 500])
[pop, d, route] = TSP(N,generations, pc, pm, mutation_adjust_period,1, true);
%%
TSP_Day3(N, generations);

