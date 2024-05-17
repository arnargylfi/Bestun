clear
addpath('..\')
xbound = [-2 3];
ybound = [-1 2];


N = 10; %CHOOSE NUMBER OF FUNCTION EVALUATIONS
% Generate random points
inputMatrix = LHS(N,[xbound;ybound]);
wrapped_f = @(row) exercise_1_function(inputMatrix(row,:)); %til að geta gert vector evaluation á f
tic
Y = arrayfun(wrapped_f,1:N); %EVALUATE
toc
%% CREATE MODEL
close
basis = 4; %CHOOSE NUMBER OF BASIS FUNCTIONS
X = ones(N,1);
%QUADRATIC BASIS FUNCTIONS
for j = 1:basis
    X = [X,inputMatrix(:,1).^j,inputMatrix(:,2).^j];
end

lambda = X\Y';


plotmeshsize = 100;
x1_plot = linspace(xbound(1),xbound(2),plotmeshsize);
x2_plot = linspace(ybound(1),ybound(2),plotmeshsize);
[X1_plot, X2_plot] = meshgrid(x1_plot, x2_plot);
X_plot = ones(numel(X1_plot), 1);

% Evaluate the basis functions at grid points
for j = 1:basis
    X_plot = [X_plot, X1_plot(:).^j, X2_plot(:).^j];
end

Y_model = X_plot*lambda;
Y_model = reshape(Y_model, size(X1_plot));
%% TEST ERRORS AND SO ON
N_test = 4; %CHOOSE NUMBER OF FUNCTION EVALUATIONS
% Generate random points
test_points = LHS(N_test,[xbound;ybound]);
wrapped_f = @(row) exercise_1_function(test_points(row,:)); %til að geta gert vector evaluation á f
tic
Y_test = arrayfun(wrapped_f,1:N_test);
toc
%%
% Evaluate the basis functions at test points
X_test = ones(N_test,1);
for j = 1:basis
    X_test = [X_test, test_points(:,1).^j, test_points(:,2).^j];
end
Y_predicted = X_test*lambda;
error = rmse(Y_test',Y_predicted);
sprintf('Root mean square error = %f',error)
%% PLOTS 
figure;
surf(X1_plot, X2_plot, Y_model,'DisplayName','Model');
alpha(0.5)
xlabel('x1');
ylabel('x2');
zlabel('Y');
hold on 
plot3(inputMatrix(:,1), inputMatrix(:,2), Y', 'ro', 'MarkerSize', 10, 'MarkerFaceColor', 'r','DisplayName','Training points');
title('Linear Regression Prediction with Quadratic Basis Functions');
plot3(test_points(:,1), test_points(:,2), Y_predicted, 'b.', 'MarkerSize', 20, 'MarkerFaceColor', 'b','DisplayName','Testing Points prediction');
plot3(test_points(:,1), test_points(:,2), Y_test, 'black.', 'MarkerSize', 20, 'MarkerFaceColor', 'b','DisplayName','True Y at testing points');
legend()



