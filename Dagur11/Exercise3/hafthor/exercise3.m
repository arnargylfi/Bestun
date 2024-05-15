clear all; close all; clc;

% Define the Gaussian RBF
c = 1; % c = 1, Gaussian RBF
rbf = @(r) exp(-(r*c).^2);

% Define the domain and base points
domain = linspace(-3, 3, 100);
[X, Y] = meshgrid(domain, domain);
points = [X(:), Y(:)];

% Number of base points
N_values = [9, 25, 49, 100, 169];

% Generate LHS test points
lhs_points = lhsdesign(100, 2) * 6 - 3; % LHS in the domain [-3, 3]

% Initialize figure
figure;

% Loop over different N values
for i = 1:length(N_values)
    N = N_values(i);
    
    % Uniform-grid base points
    n = sqrt(N);
    [Xi, Yi] = meshgrid(linspace(-3, 3, n), linspace(-3, 3, n));
    base_points = [Xi(:), Yi(:)];
    
    % Calculate distances
    D = pdist2(points, base_points);
    D_lhs = pdist2(lhs_points, base_points);
    
    % Evaluate function at base points
    F = arrayfun(@(x, y) exercise_3_function([x; y]), base_points(:,1), base_points(:,2));
    
    % Ensure F is a column vector
    F = F(:);
    
    % Construct RBF matrix
    Phi = rbf(D);
    Phi_lhs = rbf(D_lhs);
    
    % Debugging dimensions
    disp(['Size of D: ', num2str(size(D))]);
    disp(['Size of D_lhs: ', num2str(size(D_lhs))]);
    disp(['Size of Phi: ', num2str(size(Phi))]);        
    disp(['Size of F: ', num2str(size(F))]);
    
    % Compute weights using the pseudo-inverse
    if size(Phi, 1) >= size(Phi, 2)
        w = pinv(Phi' * Phi) * Phi' * F; % Use pseudo-inverse for matrix division
    else
        w = pinv(Phi) * F;
    end
    
   
    % RBF approximation
    Z = reshape(Phi * w, size(X)); % Correct reshaping
    
    % Plotting
    subplot(2, 3, i);
    surf(X, Y, Z, 'EdgeColor', 'none');
    hold on;
    plot3(base_points(:,1), base_points(:,2), F, 'k.', 'MarkerSize', 15);
    title(['RBF Surrogate with N = ', num2str(N)]);
    xlabel('X'); ylabel('Y'); zlabel('f(X, Y)');
    
    % Calculate approximation error at LHS points
    F_lhs = arrayfun(@(x, y) exercise_3_function([x; y]), lhs_points(:,1), lhs_points(:,2));
    F_lhs_pred = Phi_lhs * w;
    approx_error = norm(F_lhs - F_lhs_pred) / norm(F_lhs);
    disp(['Approximation error for N = ', num2str(N), ': ', num2str(approx_error)]);
end
