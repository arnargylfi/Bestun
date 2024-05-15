clear; clc; close all;

% Define parameters
plotmeshsize = 20;
N_values = [9, 25, 49, 100, 169]; % Different N values for base points
c = 1; % Gaussian basis function parameter

% Generate grid for plotting the original function
x = linspace(-3, 3, plotmeshsize);
y = linspace(-3, 3, plotmeshsize);
[xi, yi] = meshgrid(x, y);

% Evaluate the original function
zi = arrayfun(@(x, y) exercise_3_function([x; y]), xi, yi);

% Plot the original function
figure;
surf(xi, yi, zi, 'FaceAlpha', 0.2, 'EdgeColor', 'none');
hold on;

% Loop over different N values
for N = N_values
    % Generate uniform grid base points
    n = sqrt(N);
    xgrid = linspace(-3, 3, n);
    ygrid = linspace(-3, 3, n);
    [X, Y] = meshgrid(xgrid, ygrid);
    XY = [X(:), Y(:)];

    % Compute RBF matrix
    D = pdist2(XY, XY); % Pairwise distances
    Phi = exp(-(D * c).^2);

    % Evaluate the function at base points
    Z = arrayfun(@(x, y) exercise_3_function([x; y]), XY(:,1), XY(:,2));

    % Solve for weights
    lambda = Phi \ Z;

    % Predict function values at the base points
    Zpredicted = Phi * lambda;

    % Plot the surrogate model
    plot3(X(:), Y(:), Zpredicted, 'k.', 'MarkerSize', 10);

    % Display approximation error
    approx_error = norm(Z - Zpredicted) / norm(Z);
    disp(['Approximation error for N = ', num2str(N), ': ', num2str(approx_error)]);
end

% Finalize the plot
xlabel('X'); ylabel('Y'); zlabel('f(X, Y)');
title('RBF Surrogate Model and Original Function');
grid on;
hold off;
