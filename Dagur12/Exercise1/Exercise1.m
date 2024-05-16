clear

%BETA CORRELATION
f = @(x) exp(x/3)*0.1*x^2/(1+0.1*x^2);
c = @(x) exp(x/3);
diffriate = @(func, x0,epsilon) 0.5*(func(x0+epsilon)-func(x0-epsilon))/epsilon;

epsilon = 10e-6;
beta_correlation =@(f,c,x1,x) (f(x1)/c(x1)+( (x-x1)*(diffriate(f,x1,epsilon)*c(x1)-diffriate(c,x1,epsilon)*f(x1))/(c(x1))^2 ))*c(x);


x = -5:0.1:5;
figure(1)
x1 = 1;
subplot(1,2,1)
plot(x,arrayfun(@(xi) beta_correlation(f,c,x1,xi),x),'DisplayName','Surrogate of f at x_1 = 1')
hold on
plot(x,f(x1)+diffriate(f,x1,epsilon)*(x-x1),'r--','DisplayName','Tangent Line')
plot(x,arrayfun(f,x),'DisplayName','f(x)')
plot(x,arrayfun(c,x),'DisplayName','c(x)')
plot(x1,f(x1),'blacko','DisplayName','(x1,f(x1))')
title('x_1 = 1')
grid on
legend

subplot(1,2,2)
x1 = 3;
plot(x,arrayfun(@(xi) beta_correlation(f,c,x1,xi),x),'DisplayName','Surrogate of f at x_1 = 3')
hold on
plot(x,f(x1)+diffriate(f,x1,epsilon)*(x-x1),'r--','DisplayName','Tangent Line')
plot(x,arrayfun(f,x),'DisplayName','f(x)')
plot(x,arrayfun(c,x),'DisplayName','c(x)')
plot(x1,f(x1),'blacko','DisplayName','(x1,f(x1))')
title('x_1 = 3')
legend

sgtitle('Beta correlation for $$f(x) =  \exp(x/3)\cdot0.1\cdot\frac{x^2}{1+0.1x^2}$$','Interpreter','latex')
grid on
legend()

% GENERAL RESPONSE CORRECTION

general_response = @(f,c,x1,x) f(x1)+diffriate(f,x1,epsilon)/diffriate(c,x1,epsilon)*(c(x)-c(x1))

%IN practice one can choose g min_(𝑎∈𝑅) ||𝑎⋅𝑐′(𝑥^(𝑘))−𝑓′(𝑥^(𝑘))||_2

x = -5:0.1:5;
figure()
x1 = 1;
subplot(1,2,1)
plot(x,arrayfun(@(xi) general_response(f,c,x1,xi),x),'red','DisplayName','Surrogate of f at x_1 = 1')
hold on
plot(x,f(x1)+diffriate(f,x1,epsilon)*(x-x1),'r--','DisplayName','Tangent Line')
plot(x,arrayfun(f,x),'b','DisplayName','f(x)')
plot(x,arrayfun(c,x),'black','DisplayName','c(x)')
plot(x1,f(x1),'blacko','DisplayName','(x1,f(x1))')
title('x_1 = 1')
grid on
legend

subplot(1,2,2)
x1 = 3;
plot(x,arrayfun(@(xi) general_response(f,c,x1,xi),x),'r','DisplayName','Surrogate of f at x_1 = 3')
hold on
plot(x,f(x1)+diffriate(f,x1,epsilon)*(x-x1),'r--','DisplayName','Tangent Line')
plot(x,arrayfun(f,x),'b','DisplayName','f(x)')
plot(x,arrayfun(c,x),'black','DisplayName','c(x)')
plot(x1,f(x1),'blacko','DisplayName','(x1,f(x1))')
title('x_1 = 3')
legend

sgtitle('General response correction for $$f(x) =  \exp(x/3)\cdot0.1\cdot\frac{x^2}{1+0.1x^2}$$','Interpreter','latex')
grid on
legend()



