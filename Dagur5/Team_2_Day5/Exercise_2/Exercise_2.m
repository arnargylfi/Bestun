close all; clear all; clc;
% Define the functions for each test case
func1 = @(x, y) 2*x^2 + 3*y^2 - 3*x*y + x;
func2 = @(x, y) (1 - x)^2 + 5*(x - y^2)^2;
func3 = @(x, y) (x + 2*y) * (1 - 0.9*exp(-0.3*(x - 2.5)^2 - 2*(y - 3.5)^2)) * (1 - 0.9*exp(-(x - 3)^2 - (y - 3)^2));
func4 = @(x, y) exp(x/5) + exp(y/3);

% Define bounds and start points
bounds1 = [-2 8; -2 8];
bounds2 = [-0.5 1.5; -0.5 1.5];
bounds3 = [1 5; 1 5];
bounds4 = [-10 10; -10 10];

% Execute the search for each test case
[xmin1, fmin1, path1] = SmarterLineSearch(func1, bounds1, [5; 8], 100, 0.01);
[xmin2, fmin2, path2] = SmarterLineSearch(func2, bounds2, [0; 0], 100, 0.001);
[xmin3, fmin3, path3] = SmarterLineSearch(func3, bounds3, [4; 2], 100, 0.001);
[xmin4, fmin4, path4] = SmarterLineSearch(func4, bounds4, [5; 8], 100, 0.01);

plot2D(func1, bounds1, xmin1, path1);
plot2D(func2, bounds2, xmin2, path2);
plot2D(func3, bounds3, xmin3, path3);
plot2D(func4, bounds4, xmin4, path4);

plot3D(func1, bounds1, xmin1, path1(:,1:2), [-45, 30]);
plot3D(func2, bounds2, xmin2, path2(:,1:2), [125, 60]);
plot3D(func3, bounds3, xmin3, path3(:,1:2), [-100, 50]);
plot3D(func4, bounds4, xmin4, path4(:,1:2), [-45, 30]);
plot3DZoom(func1, xmin1, path1(:,1:2), [-45, 50]);
plot3DZoom(func2, xmin2, path2(:,1:2), [125,60]);
plot3DZoom(func3, xmin3, path3(:,1:2), [-100, 50]);
plot3DZoom(func4, xmin4, path4(:,1:2), [-45, 30]);