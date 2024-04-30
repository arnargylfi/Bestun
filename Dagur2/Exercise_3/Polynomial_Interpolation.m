close all; clear all; clc;
data = [0 0;2 -1;2.8 5;4 2;5 -1;6 5;7 8];
polyInterpolation(data);

function polyInterpolation(data)
    x = data(:,1);
    y = data(:,2);
    pol = polyfit(x,y,(length(x)-1));
    dpol = polyder(pol);
    x_fit = linspace(min(x), max(x), 100);
    y_fit = polyval(pol, x_fit);
    dy_fit = polyval(dpol,x_fit);
    min_max = find(dy_fit==0);
    x_min_max = x_fit(min_max);
    disp(x_min_max);
    y_min_max = y_fit(min_max);
    disp(y_min_max);
    figure;
    hold on;
    plot(x,y,'bo',DisplayName='Data points');
    plot(x_fit,y_fit, 'b-', DisplayName='Interpolation polynomial p', LineWidth=1);
    plot(x_fit,dy_fit,'k-', DisplayName='First-order derivative of p', LineWidth=1);
    yline(0,'r-', Displayname='Zero level', LineWidth=1);
    plot(x_min_max,y_min_max,'xr',DisplayName='Locations of local maxima/minima', LineWidth=1);
    hold off;
    legend('show', 'Location', 'southeast');
    grid on;
end