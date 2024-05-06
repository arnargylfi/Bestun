f1 = @(x,y) 2*x.^2+3*y.^2-3*x.*y+x;
x = linspace(-2,10,100);
y = linspace(-10,8,100);
[X, Y] = meshgrid(x,y);
 
Z = f1(X,Y);
contour(X, Y, Z,20)