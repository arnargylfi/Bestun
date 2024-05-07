f = @(X) sum((1-X(1:end-1)).^2+100.*(X(2:end)-X(1:end-1).^2).^2);
options = optimset('Display','iter','TolX',1e-8,'TolFun',1e-8,'MaxFunEvals',100000,'MaxIter',100000);
for n = [3,5,10]
    fprintf('Minimizing Rosenbrock function with fminunc, n = %d',n)
    X0 = zeros(1,n);
    fminunc(f,X0,options)
    pause(0.5)
end

%%

for n = [3,5,10]
    fprintf('Minimizing Rosenbrock function with fminsearch, n = %d',n)
    X0 = zeros(1,n);
    fminsearch(f,X0,options)
    pause(0.5)
end

