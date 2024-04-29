clear all, close all, clc;
% Create grid

PathFinder(30,0.4);

function PathFinder(N, P)
    if N<1 || P<0 || P>1
        disp('Invalid N or P')
        return
    end
    [x, y] = meshgrid(1:N, 1:N);
    
    % Obstacle density
    obstacles = rand(N) < P;
    Playing_board = [1 1;1 N;N N;N 1;1 1];
    
    % Visualize grid and obstacles
    figure; hold on;
    axis([0 N+1 0 N+1]);
    plot(Playing_board(:,1), Playing_board(:,2), 'c-', 'LineWidth', 1);
    plot(x(:), y(:), 'b.');
    plot(x(obstacles), y(obstacles), 'ro', 'MarkerSize', 7.5);
    
    % Create a grid that marks the obstacles and visited cells
    grid = zeros(N,N);
    grid(obstacles) = -1;
    
    lastPos = [];
    for i = 1:N
        if grid(N, i) == 0
            lastPos(end+1, :) = [N, i]; % Add starting points (bottom row, without obstacles)
            grid(N, i) = 1; % Mark as visited
        end
    end
    
    found = false;
    while ~isempty(lastPos)
        current = lastPos(1, :);
        lastPos(1, :) = []; %Reset
        r = current(1);
        c = current(2);
    
        % Check if we've reached the top row
        if r == 1
            found = true;
            final_r = r;
            final_c = c;
            break;
        end
    
        % Visit neighbors (up, down, left, right)
        directions = [0, 1; 0, -1; -1, 0; 1, 0];
        for i = 1:size(directions, 1)
            nr = r + directions(i, 1);
            nc = c + directions(i, 2);
            if nr > 0 && nr <= N && nc > 0 && nc <= N && grid(nr, nc) == 0
                lastPos(end+1, :) = [nr, nc];
                grid(nr, nc) = grid(r, c) + 1; %Mark as visited
            end
        end
    end
    
    if found
        % Initialize arrays to store path coordinates
        path_x = [];
        path_y = [];
        
        % Trace back the path
        path_r = final_r;
        path_c = final_c;
        path_x(end+1) = path_c; % Store the final column
        path_y(end+1) = path_r; % Store the final row
    
        while grid(path_r, path_c) > 1 % Continue until reaching the start point
            % Move to the previous cell in the path
            directions = [0, 1; 0, -1; -1, 0; 1, 0];
            for i = 1:size(directions, 1)
                nr = path_r + directions(i, 1);
                nc = path_c + directions(i, 2);
                if nr > 0 && nr <= N && nc > 0 && nc <= N && grid(nr, nc) == grid(path_r, path_c) - 1
                    path_r = nr;
                    path_c = nc;
                    path_x(end+1) = path_c; % Store the column
                    path_y(end+1) = path_r; % Store the row
                    break;
                end
            end
        end
        
        % Reverse the path coordinates since we traced back from the goal
        path_x = fliplr(path_x);
        path_y = fliplr(path_y);
        
        % Plot the path as a line
        plot(path_x, path_y, 'g-', 'LineWidth', 2); % Green line for the path
        disp('Path found!');
        fprintf('length of path = %d\n', length(path_x))
    else
        disp('No path available.');
    end
end

