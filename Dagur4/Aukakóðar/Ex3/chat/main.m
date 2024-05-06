clear all, close all, clc

% Test 1: Quadratic function
n = 5; % Example dimension
x0 = (1:n)';
f1 = @(x) sum(x.^2);
[x1, fval1] = descentTrustRegionMethod(f1, x0, 100, 1e-6)

% Test 2: Sine function
f2 = @(x) sin(x);
[x2, fval2] = descentTrustRegionMethod(f2, 2, 100, 1e-6)

% Test 3: Exponential and quadratic function
f3 = @(x) exp(x(1)/5 + x(2)/2) + x(1)^2 + x(2)^2;
[x3, fval3] = descentTrustRegionMethod(f3, [5; 3], 100, 1e-6)

% Test 4: Rosenbrock function
f4 = @(x) (1 - x(1))^2 + 100 * (x(2) - x(1)^2)^2;
[x4, fval4] = descentTrustRegionMethod(f4, [0; 0], 100, 1e-6)
