%create grid
N = 20;
[x,y] = meshgrid(1:N, 1:N); %Create grid

P = 0.5; %Obstacle density
obstacles = rand(N) > 1-P; 
%%
%VISUALIZE GRID
% plot(x,y,'b.') 

%VISUALIZE OBSTACLES
% plot(x(obstacles == 1),y(obstacles == 1),'ro','MarkerSize',7.5)
% sum(obstacles(:))/(N*N) % real obstacle density

