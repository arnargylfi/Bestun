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
    figure;
    hold on;
    plot(x,y,'bo');
    plot(x_fit,0,'r-');
    plot(x_fit,y_fit, 'b-');
    plot(x_fit,dy_fit,'k-');
    hold off;
    xlabel('X');
    ylabel('dY/dX');
    title('Derivative of Polynomial');
    legend show;
    grid on;
    set(gca, 'XColor', 'red');  % Set x-axis color to red
end