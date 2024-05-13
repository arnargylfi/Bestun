clear all; close all; clc;

% Objective functions definitions
ff1 = @(x) 1 - exp(-sum((x - 1/sqrt(8)).^2));
ff2 = @(x) 1 - exp(-sum((x + 1/sqrt(8)).^2));
ff_range = [-2, 2];  % Range of values for each dimension

ft1 = @(x) x(1);
ft2 = @(x) (1/x(1)) * (1+(x(2)^2 + x(3)^2))^0.25 * ((sin(50 * (x(2)^2 + x(3)^2)^0.1))^2 + 1);
ft_range = [-2, -2, -2];

% Set parameters for the MOEA
N = 100;  % Number of individuals in the population
sigma_share = 0.5;  % Sharing parameter

pc = 0.7;  % Probability of crossover
pm = 0.2;  % Probability of mutation
max_gens = 50;  % Maximum number of generations
dimensions = 2;  % Number of dimensions of the problem

% Call the MOEA function
[Pareto_front, Pareto_set] = MOEA(ff1, ff2, N, sigma_share, ff_range, pc, pm, max_gens, dimensions);

% Optionally, display results
disp('Pareto front values:');
disp(Pareto_front);
disp('Pareto optimal set:');
disp(Pareto_set);
