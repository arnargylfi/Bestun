f = @(X) exp(sum(X./(1:length(X))));
nonlcon = @(x) deal([], norm(x) - 1);

options = optimset('Display','iter','TolX',1e-8,'TolFun',1e-8);

for n = [2,3,4,20]
    fprintf('Minimizing f with fmincon, n = %d',n)
    X0 = zeros(1,n);
    fmincon(f,X0,[],[],[],[],[],[],nonlcon,options)
    pause(0.5)
end

