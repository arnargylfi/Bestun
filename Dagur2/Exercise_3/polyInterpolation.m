function polyInterpolation(data)
    x = data(:,1);
    y = data(:,2);
    pol = polyfit(x,y,(length(x)-1));
    dpol = polyder(pol);
    x_fit = linspace(min(x), max(x), 100);
    y_fit = polyval(pol, x_fit);
    dy_fit = polyval(dpol,x_fit);
    zeroCrossings = find(dy_fit(1:end-1) .* dy_fit(2:end) < 0);
    x_minmax = x_fit(zeroCrossings) + (x_fit(zeroCrossings + 1) - x_fit(zeroCrossings)) .*(0 - dy_fit(zeroCrossings)) ./ (dy_fit(zeroCrossings + 1) - dy_fit(zeroCrossings));
    y_minmax = polyval(pol, x_minmax);
    disp('Coordintes of the maxima/minima:')
    disp([x_minmax;y_minmax]);
    figure;
    hold on;
    plot(x,y,'bo',DisplayName='Data points');
    plot(x_fit,y_fit, 'b-', DisplayName='Interpolation polynomial p', LineWidth=1);
    plot(x_fit,dy_fit,'k-', DisplayName='First-order derivative of p', LineWidth=1);
    yline(0,'r-', Displayname='Zero level', LineWidth=1);
    plot(x_minmax,y_minmax,'rx',DisplayName='Locations of local maxima/minima', LineWidth=2);
    legend('show', 'Location', 'southeast');
    for i = 1:length(x_minmax)
        plot([x_minmax(i), x_minmax(i)], [0, y_minmax(i)], 'g:', 'LineWidth', 2, 'HandleVisibility', 'off');
    end
    hold off;
    grid on;
end