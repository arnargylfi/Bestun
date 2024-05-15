% Generate some periodic data
load("exercise_1_data.mat")
y = Y';
x = linspace(0,15,length(y));
% Define the maximum degree of the polynomial
n = 5;

% Create the design matrix
X = ones(length(x), 2*n+1);
for i = 1:n
    X(:, 2*i) = sin(i*x);
    X(:, 2*i+1) = cos(i*x);
end

% Perform linear regression
beta = (X' * X) \ (X' * y);

% Predict the values
y_pred = X * beta;

% Plot the original data and the regression line
plot(x, y, 'b.', x, y_pred, 'r-', 'LineWidth', 1.5);
xlabel('x');
ylabel('y');
legend('Original data', 'Regression line');
title('Linear Regression on Periodic Data');
