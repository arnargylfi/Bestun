clear all, close all, clc
N = 30; % Number of rectangles
W = 12; % Width of the bin
% Generate random widths and heights for each rectangle
widths = randi([1, 3], N, 1);
heights = randi([3, 10], N, 1);

% Initial random order of rectangles
rectangles = [widths heights];

% Pack the rectangles
[positions, totalHeight] = packRectangles(rectangles, W);


% Plotting the rectangles
figure;
hold on;
axis([0 W 0 totalHeight]);
colors = lines(N); % Generate N distinct colors

for i = 1:N
    rectangle('Position', [positions(i, 1), positions(i, 2), rectangles(i, 1), rectangles(i, 2)], ...
              'EdgeColor', 'k', 'FaceColor', colors(i,:), 'LineWidth', 2);
end
title('Rectangle Placement');
xlabel('Width');
ylabel('Height');
hold off;

function [positions, totalHeight] = packRectangles(rectangles, W)
    N = size(rectangles, 1);  % Number of rectangles
    positions = zeros(N, 2);  % Store x, y positions of rectangles
    skyline = zeros(W, 1);  % Height at each x position of the bin

    for i = 1:N
        width = rectangles(i, 1);
        height = rectangles(i, 2);

        % Find position to place rectangle
        [bestX, bestY] = findPosition(width, height, skyline);
        positions(i, :) = [bestX, bestY];

        % Update skyline
        for j = bestX+1:bestX+width
            skyline(j) = bestY + height;
        end
    end

    totalHeight = max(skyline);  % Max height of skyline is total height used

    function [bestX, bestY] = findPosition(width, height, skyline)
        bestY = inf;
        bestX = -1;

        % Check each position along the bin width
        for x = 1:W-width+1
            % Maximum y at the position
            maxH = max(skyline(x:x+width-1));
            if maxH < bestY
                bestY = maxH;
                bestX = x - 1;
            end
        end
    end
end


