clear;
addpath('..\')  % Adjust the path to the DACE toolbox

% Define the function domain
lb = [-2, -1]; % Lower bounds [x_min, y_min]
ub = [3, 2];   % Upper bounds [x_max, y_max]

%-----TEKUR U.Þ.B (N)*10 SEK og SVO 10 SEK FYRIR HVERT ITERATION Í FOR LOOPINU-----

N = 5; % CHOOSE NUMBER OF FUNCTION EVALUATIONS

% Generate random points
inputPoints = lhsdesign(N, 2) .* (ub - lb) + lb;
wrapped_f = @(row) exercise_1_function(inputPoints(row,:)); % Vectorized function evaluation
tic
Y = arrayfun(wrapped_f, 1:N); % EVALUATE
toc

%% CREATE MODEL
close
theta0 = [1, 1];  % Initial guess for the correlation parameters
lob = [0.01, 0.01];  % Lower bounds for the correlation parameters
upb = [10, 10];  % Upper bounds for the correlation parameters
[dmodel, ~] = dacefit(inputPoints, Y', @regpoly0, @corrgauss, theta0, lob, upb);
figure;
%% OPTIMIZE SURROGATE MODEL AND UPDATE AND SO ON
for i = 1:4
    dace = @(x) predictor(x, dmodel);
    
    % Find the minimum of the surrogate model using Differential Evolution
    [ymin, xmin] = Diff_Evolution(dace, 2, [lb; ub], 5);

    % EVALUATE REAL FUNCTION At miNIMUM
    realY_min = exercise_1_function(xmin);
    
    % UPDATE SURROGATE BY ADDING THE REAL POINTS
    inputPoints = [inputPoints; xmin];
    Y = [Y, realY_min];
    
    % REPEAT PROCESS OF MODEL CREATION
    [dmodel, ~] = dacefit(inputPoints, Y', @regpoly0, @corrgauss, theta0, lob, upb);

    %% PLOTS
    plotmeshsize = 50;
    x1_plot = linspace(lb(1), ub(1), plotmeshsize);
    x2_plot = linspace(lb(2), ub(2), plotmeshsize);
    [X1_plot, X2_plot] = meshgrid(x1_plot, x2_plot);
    X_plot = [X1_plot(:), X2_plot(:)];
    Y_model = predictor(X_plot, dmodel);  % Predict for the entire grid
    Y_model = reshape(Y_model, size(X1_plot));

    clf;
    surf(X1_plot, X2_plot, Y_model, 'EdgeColor', 'none', 'FaceAlpha', 0.5);
    hold on;
    plot3(inputPoints(:, 1), inputPoints(:, 2), Y, 'ro', 'MarkerSize', 10, 'MarkerFaceColor', 'r');
    hold on
    plot3(xmin(1), xmin(2), ymin, 'go', 'Markersize', 10, 'MarkerFaceColor', 'magenta');
    hold on
    plot3(xmin(1), xmin(2), realY_min, 'go', 'Markersize', 10, 'MarkerFaceColor', 'cyan');
    hold on
    plot3([xmin(1) xmin(1)], [xmin(2) xmin(2)], [ymin realY_min], 'r', 'LineWidth', 1.5);
    xlabel('x1');
    ylabel('x2');
    zlabel('Y');
    title(sprintf('Surrogate Model after Iteration %d', i));
    legend('Model', 'Training points', 'Surrogate minima', 'Real function value', 'Location', 'best');
    hold off;
    
    % Calculate and display the root mean square error
    error = rmse(ymin, realY_min);
    fprintf('Root mean square error at surrogate minima = %f\n', error);
end

% Root mean square error function
function error = rmse(predicted, actual)
    error = sqrt(mean((predicted - actual).^2));
end
