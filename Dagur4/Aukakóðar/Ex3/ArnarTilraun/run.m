f1 = @(X) sum(X.^2);
n = 10;
X1 = 1:n;

f2 = @(x) sin(x);
x2 = 2;

X3 = [5 3];
f3 = @(X) exp(X(1)/5+X(2)/2)+X(1)^2+X(2)^2;
[x_min,func_min] = trustRegion(f3,X3);

