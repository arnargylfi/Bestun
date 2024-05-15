clear; clc; close all;

plotmeshsize = 20;
N_values = [9, 25, 49, 100, 169];
c = 1; % Gaussian basis function parameter

% Generate grid for plotting the original function
x = linspace(-3, 3, plotmeshsize);
y = linspace(-3, 3, plotmeshsize);
[xi, yi] = meshgrid(x, y);
zi = arrayfun(@(x, y) exercise_3_function([x; y]), xi, yi);

n_test = 100;
lhs_error = zeros(1,length(N_values));

% Loop over different N values
for iteration= 1:length(N_values)
    % LHS test points
    lhs_points = lhsdesign(n_test, 2) * 6 - 3;
    lhs_x = lhs_points(:, 1);
    lhs_y = lhs_points(:, 2);
    lhs_f = arrayfun(@(x, y) exercise_3_function([x;y]),lhs_x', lhs_y');

    N = N_values(iteration);
    % Plot the original function
    figure;
    surf(xi, yi, zi, 'FaceAlpha', 0.2, 'EdgeColor', 'none');
    hold on;
    
    % Generate uniform grid base points
    n = sqrt(N);
    xgrid = linspace(-3, 3, n);
    ygrid = linspace(-3, 3, n);
    [X, Y] = meshgrid(xgrid, ygrid);
    XY = [X(:), Y(:)];

    % Compute RBF matrix
    D = pdist2(XY, XY);
    Phi = exp(-(D * c).^2);
    Z = arrayfun(@(x, y) exercise_3_function([x; y]), XY(:,1), XY(:,2));

    lambda = Phi \ Z;
    Zpredicted = Phi * lambda;

    % Plot the surrogate model
    plot3(X(:), Y(:), Zpredicted, 'k.', 'MarkerSize', 10);
    xlabel('X'); ylabel('Y'); zlabel('f(X, Y)');
    title('RBF Surrogate Model and Original Function for N = ', N);
    grid on;
    hold off;

    % Calculate approximation error using LHS test points
    D_test = pdist2(lhs_points, XY);
    Phi_test = exp(-(D_test * c).^2);
    lhs_f_pred = Phi_test * lambda;
    lhs_error(iteration) = mean((lhs_f - lhs_f_pred').^2);
    disp(['LHS approximation error for N = ', num2str(N), ': ', num2str(lhs_error(iteration))]);
end

figure;
semilogy(N_values,lhs_error)
xlabel('N value'); ylabel('LHS Error');
title('The LHS error compared to values of N');



