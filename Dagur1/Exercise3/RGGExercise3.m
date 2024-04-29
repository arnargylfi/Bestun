clear all;close all; clc;

obstaclePathfinder(10,0.2);

function obstaclePathfinder(N,P)
    grid = zeros(N, N);
    numObstacles = round(P * N * N);
    obstacles = randperm(N*N, numObstacles);
    grid(1,:) = 1;
    grid(obstacles) = -1;

    % A* pathfinding from bottom to top
    startNodes = find(grid(1,:) == 1); % All non-obstacle nodes at bottom
    endNodes = find(grid(N,:) == 0);   % All non-obstacle nodes at top
    disp(startNodes)
    disp(endNodes)
    path = [];
        
    for i=1:N
        for j=1:N
            if grid(i,j) >=0
                neighbours = [i+1 j;i 1-j;i 1+j];
                if grid(i,j+1)
                if j==1 || j==N
                   
                end
            end
        end
        if j==N && find(grid(N,:) > 0)
                    disp('Path found!')
                    pathFound = True;
                    endNode = grid(i,j);
                    break;
        end
    end
    % Try finding a path from any bottom edge node to any top edge node
    for start = startNodes
        for finish = endNodes
            [localPath, pathFound] = PathFinder(grid, [1, start], [N, finish]);
            if pathFound
                path = localPath;
                break;
            end
        end
        if pathFound
            break;
        end
    end
    
    % Plotting the grid
    figure;
    hold on;
    axis equal;
    xlabel('Column Index');
    ylabel('Row Index');
    title('Pathfinding in Grid with Obstacles');
    % Mark obstacles
    [obstX, obstY] = find(grid == 1);
    plot(obstX, obstY, 'ro', 'MarkerFaceColor', 'r');
    % Plot path if found
    if ~isempty(path)
        plot(path(:,2), path(:,1), 'b-o', 'LineWidth', 2, 'MarkerFaceColor', 'b');
    end
    hold off;
end

function [path, pathFound] = PathFinder(grid, startNode, endNode)
    firstNode = startNode;
    cameFrom = zeros()
    disp(startNode);
    disp(endNode);
    pathFound = false;
    path = [];
end

% function [path, pathFound] = PathFinder(grid, startNode, endNode)
%     % A* pathfinding setup
%     openSet = startNode;
%     cameFrom = zeros(size(grid, 1), size(grid, 2), 2); % To reconstruct path
%     gScore = inf(size(grid));
%     gScore(startNode(1), startNode(2)) = 0;
%     fScore = inf(size(grid));
%     fScore(startNode(1), startNode(2)) = heuristic(startNode, endNode);
% 
%     while ~isempty(openSet)
%         % Current node is the one with the lowest fScore
%         [~, idx] = min(fScore(:));
%         [currentX, currentY] = ind2sub(size(fScore), idx);
%         current = [currentX, currentY];
% 
%         % Check if reached the end node
%         if current == endNode
%             path = reconstructPath(cameFrom, current);
%             pathFound = true;
%             return;
%         end
% 
%         % Remove current from open set
%         openSet(openSet(:,1) == currentX & openSet(:,2) == currentY, :) = [];
%         fScore(currentX, currentY) = inf; % Remove from fScore consideration
% 
%         % Neighbor nodes (horizontal and vertical moves)
%         neighbors = [current + [1, 0]; current - [1, 0]; current + [0, 1]; current - [0, -1]];
%         neighbors = neighbors(neighbors(:,1) > 0 & neighbors(:,1) <= size(grid, 1) & ...
%                               neighbors(:,2) > 0 & neighbors(:,2) <= size(grid, 2) & ...
%                               grid(sub2ind(size(grid), neighbors(:,1), neighbors(:,2))) == 0);
% 
%         % Loop through neighbors
%         for i = 1:size(neighbors,1)
%             neighbor = neighbors(i,:);
%             tentative_gScore = gScore(currentX, currentY) + 1; % Distance to neighbors is 1
%             if tentative_gScore < gScore(neighbor(1), neighbor(2))
%                 % This path to neighbor is better than any previous one
%                 cameFrom(neighbor(1), neighbor(2), :) = current;
%                 gScore(neighbor(1), neighbor(2)) = tentative_gScore;
%                 fScore(neighbor(1), neighbor(2)) = gScore(neighbor(1), neighbor(2)) + heuristic(neighbor, endNode);
%                 if isempty(find(openSet(:,1) == neighbor(1) & openSet(:,2) == neighbor(2), 1))
%                     openSet(end+1, :) = neighbor; % Add to open set if not already there
%                 end
%             end
%         end
%     end
%     path = [];
%     pathFound = false;
% end

function h = heuristic(node, goal)
    % Simple Euclidean distance
    h = sqrt(sum((node - goal) .^ 2));
end

function path = reconstructPath(cameFrom, current)
    % Reconstruct path from cameFrom map
    path = current;
    while any(cameFrom(current(1), current(2), :))
        current = squeeze(cameFrom(current(1), current(2), :))';
        path = [current; path];
    end
end
