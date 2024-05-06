func = @(X) 2*X(:,1).^2 + 3*X(:,2).^2 - 3*X(:,1).*X(:,2) + X(:,1);
x = linspace(-2,8,100);
y = linspace(-2,8,100);
[X, Y] = meshgrid(x,y);

Z = func([X(:), Y(:)]);

Z = reshape(Z, size(X));


contour(X, Y, Z, 20);
xlabel('X');
ylabel('Y');
title('Contour Plot of the Vector-Valued Function');
