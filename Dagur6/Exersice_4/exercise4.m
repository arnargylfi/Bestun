clear all, close all, clc

n_values = [3, 5, 10, 20];
fig = figure;
for i = 1:length(n_values)
    n = n_values(i);
    x0 = ones(1, n)./ n;
    fun = @(x) max(black_box(x));
    Aeq = ones(1, n);
    beq = 1;
    lb = zeros(n, 1);

    options = optimset('Display','iter','TolX',1e-8,'TolFun',1e-8,'Algorithm', 'sqp');
    [x_opt, fval_opt] = fmincon(fun, x0, [], [], Aeq, beq, lb, [], [], options);

    %Plot
    subplot(2, 4, i);
    hold on;
    stem(1:n, x0, 'filled', 'Marker', 'o', 'Color', 'k');
    stem(1:n, x_opt, 'filled', 'Marker', 's', 'Color', 'r');
    grid on
    title(['Arguments for n = ', num2str(n)]);
    %xlabel('Index');
    %ylabel('Argument Value');
    legend('Initial', 'Optimized', 'location', 'northwest');
    hold off;

    subplot(2, 4, i + 4); 
    hold on;
    stem(1:n, black_box(x0), 'filled', 'Marker', 'o', 'Color', 'k');
    stem(1:n, black_box(x_opt), 'filled', 'Marker', 's', 'Color', 'r');
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
