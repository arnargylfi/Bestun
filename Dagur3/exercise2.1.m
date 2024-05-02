close all
N = 30; % Number of rectangles
W = 12; % Width of the bin
% Generate random widths and heights for each rectangle
widths = randi([1, 3], N, 1);
heights = randi([3, 10], N, 1);

% Initial random order of rectangles
rectangles = [widths heights];


[positions, totalHeight] = placeRectangles(W, rectangles);

figure;
hold on;
%axis([0 W 0 totalHeight]);
for i = 1:size(rectangles, 1)
    rectangle('Position', [positions(i,1), positions(i,2), rectangles(i,1), rectangles(i,2)], ...
              'FaceColor', [rand rand rand]);
end
title(sprintf('Initial Packing with Total Height: %d', totalHeight));
xlabel('Width');
ylabel('Height');
hold off;



function [positions, totalHeight] = placeRectangles(W, rectangles)
    x = rectangles(1,1); % Current x position
    y = rectangles(1,2); % Current y position
    rowHeight = 0; % Height of the current row
    totalHeight = 0;
    beginning_of_last_row = 0;
    positions = zeros(size(rectangles, 1), 2); % Store positions of rectangles
    position_matrix = []
    
    for i = 2:size(rectangles, 1)
        if x + rectangles(i, 1) > W
            % Move to the next row
            x = 0;
            %y = rectangles(i,2)
            y = y + rowHeight;
            rowHeight = 0;
            beginning_of_last_row = i
        elseif rectangles(i, 2) + rectangles(beginning_of_last_row:(i-1),2) < rowHeight
            for j=beginning_of_last_row:(i-1)
                if rectangles(i,2) + rectangles(j,2) < rowHeight
                    y = rectangles(i,2) + rectangles(j,2)
                    x = rectangles(j,1)
                end
            end
            
        end
        positions(i, :) = [x, y]; % Store position
        x = x + rectangles(i, 1); % Increment x position
        rowHeight = max(rowHeight, rectangles(i, 2)); % Adjust row height
        
    end
    totalHeight = y + rowHeight; % Calculate total height of packed rectangles
end
