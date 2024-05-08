clear all, close all, clc
% Rosenbrock Function
fr = @(x) sum((1 - x(1:end-1)).^2 + 100 .* (x(2:end) - x(1:end-1).^2).^2); 
fr_bounds = [-2, 2];
fr_solution = 0; % global minimum at [1 1]'
% fp Function
fp = @(x) -exp(-norm(x)^2/2) * prod(cos(10*x)); 
fp_bounds = [-2, 2];
fp_solution = -1; % global minimum at [0 0]'
% Auckley Function
fa = @(x) -20 * exp(-0.2 * sqrt(mean(x.^2))) - exp(mean(cos(2*pi*x))) + 21; % Ackley
fa_bounds = [-10 10];
fa_solution = -1.7183; % global minimum at [0 0]'

% Parameters
n = 2; % Dimensionality of the problem
kmax = 1000; % Number of iterations

% Execute random search
[xbest, fbest, history, all_points, all_values] = smarterRandomSearch(fr, n, fr_bounds, kmax);
fbest, xbest
plotAnimation(fr, all_points, fr_bounds, kmax);

[xbest, fbest, history, all_points, all_values] = smarterRandomSearch(fp, n, fp_bounds, kmax);
fbest, xbest
plotAnimation(fp, all_points, fp_bounds, kmax);

[xbest, fbest, history, all_points, all_values] = smarterRandomSearch(fa, n, fa_bounds, kmax);
fbest, xbest
plotAnimation(fa, all_points, fa_bounds, kmax);

