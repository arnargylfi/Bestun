clear all, close all, clc
N = 50; % Number of rectangles
W = 6; % Width of the bin
iterations = 100;
% Generate random widths and heights for each rectangle
widths = randi([1, W/2], N, 1);
heights = randi([1, W/2], N, 1);

% Initial random order of rectangles
rectangles = [widths heights];

% Pack the rectangles
[positions_initial, totalHeight_initial] = packRectangles(rectangles, W);
[positions_optimized, totalHeight_optimized, newRectangles] = optimizedPacking(rectangles, W, iterations);

% Determine maximum height for consistent y-axis in plots
maxHeight = totalHeight_initial;

% Plotting both packings in subplots
figure;
subplot(1, 2, 1); % First subplot
hold on;
axis([-2 W+2 0 maxHeight]);
colors = lines(N); % Generate N distinct colors
for i = 1:N
    rectangle('Position', [positions_initial(i, 1), positions_initial(i, 2), rectangles(i, 1), rectangles(i, 2)], ...
              'EdgeColor', 'k', 'FaceColor', colors(i,:), 'LineWidth', 2);
end
title(['Initial Placement height = ', num2str(totalHeight_initial)]);
xlabel('Width');
ylabel('Height');
hold off;

subplot(1, 2, 2); % Second subplot
hold on;
axis([-2 W+2 0 maxHeight]);
for i = 1:N
    rectangle('Position', [positions_optimized(i, 1), positions_optimized(i, 2), newRectangles(i, 1), newRectangles(i, 2)], ...
              'EdgeColor', 'k', 'FaceColor', colors(i,:), 'LineWidth', 2);
end
title(['Optimized Placement height = ', num2str(totalHeight_optimized)]);
xlabel('Width');
ylabel('Height');
hold off;


%%


function [positions, totalHeight, newRectangles] = optimizedPacking(rectangles, W, iterations)
    currentRectangles = rectangles;
    [currentPositions, currentTotalHeight] = packRectangles(currentRectangles, W);  % Corrected line
    firstHeight = currentTotalHeight
    figure; % Create a new figure for animation
    colors = lines(size(rectangles, 1)); % Generate distinct colors for each rectangle

    for iter = 1:iterations
        % Create a new candidate by swapping two rectangles
        newRectangles = currentRectangles;
        idx1 = randi(size(newRectangles, 1));
        idx2 = randi(size(newRectangles, 1));
        % Swap the rectangles
        temp = newRectangles(idx1, :);
        newRectangles(idx1, :) = newRectangles(idx2, :);
        newRectangles(idx2, :) = temp;

        % Randomly flip orientation of one rectangle
        if rand() > 0.5
            newRectangles(idx1, :) = newRectangles(idx1, [2 1]);
        end
        if rand() > 0.5
            newRectangles(idx2, :) = newRectangles(idx2, [2 1]);
        end

        % Calculate new packing
        [newPositions, newTotalHeight] = packRectangles(newRectangles, W);

        % Update the figure for animation
        clf; % Clear current figure window
        hold on;
        axis([-2 W+2 0 firstHeight+5]);
        for i = 1:size(rectangles, 1)
            rectangle('Position', [newPositions(i, 1), newPositions(i, 2), newRectangles(i, 1), newRectangles(i, 2)], ...
                      'EdgeColor', 'k', 'FaceColor', colors(i,:), 'LineWidth', 2);
        end
        title(['Iteration: ', num2str(iter), ' Height: ', num2str(newTotalHeight)]);
        drawnow; % Update the figure window
        hold off;

        % Accept new configuration if it improves or maintains the total height
        if newTotalHeight <= currentTotalHeight
            currentRectangles = newRectangles;
            positions = newPositions;
            currentTotalHeight = newTotalHeight;
        end
    end

    totalHeight = currentTotalHeight;  % Return the best found total height
end






function [positions, totalHeight] = packRectangles(rectangles, W)
    N = size(rectangles, 1);  % Number of rectangles
    positions = zeros(N, 2);  % Store x, y positions of rectangles
    skyline = zeros(W, 1);  % Height at each x position of the bin

    for i = 1:N
        width = rectangles(i, 1);
        height = rectangles(i, 2);

        % Find position to place rectangle
        [bestX, bestY] = findPosition(width, height, skyline);
        if bestX == -1
            error('No valid position found for a rectangle. Check rectangle dimensions and bin width.');
        end
        positions(i, :) = [bestX, bestY];

        % Update skyline
        for j = bestX+1:bestX+width
            skyline(j) = bestY + height;
        end
    end

    totalHeight = max(skyline);  % Max height of skyline is total height used
end

function [bestX, bestY] = findPosition(width, height, skyline)
    bestY = inf;
    bestX = -1;
    W = length(skyline);

    % Check each position along the bin width
    for x = 1:W-width+1
        % Maximum y at the position
        maxH = max(skyline(x:x+width-1));
        if maxH < bestY
            bestY = maxH;
            bestX = x - 1;
        end
    end

    if bestX == -1
        bestX = 0; 
    end
end



