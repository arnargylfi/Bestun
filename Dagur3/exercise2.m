clear all, close all, clc
N = 50; % Number of rectangles
W = 6; % Width of the bin
iterations = 100;
% Generate random widths and heights for each rectangle
widths = randi([1, W], N, 1);
heights = randi([1, W], N, 1);

% Initial random order of rectangles
rectangles = [widths heights];

% create animation of the optimization itterations
animate = true;

% Pack the rectangles
[positions_initial, totalHeight_initial] = packRectangles(rectangles, W);
[positions_optimized, totalHeight_optimized, newRectangles] = optimizedPacking(rectangles, W, iterations, animate);

% Determine maximum height for consistent y-axis in plots
maxHeight = totalHeight_initial;

% Plotting
figure;
subplot(1, 2, 1);
hold on;
axis([-2 W+2 0 maxHeight]);
colors = lines(N); 
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

figure
iterations = [1,10,100,1000,10000];
heights = zeros(1,length(iterations));
for i = 1:length(iterations)
    [positions_optimized, totalHeight_optimized, newRectangles] = optimizedPacking(rectangles, W, iterations(i), false);
    heights(i) = totalHeight_optimized;
end

semilogx(iterations,heights,'ro-')
grid on
title('Total stack height VS number of optimization iterations')
xlabel('Number of iterations')
ylabel('Height of stack')

%% Functions


function [positions, totalHeight, currentRectangles] = optimizedPacking(rectangles, W, iterations, animate)
    currentRectangles = rectangles;
    [positions, currentTotalHeight] = packRectangles(currentRectangles, W);
    firstHeight = currentTotalHeight;
    if animate
    figure; %figure for animation
    end
    colors = lines(size(rectangles, 1));

    for iter = 1:iterations
        %Swapping
        newRectangles = currentRectangles;
        idx1 = randi(size(newRectangles, 1));
        idx2 = randi(size(newRectangles, 1));
        temp = newRectangles(idx1, :);
        newRectangles(idx1, :) = newRectangles(idx2, :);
        newRectangles(idx2, :) = temp;

        %Randomly flip orientation
        if rand() > 0.5
            newRectangles(idx1, :) = newRectangles(idx1, [2 1]);
        end
        if rand() > 0.5
            newRectangles(idx2, :) = newRectangles(idx2, [2 1]);
        end

        % Calculate new packing
        [newPositions, newTotalHeight] = packRectangles(newRectangles, W);

        %Animation
        if animate
            clf;
            hold on;
            axis([-2 W+2 0 firstHeight+5]);
            for i = 1:size(rectangles, 1)
                rectangle('Position', [positions(i, 1), positions(i, 2), currentRectangles(i, 1), currentRectangles(i, 2)], ...
                          'EdgeColor', 'k', 'FaceColor', colors(i,:), 'LineWidth', 2);
            end
            title(['Iteration: ', num2str(iter), ' Height: ', num2str(currentTotalHeight)]);
            drawnow; % Update the figure
            hold off;
        end

        % Accept new configuration if it improves or maintains the total height
        if newTotalHeight <= currentTotalHeight
            currentRectangles = newRectangles;
            positions = newPositions;
            currentTotalHeight = newTotalHeight;
        end
    end

    totalHeight = currentTotalHeight;
end






function [positions, totalHeight] = packRectangles(rectangles, W)
    N = size(rectangles, 1);
    positions = zeros(N, 2);
    skyline = zeros(W, 1);

    for i = 1:N
        width = rectangles(i, 1);
        height = rectangles(i, 2);

        % Find position to place rectangle
        [bestX, bestY] = findPosition(width, skyline);
        if bestX == -1
            error('No valid position found for a rectangle. Check rectangle dimensions and bin width.');
        end
        positions(i, :) = [bestX, bestY];

        % Update skyline
        for j = bestX+1:bestX+width
            skyline(j) = bestY + height;
        end
    end

    totalHeight = max(skyline);
end

function [bestX, bestY] = findPosition(width, skyline)
    bestY = inf;
    bestX = -1;
    W = length(skyline);

    % Check each position along the bin width
    for x = 1:W-width+1
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

