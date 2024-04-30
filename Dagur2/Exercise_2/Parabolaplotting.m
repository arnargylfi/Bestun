function plot3DParabola()
    x=-2:0.05:2;
    y=x;
    [xi,yi]=meshgrid(x,y);
    zi=xi.^2+yi.^2;
    colormap = [0 0 0];
    mesh(xi,yi,zi);
    x0 = 0.5;
    y0 = -0.5;
    z0 = x0^2 + y0^2;
    zi_tangent = z0 + 1 * (xi - x0) - 1 * (yi - y0);
    hold on;
    mesh(xi,yi,zi_tangent);
    plot3(x0,y0,z0,'ko', 'MarkerSize', 5, 'MarkerFaceColor', 'k');
    hold off;
    title('Parabolic surface with tangent at [0.5 -0.5]T');
    xlabel('X axis');
    ylabel('Y axis');
    zlabel('Z axis');
end