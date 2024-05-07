f = @(X) sum((1-X(1:end-1)).^2+100.*(X(2:end)-X(1:end-1).^2).^2);

for n = [3,5,10]
    X0 = zeros(1,n);
    fminunc(f,X0,)
end

