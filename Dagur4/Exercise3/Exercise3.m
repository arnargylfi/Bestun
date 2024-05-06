close all; clear all; clc;
%Test
% Test functions
f1 = @(x) sum(x.^2);
g = @(x) sin(x);
h = @(x) exp(x(1)/5 + x(2)/2) + x(1)^2 + x(2)^2;
rosenbrock = @(x) (1-x(1))^2 + 100*(x(2)-x(1)^2)^2;

% Starting points
x0_1 = (1:10)'; % For f1 with n = 10
x0_2 = 2;       % For g
x0_3 = [5; 3];  % For h
x0_4 = [0; 0];  % For Rosenbrock

% Call the trust region method
[x_min_1, k1] = Descent(f1, x0_1, 0.1, 100, 1e-8, true);
[x_min_2, k2] = Descent(g, x0_2, 0.1, 100, 1e-8, true);
[x_min_3, k3] = Descent(h, x0_3, 0.1, 100, 1e-8, true);
[x_min_4, k4] = Descent(rosenbrock, x0_4, 0.1, 10000, 1e-8, true);

% Display results
disp('Results for f1:');
disp(x_min_1);
disp(k1);
disp('Results for g:');
disp(x_min_2);
disp(k2);
disp('Results for h:');
disp(x_min_3);
disp(k3);
disp('Results for Rosenbrock:');
disp(x_min_4);
disp(k4);
