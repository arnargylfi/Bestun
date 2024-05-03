format short
eff1 = @(x) (x-2).^2;
eff2 = @(x) x.^2+3*exp(-2*x);
tol = 1e-5;
x1 = 0;
x2 = 10;
figure()
subplot(1,2,1)
[iter1,func_min1,x_min1] = goldensearch(eff1,x1,x2,tol);
title(sprintf('$f(x) = (x-2)^2$, $(x,f(x))_{\\mathrm{min}} = (%f, %f)$, number of iterations $= %d$', x_min1, func_min1, iter1),'Interpreter','latex','FontSize',12)
subplot(1,2,2)
[iter2,func_min2,x_min2] = goldensearch(eff2,x1,x2,tol);
title(sprintf('$f(x) = x^2+3e^{-2x}$, $(x,f(x))_{\\mathrm{min}} = (%f, %f)$, number of iterations $= %d$', x_min2, func_min2, iter2),'Interpreter','latex','FontSize',12)
sgtitle('Golden Ratio search for minima of two functions')
