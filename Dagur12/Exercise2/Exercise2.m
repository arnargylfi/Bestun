clear all
x = (0:0.1:1.5)';
y = [1.0253, 0.8702, 0.5632, 0.1260, -0.2467, -0.5407, -0.6864, -0.5969,-0.4323, -0.0802, 0.2176, 0.4952, 0.6125, 0.5570, 0.4531, 0.2293]';

N = length(x);
dist = zeros(N);
for i = 1:N
    dist(i,:) = sqrt(sum(([x(i),y(i)]-[x y]).^2,2));
end

Phifun = @(r,c) exp(-c*r.^2);
c = 4;
Phi = Phifun(dist,c);
lambda = Phi\y;

X = (0:0.01:1.5)';
sx = zeros(length(X),1);
for i = 1:length(X)
    sum = 0;
    for j = 1:N
        sum = sum + lambda(j) * Phifun(norm(X(i) - x(j)), c);
    end
    sx(i) = sum;
end


scatter(x,y,'kx','SizeData',60)
hold on 
plot(X,sx)
