function [xbest,fbest] = MultipleRunGS(f,range,n,max_points)

fbest = Inf;
k = 0;
if n == 2
    x = linspace(range(1), range(2), 400);
    y = linspace(range(1), range(2), 400);
    [X, Y] = meshgrid(x, y);
    Z = arrayfun(@(ix, iy) f([ix, iy]), X, Y); 

    figure;
    contour(X, Y, Z, 20);
    colorbar
    hold on;
    best = scatter([0,0], [0,0], 1, 'o','Color',"#EDB120");
end
while k < max_points
    xnew = (range(2) - range(1)) * rand(1,n) + range(1);
    if n == 2
        scatter(xnew(1, 1), xnew(1, 2), 20, 'filled', 'b');
    end
    [xnew,fnew] = perform_gradient_search(xnew,f);
    if n ==2
        scatter(xnew(1, 1), xnew(1, 2), 50, 'x', 'r');
    end
    if fnew < fbest
        xbest = xnew;
        fbest = fnew;
    end
    k = k+1;
    if n == 2
        set(best,'Visible','Off')
        best = scatter(xbest(1, 1), xbest(1, 2), 100, 'o','Color',"#EDB120");
        pause(0.1)
    end
    fprintf('Iter: %d, x = %s, f(x) = %f\n',k,mat2str(xbest),fbest)
end

function [x, f] = perform_gradient_search(x, objective_function)
    alpha = 0.05;
    max_iterations = 10; 
    epsilon = 1e-5; 
    iter = 0;
    while iter < max_iterations
        gradient = zeros(size(x));
        for i = 1:numel(x)
            x_plus_delta = x;
            x_plus_delta(i) = x_plus_delta(i) + epsilon;
            gradient(i) = (objective_function(x_plus_delta) - objective_function(x)) / epsilon;
        end
        xny = x - alpha*gradient/norm(gradient); 
        if n ==2
            plot([x(1),xny(1)],[x(2),xny(2)],'k-')
            hold on
        end
        x = xny;
        f = objective_function(xny); 
        iter = iter + 1;
    end
end
end

