function plot3D(func, bounds, xmin, path, viewp)
    [X, Y] = meshgrid(linspace(bounds(1,1), bounds(1,2), 100), linspace(bounds(2,1), bounds(2,2), 100));
    Z = arrayfun(@(x, y) func(x, y), X, Y);

    figure;
    surf(X, Y, Z);
    alpha 0.8;
    hold on;
    
    z_values = arrayfun(@(x, y) func(x, y), path(:,1), path(:,2));
    plot3(path(:,1), path(:,2), z_values, 'ro-', 'LineWidth', 2, 'MarkerSize', 5);
    z_min = func(xmin(1),xmin(2));
    plot3(xmin(1), xmin(2), z_min, 'kx', 'MarkerSize', 10, 'LineWidth', 2);

    xlabel('x');
    ylabel('y');
    zlabel('Function Value');
    title('3D Visualization of Search Path');
    colorbar;
    view(viewp); 
end
