clear all
%%

obstaclePathfinder(20,0.2);

function obstaclePathfinder(N,P)
    [x,y] = meshgrid(1:N, 1:N); %Create grid

    obstacles = rand(N) > 1-P; 
    %%
    %VISUALIZE GRID
    % plot(x,y,'b.') 
    
    %VISUALIZE OBSTACLES
    plot(x(obstacles == 1),y(obstacles == 1),'ro','MarkerSize',7.5)
    
    % sum(obstacles(:))/(N*N) % real obstacle density
    %%
    y_now = 1;%
    x_now = 1;% starting point upper right
    path = [x_now y_now];
    skref = 0
    while y_now ~= N
    if obstacles(y_now,x_now) == 1
        x_now = x_now+1; 
        continue
    end
    if obstacles(y_now+1,x_now)  == 0
        y_now = y_now +1;
    elseif x_now+1<=N && obstacles(y_now,x_now+1) == 0
        x_now = x_now+1;
    elseif x_now-1>=1 && obstacles(y_now,x_now-1) == 0
        x_now = x_now+1;
    elseif y_now+1<=N && obstacles(y_now+1,x_now) == 0
        y_now = y_now+1;
    end
    path = [path;x_now y_now];
    skref = skref+1
    end
    
    hold on               %N+1-y flipping the y axis to align with matrix indeces
    plot(x(obstacles == 1),N+1-y(obstacles == 1),'ro','MarkerSize',7.5)
    plot(starting_point(1),starting_point(2), 'blacko','MarkerFaceColor','b','MarkerSize',10)
    hold off
end
