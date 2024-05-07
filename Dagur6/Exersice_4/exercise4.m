clear all, close all, clc

n_values = [3, 5, 10, 20];
options = optimset('Display','iter','TolX',1e-8,'TolFun',1e-8,'Algorithm', 'sqp');
fig = figure;
for i = 1:length(n_values)
    n = n_values(i);
    x0 = ones(1, n)./ n; % Initial guess
    % Objective function: max element of f(x)
    fun = @(x) max(black_box(x));
    % Linear equality constraints: sum(x) = 1
    Aeq = ones(1, n);
    beq = 1;
    % Lower bounds
    lb = zeros(n, 1);

    % Run optimization
    [x_opt, fval_opt] = fmincon(fun, x0, [], [], Aeq, beq, lb, [], [], options);

    % Display and plot results for function arguments 
    subplot(2, 4, i);
    hold on;
    stem(1:n, x0, 'filled', 'Marker', 'o', 'Color', 'k'); % Initial arguments in black
    stem(1:n, x_opt, 'filled', 'Marker', 's', 'Color', 'r'); % Optimized arguments in red
    grid on
    title(['Arguments for n = ', num2str(n)]);
    %xlabel('Index');
    %ylabel('Argument Value');
    legend('Initial', 'Optimized', 'location', 'northwest');
    hold off;

    % Display and plot results for function values 
    subplot(2, 4, i + 4); 
    hold on;
    stem(1:n, black_box(x0), 'filled', 'Marker', 'o', 'Color', 'k'); % Initial values in black
    stem(1:n, black_box(x_opt), 'filled', 'Marker', 's', 'Color', 'r'); % Optimized values in red
    grid on
    title(['Values for n = ', num2str(n)]);
    %xlabel('Index');
    %ylabel('Function Value');
    legend('Initial', 'Optimized', 'location', 'northeast');
end

han=axes(fig,'visible','off'); 
han.Title.Visible='on';
han.XLabel.Visible='on';
han.YLabel.Visible='on';
ylabel(han,'Function Values');
xlabel(han,'Indices');
hold off;
