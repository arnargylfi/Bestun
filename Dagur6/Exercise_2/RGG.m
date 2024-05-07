n_values = [2, 3, 4, 20];

for n = n_values
    objective = @(x) exp(sum(x ./ (1:n)));
    x0 = zeros(1,n);
    nonlcon = @(x) deal([], norm(x) - 1);

    options = optimoptions('fmincon', 'Display', 'iter', 'Algorithm', 'interior-point');
    [x_min, f_min, exitflag, output] = fmincon(objective, x0, [], [], [], [], [], [], nonlcon, options);
    
    %Print results
    fprintf('Results for n = %d:\n', n);
    fprintf('Minimum value: %f\n', f_min);
    fprintf('Solution x: ');
    disp(x_min');
    fprintf('Norm of x: %f\n', norm(x_min));
end
