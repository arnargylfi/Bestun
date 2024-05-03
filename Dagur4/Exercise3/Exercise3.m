%Test
% Test functions
f1 = @(x) sum(x.^2);          % Quadratic function
g = @(x) sin(x);              % Sin function
h = @(x) exp(x(1)/5 + x(2)/2) + x(1)^2 + x(2)^2; % Exponential and quadratic
rosenbrock = @(x) (1-x(1))^2 + 100*(x(2)-x(1)^2)^2; % Rosenbrock function

% Starting points
x0_1 = (1:10)'; % For f1 with n = 10
x0_2 = 2;       % For g
x0_3 = [5; 3];  % For h
x0_4 = [0; 0];  % For Rosenbrock

% Call the trust region method
x_min_1 = Descent(f1, x0_1, 1, 100, 1e-6);
% x_min_2 = Descent(g, x0_2, 1, 100, 1e-6);
% x_min_3 = Descent(h, x0_3, 1, 100, 1e-6);
% x_min_4 = Descent(rosenbrock, x0_4, 1, 100, 1e-6);

% Display results
disp('Results for f1:');
disp(x_min_1);
% disp('Results for g:');
% disp(x_min_2);
% disp('Results for h:');
% disp(x_min_3);
% disp('Results for Rosenbrock:');
% disp(x_min_4);
