function plotSmartSearch(func, bounds, xmin, x_values)
    [X, Y] = meshgrid(linspace(bounds(1,1), bounds(1,2), 100), linspace(bounds(2,1), bounds(2,2), 100));
    Z = arrayfun(func, X, Y);
    figure; 
    contour(X, Y, Z, 50); 
    hold on;
    plot(x_values(:,1), x_values(:,2), 'ro-');
    plot(xmin(1), xmin(2), 'kx', 'MarkerSize', 10, 'LineWidth', 2);
    xlabel('x'); 
    ylabel('y'); 
    title('Search Path on Contour Plot');
    colorbar;
end