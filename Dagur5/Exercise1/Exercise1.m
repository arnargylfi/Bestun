func = @(X) 2*X(1).^2 + 3*X(2).^2 - 3*X(1).*X(2) + X(1);
x = linspace(-2,8,100);
y = linspace(-2,8,100);
[X, Y] = meshgrid(x,y);

% Evaluating the function at each point of the grid
Z = func([X(:), Y(:)])

% Reshape the result back to the size of X and Y
Z = reshape(Z, size(X))

% Plotting the contour
contour(X, Y, Z, 20);
xlabel('X');
ylabel('Y');
title('Contour Plot of the Vector-Valued Function');
