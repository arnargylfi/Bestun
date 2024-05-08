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
f = fp;
[xbest, fbest, history, all_points, all_values] = smartRandomSearch(f, n, bounds, kmax);
plotAnimation(f, all_points, bounds, kmax);


%% Functions
function [xbest, fbest, history, all_points, all_values] = randomSearch(f, n, bounds, kmax)
    fbest = Inf;
    xbest = [];
    history = zeros(kmax, 1);
    all_points = zeros(kmax, n);
    all_values = zeros(kmax, 1);  
    for k = 1:kmax
        xnew = bounds(1) + (bounds(2) - bounds(1)) * rand(1, n); % Generate random point
        fnew = f(xnew);       
        all_points(k, :) = xnew;
        all_values(k) = fnew;
        if fnew < fbest
            xbest = xnew;
            fbest = fnew;
        end
        history(k) = fbest; 
    end
end

function [xbest, fbest, history, all_points, all_values] = smartRandomSearch(f, n, bounds, kmax)
    xbest = bounds(1) + (bounds(2) - bounds(1)) * rand(1, n); % generate random point
    fbest = f(xbest);
    history = zeros(kmax, 1);
    all_points = zeros(kmax, n);
    all_values = zeros(kmax, 1);   
    all_points(1, :) = xbest;
    all_values(1) = fbest;
    history(1) = fbest;   
    k = 1;
    while k <= kmax
        lambda = 1 - k / kmax; % Update lambda based on the iteration number
        xnew = bounds(1) + (bounds(2) - bounds(1)) * rand(1, n);
        xnew = lambda * xnew + (1 - lambda) * xbest; % Mix xnew with xbest
        fnew = f(xnew);
        all_points(k, :) = xnew;
        all_values(k) = fnew;
        history(k) = fbest;
        if fnew < fbest
            xbest = xnew;
            fbest = fnew;
        end
        k = k + 1;
    end
end

function plotAnimation(f, all_points, bounds, kmax)
    x = linspace(bounds(1), bounds(2), 100);
    y = linspace(bounds(1), bounds(2), 100);
    [X, Y] = meshgrid(x, y);
    Z = arrayfun(@(ix, iy) f([ix, iy]), X, Y); 

    figure;
    contour(X, Y, Z, 20, 'LineColor', 'b');
    hold on;
    scatterPlot = scatter(all_points(1, 1), all_points(1, 2), 20, 'filled', 'r');
    %title(sprintf('Random Search Animation on Function %s', func2str(f)));
    xlabel('X1');
    ylabel('X2');

    for k = 2:kmax
        set(scatterPlot, 'XData', all_points(1:k, 1), 'YData', all_points(1:k, 2));
        drawnow;
    end
end

