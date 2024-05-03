eff1 = @(x) (x-2).^2;
eff2 = @(x) x.^2+3*exp(-2*x);
tol = 1e-5;
x1 = 0;
x2 = 10;

subplot(1,2,1)
title('$(x-2)^2$','Interpreter','latex')
goldensearch(eff1,x1,x2,tol);
subplot(1,2,2)
title('$x^2+3e^{-2x}$','Interpreter','latex')
goldensearch(eff2,x1,x2,tol);
