clear all;
close all;
clc;

%Define the functions, bounds, and global minimum solutions
functions = {@(x) sum((1 - x(1:end-1)).^2 + 100 .* (x(2:end) - x(1:end-1).^2).^2), ... % Rosenbrock
             @(x) -exp(-norm(x)^2/2) * prod(cos(10*x)), ... % Function fp
             @(x) -20 * exp(-0.2 * sqrt(mean(x.^2))) - exp(mean(cos(2*pi*x))) + 21}; % Ackley

bounds = {[-2, 2], [-2, 2], [-10, 10]};
solutions = [0, -1, -1.7183];
names = {'Rosenbrock', 'fp', 'Ackley'};
n_values = [2, 2, 2];
F = [0.5, 1, 1.5];
CR = [0.1, 0.5, 0.9];
maxGens = 1000;

n_runs = 30;
stats = zeros(length(functions), length(F) * length(CR), 4);

for i = 1:length(functions)
    fun = functions{i};
    n = n_values(i);
    bound = bounds{i};
    sol = solutions(i);
    idx = 1;

    fprintf('\nEvaluating the %s function\n', names{i});

    for j = 1:length(F)
        [meanBest, stdBest, maxBest, minBest] = evaluateMethods(@Diff_Evolution, fun, n, bound, maxGens, n_runs, sol, F(j), CR(j));
        stats(i, idx, :) = [meanBest, stdBest, maxBest, minBest];
        fprintf('Stats for F = %.2f, CR = %.2f: Mean = %.5f, Std = %.5f, Max = %.5f, Min = %.5f\n', F(j), CR(j), meanBest, stdBest, maxBest, minBest);
        idx = idx + 1;
    end
end

% Plotting results
for i = 1:length(functions)
    true_value = solutions(i);
    figure;
    bar(squeeze(stats(i, :, :))');
    yline(true_value, 'r--', 'LineWidth', 2);
    set(gca, 'XTickLabel', {'Mean', 'Std', 'Max', 'Min'});
    legend(arrayfun(@(f, c) sprintf('F=%.2f, CR=%.2f', f, c), F, CR, 'UniformOutput', false), ...
        'Location', 'northoutside', 'Orientation', 'horizontal');
    title(sprintf('Performance Metrics for %s Function', names{i}));
    xlabel('Metric');
    ylabel('Value');
    grid on;
end

%%
%Testing dimensions
Ros = functions{1};
F = 0.5;
CR = 0.1;
fprintf('Evaluating n= 1 for the Rosenbrock function:\n')
for l = 1:1
    [meanBest, stdBest, maxBest, minBest] = evaluateMethods(@Diff_Evolution, Ros, l, [-2 2], maxGens, n_runs, 0, F, CR);
    fprintf('Stats for n = %.d: Mean = %.5f, Std = %.5f, Max = %.5f, Min = %.5f\n',l, meanBest, stdBest, maxBest, minBest);
end
fp = functions{2};
fprintf('Evaluating n= 1 & 2 for the f_p function:\n')
for m = 1:2
    [meanBest, stdBest, maxBest, minBest] = evaluateMethods(@Diff_Evolution, fp, m, [-2 2], maxGens, n_runs, -1, F, CR);
    fprintf('Stats for n = %.d: Mean = %.5f, Std = %.5f, Max = %.5f, Min = %.5f\n',m, meanBest, stdBest, maxBest, minBest);
end
Ack = functions{3};
fprintf('Evaluating n= 1,2 & 3 for the Ackley function:\n')
for g = 1:3
    [meanBest, stdBest, maxBest, minBest] = evaluateMethods(@Diff_Evolution, Ack, g, [-10 10], maxGens, n_runs, -1.7183, F, CR);
    fprintf('Stats for n = %.d: Mean = %.5f, Std = %.5f, Max = %.5f, Min = %.5f\n',g, meanBest, stdBest, maxBest, minBest);
end


%%
%Visulization of the history for each function
[R_all_points,~,~] = Diff_Evolution(functions{1},2,bounds{1},0.5,0.1,1000);
[F_all_points,~,~] = Diff_Evolution(functions{2},2,bounds{2},0.5,0.1,1000);
[A_all_points,~,~] = Diff_Evolution(functions{3},2,bounds{3},0.5,0.1,1000);

plotAnimation(functions{1}, R_all_points, bounds{1});
title('Rosenbrock Function Evolution');

plotAnimation(functions{2}, F_all_points, bounds{2});
title('Function fp Evolution');

plotAnimation(functions{3}, A_all_points, bounds{3});
title('Ackley Function Evolution');


