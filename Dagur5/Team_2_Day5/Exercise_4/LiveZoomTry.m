function LiveZoomTry(func, xmin, path, viewp)
    figure;
    for i = 1:length(path)
        hold on;
        [X, Y] = meshgrid(linspace((xmin(1)-0.5), (xmin(1)+0.5), 50), linspace((xmin(2)-0.5), (xmin(2)+0.5), 50));
        Z = arrayfun(@(x, y) func(x, y), X, Y);
        mesh(X, Y, Z);
        z_values = arrayfun(@(x, y) func(x, y), path(:,1), path(:,2));
        colormap;
        plot3(path(:,1), path(:,2), z_values, 'ro-', 'LineWidth', 2, 'MarkerSize', 5);
        z_min = func(xmin(1),xmin(2));
        plot3(xmin(1), xmin(2), z_min, 'kx', 'MarkerSize', 10, 'LineWidth', 2);
    
        axis([(xmin(1)-0.5) (xmin(1)+0.5) (xmin(2)-0.5) (xmin(2)+0.5) z_min-0.5 z_min+0.5])
        view(viewp); 

    end
xlabel('x');
ylabel('y');
zlabel('Function Value');
title('Zoomed 3D Visualization of Search Path');

end
