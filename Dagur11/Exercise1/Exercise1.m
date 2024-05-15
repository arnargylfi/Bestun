% clear
load("exercise_1_data.mat")
n = 200;
x = 1:length(Y);
X = [ones(length(x),1) sin(x)' cos(x)'];
for i = 2:n
    X = [X sin(i*x)' cos(i*x)'];
    lambda = inv(X'*X)*X'*Y';
    Y_pred = X*lambda;
    plot(x, Y, 'bo', x, Y_pred, 'r-', 'LineWidth', 2);
    title(['Regression function for n = ' num2str(i)]);
    xlabel('x');
    ylabel('y');
    legend('Data', 'Regression', 'Location', 'northwest');

end

