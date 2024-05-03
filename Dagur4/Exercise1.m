eff1 = @(x) (x-2).^2;
eff2 = @(x) x.^2+3*exp(-2*x);
tol = 1e-3;

[value,index]=max(eff1([1,-6,3,4,5]))