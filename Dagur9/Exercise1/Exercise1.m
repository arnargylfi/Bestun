clear all; close all; clc;

% Objective functions definitions
ff1 = @(x) 1 - exp(-sum((x - 1/sqrt(8)).^2));
ff2 = @(x) 1 - exp(-sum((x + 1/sqrt(8)).^2));
ff_range = [-2, 2];  % Range for ff function

% Set parameters for the MOEA
N = 100;  % Number of individuals in the population
max_gens = 50;  % Maximum number of generations
dimensions = 8;  % Number of dimensions of the problem
sigma_share = 0.5;
pc = 0.8;
pm = 0.2;

% Call the MOEA function
[Pareto_front, Pareto_set] = MOEARGG(ff1, ff2, N, sigma_share, ff_range, pc, pm, max_gens, dimensions);
% (func1, func2, N, sigma_share, range, pc, pm, max_gens, dimensions)
% Optionally, display results
disp('Pareto front values:');
disp(Pareto_front);
disp('Pareto optimal set:');
disp(Pareto_set);

% function objectives = ft(x)
%     % Ensure the input vector x has at least three elements
%     if length(x) < 3
%         error('Input vector x must have at least three elements.');
%     end
% 
%     % Extract variables
%     x1 = x(1);
%     x2 = x(2);
%     x3 = x(3);
% 
%     % Define f_t1
%     ft1 = x1;
% 
%     % Define f_t2
%     ft2 = (1/x1) * (1 + (x2^2 + x3^2)^0.25 * sin(50 * (x2^2 + x3^2)^0.1)^2 + 1);
% 
%     % Combine objectives
%     objectives = [ft1, ft2];
% end
% 
% function objectives = ff(x)
%     % Check if the input vector x has exactly 8 elements
%     if length(x) ~= 8
%         error('Input vector x must have exactly eight elements.');
%     end
% 
%     % Pre-compute the constant for efficiency
%     oneOverSqrt8 = 1/sqrt(8);
% 
%     % Calculate the first objective function, ff1
%     sumSq1 = sum((x - oneOverSqrt8).^2);
%     ff1 = 1 - exp(-sumSq1);
% 
%     % Calculate the second objective function, ff2
%     sumSq2 = sum((x + oneOverSqrt8).^2);
%     ff2 = 1 - exp(-sumSq2);
% 
%     % Combine objectives
%     objectives = [ff1, ff2];
% end