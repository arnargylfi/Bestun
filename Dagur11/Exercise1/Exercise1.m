clear all; close all;
load("exercise_1_data.mat")
x = linspace(0,15,length(Y));
X = [ones(length(x),1)];

% ANIMATE?? 
nv = 1:20;
for i = nv
    X = [X sin(i*x)' cos(i*x)'];
    lambda = (X'*X)\(X'*Y');
    Y_pred = X*lambda;
    plot(x, Y, 'blackx', x, Y_pred, 'r-', 'LineWidth', 2);
    title(['Regression function for n = ' num2str(i)]);
    xlabel('x');
    ylabel('y');
    legend('Data', 'Regression', 'Location', 'northwest');
    pause(0.7)
end

%% APPROXIMATION ERROR VS n
X = [ones(length(x),1)];
nv = 100;
error = zeros(nv,1);
for i = 1:nv
    X = [X sin(i*x)' cos(i*x)'];
    lambda = X\Y';
    Y_pred = X*lambda;
    error(i) = rmse(Y_pred,Y');
end
figure;
semilogy(1:nv,error)
grid on
title('Modeling error vs Model Order (n)')
xlabel('n')
ylabel('Root mean square error')




