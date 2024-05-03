clear all, clc, close all

% Run the animation function

f = @(x) (x - 2).^2;
f2 = @(x) x.^2+3*exp(-2*x);

golden_ratio_search_plot(f);
golden_ratio_search_plot(f2);


%% test the ratio

f = @(x) (x-2).^2;
solution = 2;

x1 = 0;
x2 = 10;
tol = 1e-3;
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
xlabel('Ratio');
ylabel('Number of Iterations');
title('Number of Iterations to find a solution for Different Ratios in Golden Ratio Search');
legend('Iterations', 'Min Iteration Point', 'Corresponding Point for Min Error');
grid on;

subplot(2,1,2);
plot(ratios, accuracies, '.-');
hold on;
plot(ratios(idx_min_err), min_err, 'ro', 'MarkerFaceColor', 'r');
plot(ratios(idx_min_iters), accuracies(idx_min_iters), 'ko', 'MarkerFaceColor', 'k');
xlabel('Ratio');
ylabel('Accuracy (Absolute Error)');
title('Accuracy of Solutions for Different Ratios in Golden Ratio Search');
legend('Accuracy', 'Min Error Point', 'Corresponding Point for Min Iteration');
grid on;


function golden_ratio_search_plot(f)
    % Golden ratio value
    ratio = (1 + sqrt(5)) / 2;
    x1 = 0;
    x2 = 10;
    tol = 1e-3;
    
    % Initialize plot
    figure;
    hold on;
    grid on;
    fplot(f, [0, 10], 'k-'); % Plot function
    xlabel('x');
    ylabel('f(x)');
    title('Golden Ratio Search Visualization');

    % Start the search
    [xmin, fmin, ~] = golden_ratio_search(f, x1, x2, tol, ratio, true);
    fprintf('Minimum found at x = %f with f(x) = %f\n', xmin, fmin);
end

function [xmin, fmin, iterations] = golden_ratio_search(f, x1, x2, tol, ratio, animate)
    d = (x2 - x1) / ratio;
    x3 = x2 - d;
    x4 = x1 + d;
    f1 = f(x1);
    f2 = f(x2);
    f3 = f(x3);
    f4 = f(x4);
    iterations = 0;
    
    if animate
    % Plot initial points
    h1 = plot(x1, f1, 'ro', 'MarkerFaceColor', 'r');
    h2 = plot(x2, f2, 'bo', 'MarkerFaceColor', 'b');
    h3 = plot(x3, f3, 'go', 'MarkerFaceColor', 'g');
    h4 = plot(x4, f4, 'mo', 'MarkerFaceColor', 'm');
    end

    while abs(x2 - x1) > tol
        iterations = iterations + 1;
        % Update points
        if f3 < f4
            x2 = x4;
            f2 = f4;
            x4 = x3;
            f4 = f3;
            d = (x2 - x1) / ratio;
            x3 = x2 - d;
            f3 = f(x3);
        else
            x1 = x3;
            f1 = f3;
            x3 = x4;
            f3 = f4;
            d = (x2 - x1) / ratio;
            x4 = x1 + d;
            f4 = f(x4);
        end
        
        if animate
        drawnow;
        pause(0.2)
        delete([h1, h2, h3, h4]);
      
        % Plot updated points
        h1 = plot(x1, f1, 'ro', 'MarkerFaceColor', 'r');
        h2 = plot(x2, f2, 'bo', 'MarkerFaceColor', 'b');
        h3 = plot(x3, f3, 'go', 'MarkerFaceColor', 'g');
        h4 = plot(x4, f4, 'mo', 'MarkerFaceColor', 'm');
        end
    end
    xmin = (x1 + x2) / 2;
    fmin = f(xmin);
end

