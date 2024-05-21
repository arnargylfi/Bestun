clear
f1 = @(X) 2*X(:,1).^2 + 3*X(:,2).^2 - 3*X(:,1).*X(:,2) + X(:,1);
minimum1 = -2;
maximum1 = 8;
P1 = [5,8];

f2 = @(X) (1-X(:,1)).^2+5*(X(:,1)-X(:,2).^2).^2;
minimum2 = -0.5;
maximum2 = 1.5;
P2 = [0,0];

f3 = @(X) (X(:,1)+2*X(:,2)).*(1-0.9.*exp(-0.3*(X(:,1)-2.5).^2-2*(X(:,2)-3.5).^2)).*(1-0.9*exp(-(X(:,1)-3).^2-(X(:,2)-3).^2));
minimum3 = 1;
maximum3 = 5;
P3 = [4,2];

f4 = @(X) exp(X(:,1)./5)+exp(X(:,2)./3);
minimum4 = -10;
maximum4 = 10;
P4 = [5,8];

result1 = PatternSearch(P1,f1,1,minimum1,maximum1, 0.01);
result2 = PatternSearch(P2,f2,1,minimum2,maximum2, 0.01);
result3 = PatternSearch(P3,f3,1,minimum3,maximum3, 0.01);
result4 = PatternSearch(P4,f4,1,minimum4,maximum4, 0.01);
xmin1 = result1(end,1:2);
xmin2 = result2(end,1:2);
xmin3 = result3(end,1:2);
xmin4 = result4(end,1:2);

% Define the functions
func1 = @(x, y) 2*x.^2 + 3*y.^2 - 3*x*y + x;
func2 = @(x, y) (1 - x).^2 + 5*(x - y.^2).^2;
func3 = @(x, y) (x + 2*y) * (1 - 0.9*exp(-0.3*(x - 2.5).^2 - 2*(y - 3.5).^2)) * (1 - 0.9*exp(-(x - 3).^2 - (y - 3).^2));
func4 = @(x, y) exp(x/5) + exp(y/3);

% Bounds and start points
bounds1 = [-2 8; -2 8];
bounds2 = [-0.5 1.5; -0.5 1.5];
bounds3 = [1 5; 1 5];
bounds4 = [-10 10; -10 10];
start1 = [5; 8];
start2 = [0; 0];
start3 = [4; 2];
start4 = [5; 8];

figure(1)
plot2D(func1, bounds1, xmin1, result1(:,1:2));
figure(2)
plot2D(func2, bounds2, xmin2, result2(:,1:2));
figure(3)
plot2D(func3, bounds3, xmin3, result3(:,1:2));
figure(4)
plot2D(func4, bounds4, xmin4, result4(:,1:2));
figure(5)
plot3D(func1, bounds1, xmin1, result1(:,1:2), [-45, 30]);
figure(6)
plot3D(func2, bounds2, xmin2, result2(:,1:2), [125, 60]);
figure(7)
plot3D(func3, bounds3, xmin3, result3(:,1:2), [-100, 50]);
figure(8)
plot3D(func4, bounds4, xmin4, result4(:,1:2), [-45, 30]);
figure(9)
plot3DZoom(func1, xmin1, result1(:,1:2), [-45, 50]);
figure(10)
plot3DZoom(func2, xmin2, result2(:,1:2), [125,60]);
figure(11)
plot3DZoom(func3, xmin3, result3(:,1:2), [-100, 50]);
figure(12)
plot3DZoom(func4, xmin4, result4(:,1:2), [-45, 30]);