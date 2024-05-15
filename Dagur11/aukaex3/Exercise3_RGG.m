close all; clear all; clc;

clear
plotmeshsize = 20;
x=linspace(-3,3,plotmeshsize);
y=linspace(-3,3,plotmeshsize);
[xi,yi]=meshgrid(x,y);
% Define the domain
lb = -3; ub = 3;

% Number of base points
% N_vals = [9, 25, 49, 100, 169];
N_vals = [9];

% Gaussian basis function parameter
c = 1;

% Generate test points using LHS
n_test = 100;
lhs_points = lhsdesign(n_test, 2) * (ub - lb) + lb;
lhs_x = lhs_points(:, 1);
lhs_y = lhs_points(:, 2);
lhs_f = exercise_3_function([lhs_x, lhs_y]');

% Store approximation errors
approximation_errors = zeros(length(N_vals), 1);

for k = 1:length(N_vals)
    N = N_vals(k);
    grid_size = sqrt(N);

    for j=1:length(x)
        for k=1:length(y)
            zi(k,j)=exercise_3_function([x(j) y(k)]'); 	% evaluate function f
        end
    end
    mesh(xi,yi,zi); 				% surface plot of the function f
    hold on
    
    % Generate uniform grid base points
    [X_base, Y_base] = meshgrid(linspace(lb, ub, N), linspace(lb, ub, N));
    
    for j=1:N
        for k=1:N
            F_base(j,k)=exercise_3_function([X_base(j) Y_base(k)]'); 	% evaluate function f
        end
    end

    A = zeros(N, N);
    for i = 1:N
        for j = 1:N
            r = sqrt((X_base(i) - X_base(j))^2 + (Y_base(i) - Y_base(j))^2);
            A(i, j) = gaussian_basis(r, c);
        end
    end
    
    lambda = A \ F_base';

    % Evaluate RBF model on fine grid
    F_rbf = zeros(size(x));
    for i = 1:numel(x)
        for k = 1:numel(y)
            for j = 1:N
                r = sqrt((x(k) - X_base(j))^2 + (y(k) - Y_base(j))^2);
                F_rbf(i,k) = F_rbf(k) + lambda(j) * gaussian_basis(r, c);
            end
        end
    end
    
    centers_x = linspace(min(x), max(x), plotmeshsize);
    centers_y = linspace(min(y), max(y), plotmeshsize);
    [centers_xi, centers_yi] = meshgrid(centers_x, centers_y);
    centers = [centers_xi(:), centers_yi(:)];
    
    % Plot original function surface
    figure;
    surf(x, y, zi);
    hold on;
    plot3(X_base, Y_base, F_base, 'k.', 'MarkerSize', 15);
    title(['Original Function with N = ', num2str(N)]);
    xlabel('x'); ylabel('y'); zlabel('f');
    hold off;

    % Plot RBF model surface
    figure;
    surf(x, y, F_rbf);
    hold on;
    plot3(X_base, Y_base, F_base, 'k.', 'MarkerSize', 15);
    title(['RBF Model with N = ', num2str(N)]);
    xlabel('x'); ylabel('y'); zlabel('f_{RBF}');
    hold off;

    % Calculate approximation error using LHS test points
    F_test_rbf = zeros(n_test, 1);
    for i = 1:n_test
        for j = 1:N
            r = sqrt((lhs_x(i) - X_base(j))^2 + (lhs_y(i) - Y_base(j))^2);
            F_test_rbf(i) = F_test_rbf(i) + lambda(j) * gaussian_basis(r, c);
        end
    end
    approximation_errors(k) = mean((lhs_f - F_test_rbf).^2);
end

% Display approximation errors
disp('Approximation errors for each N:');
for k = 1:length(N_vals)
    disp(['N = ', num2str(N_vals(k)), ': ', num2str(approximation_errors(k))]);
end

% Define Gaussian basis function
function value = gaussian_basis(r, c)
    value = exp(-(r.^2)*c);
end
