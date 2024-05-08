function plotAnimation(f, all_points, bounds, kmax)
    x = linspace(bounds(1), bounds(2), 100);
    y = linspace(bounds(1), bounds(2), 100);
    [X, Y] = meshgrid(x, y);
    Z = arrayfun(@(ix, iy) f([ix, iy]), X, Y); 

    figure;
    contour(X, Y, Z, 20, 'LineColor', 'b');
    hold on;
    scatterPlot = scatter(all_points(1, 1), all_points(1, 2), 20, 'filled', 'r');
    %title(sprintf('Random Search Animation on Function %s', func2str(f)));
    xlabel('X1');
    ylabel('X2');

    for k = 2:kmax
        set(scatterPlot, 'XData', all_points(1:k, 1), 'YData', all_points(1:k, 2));
        drawnow;
    end
end