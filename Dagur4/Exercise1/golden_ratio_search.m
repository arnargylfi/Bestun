function [xmin, fmin, iterations] = golden_ratio_search(f, x1, x2, tol, ratio, animate)
    d = (x2 - x1) / ratio;
    x3 = x2 - d;
    x4 = x1 + d;
    f1 = f(x1);
    f2 = f(x2);
    f3 = f(x3);
    f4 = f(x4);
    iterations = 0;
    
    if animate
    h1 = plot(x1, f1, 'ro', 'MarkerFaceColor', 'r');
    h2 = plot(x2, f2, 'bo', 'MarkerFaceColor', 'b');
    h3 = plot(x3, f3, 'go', 'MarkerFaceColor', 'g');
    h4 = plot(x4, f4, 'mo', 'MarkerFaceColor', 'm');
    end

    while abs(x2 - x1) > tol
        iterations = iterations + 1;
        if f3 < f4
            x2 = x4;
            f2 = f4;
            x4 = x3;
            f4 = f3;
            d = (x2 - x1) / ratio;
            x3 = x2 - d;
            f3 = f(x3);
        else
            x1 = x3;
            f1 = f3;
            x3 = x4;
            f3 = f4;
            d = (x2 - x1) / ratio;
            x4 = x1 + d;
            f4 = f(x4);
        end
        
        if animate
        drawnow;
        pause(0.2)
        delete([h1, h2, h3, h4]);
        h1 = plot(x1, f1, 'ro', 'MarkerFaceColor', 'r');
        h2 = plot(x2, f2, 'bo', 'MarkerFaceColor', 'b');
        h3 = plot(x3, f3, 'go', 'MarkerFaceColor', 'g');
        h4 = plot(x4, f4, 'mo', 'MarkerFaceColor', 'm');
        end
    end
    xmin = (x1 + x2) / 2;
    fmin = f(xmin);
end