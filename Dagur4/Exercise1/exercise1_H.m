%% visualising the golden ratio search
clear all, clc, close all

golden_ratio = (1 + sqrt(5)) / 2;
x1 = 0;
x2 = 10;
tol = 1e-4;

%%%% first function
f = @(x) (x - 2).^2;
a = figure;
set(gcf, 'Position', [360 198 700 420]);
hold on;
grid on;
fplot(f, [0, 10], 'k-') % Plot function

xlabel('x');
ylabel('f(x)');
title(sprintf("f(x) = (x-2)^2",'Interpreter','latex','FontSize',12))

% Start the search
[xmin_1, fmin1, iter1] = golden_ratio_search(f, x1, x2, tol, golden_ratio, true);
title(sprintf('$f(x) = (x-2)^2$, $(x,f(x))_{\\mathrm{min}} = (%f, %f)$, number of iterations $= %d$', xmin_1, fmin1, iter1),'Interpreter','latex','FontSize',12)
fprintf('Minimum found at x = %f with f(x) = %f\n', xmin_1, fmin1);

%%%% second function
f2 = @(x) x.^2+3*exp(-2*x);
figure;
set(gcf, 'Position', [360 198 700 420]);
hold on;
grid on;
fplot(f2, [0, 10], 'k-'); % Plot function
xlabel('x');
ylabel('f(x)');
title(sprintf("f(x) = x^2+3e^{-2x}",'Interpreter','latex','FontSize',12))

% Start the search
[xmin_2, fmin2, iter2] = golden_ratio_search(f2, x1, x2, tol, golden_ratio, true);
title(sprintf('$f(x) = x^2+3e^{-2x}$, $(x,f(x))_{\\mathrm{min}} = (%f, %f)$, number of iterations $= %d$', xmin_2, fmin2, iter2),'Interpreter','latex','FontSize',12)
fprintf('Minimum found at x = %f with f(x) = %f\n', xmin_2, fmin2);


%% testing the effect of the ratio for fun

f = @(x) (x-2).^2;
solution = 2;

x1 = 0;
x2 = 10;
tol = 1e-4;
ratios = 1.35:0.0005:1.7;
golden_ratio = (1 + sqrt(5)) / 2;
[~, index] = min(abs(ratios - golden_ratio));
ratios(index) = golden_ratio;

iterations = zeros(size(ratios));
accuracies = zeros(size(ratios));

for i = 1:length(ratios)
    [xmin, ~, iterations(i)] = golden_ratio_search(f, x1, x2, tol, ratios(i), false);
    accuracies(i) = abs(xmin - solution);
end

[min_iters, idx_min_iters] = min(iterations);
[min_err, idx_min_err] = min(accuracies);

figure;
subplot(2,1,1);
plot(ratios, iterations, '.-');
hold on;
plot(ratios(idx_min_iters), min_iters, 'ko', 'MarkerFaceColor', 'k');
plot(ratios(idx_min_err), iterations(idx_min_err), 'ro', 'MarkerFaceColor', 'r');
xlabel('Ratio used in function');
ylabel('Number of Iterations');
title('Number of Iterations to find a solution for Different Ratios in Golden Ratio Search');
legend('Iterations', 'Min Iteration Point', 'Corresponding Point for Min Error');
grid on;

subplot(2,1,2);
plot(ratios, accuracies, '.-');
hold on;
plot(ratios(idx_min_err), min_err, 'ro', 'MarkerFaceColor', 'r');
plot(ratios(idx_min_iters), accuracies(idx_min_iters), 'ko', 'MarkerFaceColor', 'k');
xlabel('Ratio used in function');
ylabel('Accuracy (Absolute Error)');
title('Accuracy of Solutions for Different Ratios in Golden Ratio Search');
legend('Accuracy', 'Min Error Point', 'Corresponding Point for Min Iteration');
grid on;
