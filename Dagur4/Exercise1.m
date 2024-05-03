eff1 = @(x) (x-2).^2;
eff2 = @(x) x.^2+3*exp(-2*x);
tol = 1e-5;
x1 = 0;
x2 = 10;

goldensearch(eff1,x1,x2,tol)
2