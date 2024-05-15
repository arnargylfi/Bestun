clear
plotmeshsize = 20;
x=linspace(-3,3,plotmeshsize);
y=linspace(-3,3,plotmeshsize);
[xi,yi]=meshgrid(x,y);

for j=1:length(x)
    for k=1:length(y)
        zi(k,j)=exercise_3_function([x(j) y(k)]'); 	% evaluate function f
    end
end
mesh(xi,yi,zi); 				% surface plot of the function f
hold on


centers_x = linspace(min(x), max(x), plotmeshsize);
centers_y = linspace(min(y), max(y), plotmeshsize);
[centers_xi, centers_yi] = meshgrid(centers_x, centers_y);
centers = [centers_xi(:), centers_yi(:)];

%Gaussian basis functions
N = 9;
xgrid=linspace(-3,3,N);
ygrid=linspace(-3,3,N);
[X,Y]=meshgrid(xgrid,ygrid);
phi = zeros(N);
% Compute distances
for i = 1:N
    distances(i, :) = sqrt((X(i,:) - X(1,1)).^2 + (Y(i,:) - Y(1,1)).^2);
end
