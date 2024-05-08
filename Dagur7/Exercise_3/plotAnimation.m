function plotAnimation(f, all_points, bounds)
    x = linspace(bounds(1), bounds(2), 100);
    y = linspace(bounds(1), bounds(2), 100);
    [X, Y] = meshgrid(x, y);
    Z = arrayfun(@(ix, iy) f([ix, iy]), X, Y); 
    figure;
    contour(X, Y, Z, 20, 'LineColor', 'b');
    hold on;
    previousScatter = []; % Initialize empty to hold the previous scatter plot

    for i = 1:size(all_points, 1)
        k = size(all_points, 2);
        if ~isempty(previousScatter) % Check if there is a previous scatter plot
            set(previousScatter, 'CData', [1, 0, 0]); % Change color to red
        end

        % Create new scatter plot for the current points
        scatterPlot = scatter(all_points(i, 1:k, 1), all_points(i, 1:k, 2), 20, 'filled', 'k');
        xlabel('X1');
        ylabel('X2');
        drawnow;
        pause(0.1); % Pause to visually distinguish the updates

        previousScatter = scatterPlot; % Update previous scatter to current
    end
end
