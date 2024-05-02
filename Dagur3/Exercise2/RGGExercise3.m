N = 60; % Number of rectangles
W = 12; % Width of the bin
% Generate random widths and heights for each rectangle
widths = randi([1, 3], N, 1);
heights = randi([3, 10], N, 1);

% Initial random order of rectangles
rectangles = [widths heights];

[positions, totalHeight] = placeRectangles(W, N, rectangles(:,1),rectangles(:,2));

figure;
hold on;
axis([0 W 0 totalHeight]); % Make sure the axis starts from 0
for i = 1:size(rectangles, 1)
    rectangle('Position', [positions(i,1), positions(i,2), rectangles(i,1), rectangles(i,2)], ...
              'FaceColor', [rand rand rand]);
end
title(sprintf('Initial Packing with Total Height: %d', totalHeight));
xlabel('Width');
ylabel('Height');
hold off;

function [positions, binHeight] = placeRectangles(W, N, w, h)
    % Initialize the height array for the bin
    heights = zeros(1, W);
    
    % Initialize positions array to store the bottom-left corner (x, y) of each rectangle
    positions = zeros(N, 2);
    
    % Loop through each rectangle
    for i = 1:N
        % Initialize minimum height found for the rectangle
        minHeight = inf;
        bestX = 0;

        % Try placing the rectangle at every possible x position
        for x = 1:(W - w(i) + 1)
            % Maximum height in the range that the rectangle would occupy
            maxH = max(heights(x:x+w(i)-1));
            
            % Check if this position is better (lower) than what we have found so far
            if maxH < minHeight
                minHeight = maxH;
                bestX = x;
            end
        end

        % Place the rectangle at the best found position
        positions(i, :) = [bestX - 1, minHeight]; % Subtract 1 here for zero-based x-coordinate
        
        % Update the heights array to reflect the added rectangle
        heights(bestX:bestX+w(i)-1) = minHeight + h(i);
    end
    
    % The maximum height in the heights array is the total height used
    binHeight = max(heights);
end
