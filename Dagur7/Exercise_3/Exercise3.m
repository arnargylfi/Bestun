clear all; close all; clc;
fp = @(x) -exp(-norm(x)^2/2) * prod(cos(10*x));
fr = @(x) sum((1 - x(1:end-1)).^2 + 100 .* (x(2:end) - x(1:end-1).^2).^2); % rosenbrock
fa = @(x) -20 * exp(-0.2 * sqrt(mean(x.^2))) - exp(mean(cos(2*pi*x))) + 21; % auckley

% fprintf('fp function: n=1\n')
% [all_points, costs]=Diff_Evolution(fp,1,[-2 2],1,0.5, 50);
% [all_points, costs]=Diff_Evolution(fp,1,[-2 2],0.25,0.1, 50);
% [all_points, costs]=Diff_Evolution(fp,1,[-2 2],0.5,0.01, 50);
% fprintf('fp function: n=2\n')
% [all_points, costs]=Diff_Evolution(fp,2,[-2 2],1,0.5, maxgen);
% [all_points, costs]=Diff_Evolution(fp,2,[-2 2],0.25,0.1, 50);
% [all_points, costs]=Diff_Evolution(fp,2,[-2 2],0.5,0.01, 50);
% plotAnimation(fp, all_points, [-2 2]);

% fprintf('Rosenbrock function: n=2\n')
% [all_points, costs]=Diff_Evolution(fr,2,[-2 2],1,0.5, 1000);
% [all_points, costs]=Diff_Evolution(fr,2,[-2 2],0.25,0.1, 50);
% [all_points, costs]=Diff_Evolution(fr,2,[-2 2],0.5,0.01, 50);
% plotAnimation(fr, all_points, [-2 2]);
% fprintf('Auckley function: n=1\n')
% [all_points, costs]=Diff_Evolution(fa,1,[-10 10],1,0.5, 50);
% [all_points, costs]=Diff_Evolution(fa,1,[-10 10],0.25,0.1, 50);
% [all_points, costs]=Diff_Evolution(fa,1,[-10 10],0.5,0.01, 50);
% fprintf('Auckley function: n=2\n')
[all_points, costs]=Diff_Evolution(fa,2,[-10 10],1,0.5, 1000);
% [all_points, costs]=Diff_Evolution(fa,2,[-10 10],0.25,0.1, 50);
% [all_points, costs]=Diff_Evolution(fa,2,[-10 10],0.5,0.01, 50);
plotAnimation(fa, all_points, [-10 10]);
% fprintf('Auckley function: n=3\n')
% [all_points, costs]=Diff_Evolution(fa,3,[-10 10],1,0.5, 50);
% [all_points, costs]=Diff_Evolution(fa,3,[-10 10],0.25,0.1, 50);
% [all_points, costs]=Diff_Evolution(fa,3,[-10 10],0.5,0.01, 50);

