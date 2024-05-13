% Parameters
N = 100;
generations = 200;
pc = 0.7;
pm = 0.1;
sigmas = 0.5; % Sharing distance
ffdimensions = 8;
ffbounds = [-2 2;-2 2;-2 2;-2 2;-2 2;-2 2;-2 2;-2 2];
MOEARGG(@ff, ffbounds, N, generations, pc, pm, sigmas, ffdimensions, true);

function objectives = ft(x)
    % Ensure the input vector x has at least three elements
    if length(x) < 3
        error('Input vector x must have at least three elements.');
    end
    
    % Extract variables
    x1 = x(1);
    x2 = x(2);
    x3 = x(3);

    % Define f_t1
    ft1 = x1;

    % Define f_t2
    ft2 = (1/x1) * (1 + (x2^2 + x3^2)^0.25 * sin(50 * (x2^2 + x3^2)^0.1)^2 + 1);

    % Combine objectives
    objectives = [ft1, ft2];
end

function objectives = ff(x)
    % Check if the input vector x has exactly 8 elements
    if length(x) ~= 8
        error('Input vector x must have exactly eight elements.');
    end
    
    % Pre-compute the constant for efficiency
    oneOverSqrt8 = 1/sqrt(8);

    % Calculate the first objective function, ff1
    sumSq1 = sum((x - oneOverSqrt8).^2);
    ff1 = 1 - exp(-sumSq1);

    % Calculate the second objective function, ff2
    sumSq2 = sum((x + oneOverSqrt8).^2);
    ff2 = 1 - exp(-sumSq2);

    % Combine objectives
    objectives = [ff1, ff2];
end