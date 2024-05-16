clear 
x = (0:0.1:1.5)';
y = [1.0253, 0.8702, 0.5632, 0.1260, -0.2467, -0.5407, -0.6864, -0.5969,-0.4323, -0.0802, 0.2176, 0.4952, 0.6125, 0.5570, 0.4531, 0.2293]';

N = length(x);
dist = zeros(N);
for i = 1:N
    dist(i,:) = sqrt(sum((x(i)-x).^2,2));
end

Phifun = @(r,c) exp(-c*r.^2);
c = 500;
Phi = Phifun(dist,c);
lambda = Phi\y;

X = (0:0.01:1.5)';
sx = zeros(length(X),1);
for i = 1:length(X)
    summa = 0;
    for j = 1:N
        summa = summa + lambda(j) * Phifun(norm(X(i) - x(j)), c);
    end
    sx(i) = summa;
end


scatter(x,y,'kx','SizeData',60)
hold on 
plot(X,sx)


%%
% Cross validation 
error = zeros(8,1);
average_error = [];
c_best_sum = 0;
for groups = 0:7
    xtest = x(2*groups+1:2*groups+2);
    ytest = y(2*groups+1:2*groups+2);
    ytrain = y;
    ytrain(2*groups+1:2*groups+2) = [];
    xtrain = x;
    xtrain(2*groups+1:2*groups+2) = [];
    N = length(xtrain);
    dist = zeros(N);
    for i = 1:N
        dist(i,:) = sqrt(sum((xtrain(i)-xtrain).^2,2));
    end
    error = [];
    for c = 2:1000
        Phifun = @(r,c) exp(-c*r.^2);
        Phi = Phifun(dist,c);
        lambda = Phi\ytrain;
        
        sx = zeros(length(xtest),1);
        for i = 1:length(xtest)
            summa = 0;
            for j = 1:N
                summa = summa + lambda(j) * Phifun(norm(xtest(i) - xtrain(j)), c);
            end
            sx(i) = summa;
        end
        error = [error,mean(sqrt((sx-ytest).^2))];
    end
    average_error = [average_error;error];
    [min_error,min_idx] = min(error);
    c_best = 1+min_idx
    c_best_sum = c_best_sum+c_best;
end
average_error = mean(average_error,1);
cbestavg = c_best_sum/8
loglog(2:1000,average_error)
ylabel('Average error between all groupings')
xlabel('c')
grid on






