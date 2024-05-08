clear all, close all, clc
% Functions
fr = @(x) sum((1 - x(1:end-1)).^2 + 100 .* (x(2:end) - x(1:end-1).^2).^2); % Rosenbrock
fp = @(x) -exp(-norm(x)^2/2) * prod(cos(10*x)); % Function fp
fa = @(x) -20 * exp(-0.2 * sqrt(mean(x.^2))) - exp(mean(cos(2*pi*x))) + 21; % Ackley

% Parameters
n = 2; % Dimensionality of the problem
bounds = [-2, 2]; % Bounds for the search space
kmax = 1000; % Number of iterations

% Execute random search
f = fr;
[xbest, fbest, history, all_points, all_values] = smartRandomSearch(f, n, bounds, kmax);
plotAnimation(f, all_points, bounds, kmax);


