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
[xbest, fbest, history, all_points, all_values] = smartRandomSearch(fr, n, fr_bounds, kmax);
disp('Rosenbrock')
fbest, xbest
plotAnimation(fr, all_points, fr_bounds, kmax);
title('Rosenbrock')
hold on
plot(xbest(1),xbest(2),'kx','linewidth',2)
hold off

[xbest, fbest, history, all_points, all_values] = smartRandomSearch(fp, n, fp_bounds, kmax);
disp('fp')
fbest, xbest
plotAnimation(fp, all_points, fp_bounds, kmax);
title('fp')
hold on
plot(xbest(1),xbest(2),'kx','linewidth',2)
hold off
%
[xbest, fbest, history, all_points, all_values] = smartRandomSearch(fa, n, fa_bounds, kmax);
disp('Auckley')
fbest, xbest
plotAnimation(fa, all_points, fa_bounds, kmax);
title('Auckley')
hold on
plot(xbest(1),xbest(2),'kx','linewidth',2)
hold off


%% Comparing the methods

n_runs = 1000;
n = 2
%algorithms = {@smartRandomSearch, @smarterRandomSearch};
%algorithm_names = {'Smart Random Search', 'Smarter Random Search'};
algorithms = {@randomSearch, @smartRandomSearch};
algorithm_names = {'Random Search', 'Smart Random Search'};
function_handles = {fr, fp, fa};
function_names = {'Rosenbrock', 'fp', 'Auckley'};
function_solutions = [fr_solution, fp_solution, fa_solution];
function_bounds = [fr_bounds; fp_bounds; fa_bounds];
stats = zeros(length(algorithms), 4, length(function_handles)); % 3D Array to store stats for each algorithm and function

for j = 1:length(function_handles)
    fprintf('\nRunning experiments on %s function:\n', function_names{j});
    fprintf('Absolute error:\n');
    for i = 1:length(algorithms)
        [meanBest, stdBest, maxBest, minBest] = evaluateMethods(algorithms{i}, function_handles{j}, n, function_bounds(j,:), kmax, n_runs, function_solutions(j));
        stats(i, :, j) = [meanBest, stdBest, maxBest, minBest];
        fprintf('%s: Mean Error: %f, Std Error: %f, Min Error: %f, Max Error: %f\n', algorithm_names{i}, meanBest, stdBest, minBest, maxBest);
    end
end

 for j = 1:length(function_handles)
        figure; % Create a new figure for each function
        bar(squeeze(stats(:,:,j))');
        grid on
        title(sprintf('Absolute error Metrics for %s Function', function_names{j}));
        xlabel('Metric');
        ylabel('Value');
        set(gca, 'XTickLabel', {'Mean Error', 'Std Error', 'Max Error', 'Min Error'});
        legend(algorithm_names, 'Location', 'northoutside', 'Orientation', 'horizontal');
    end