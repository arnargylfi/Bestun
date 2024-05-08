%TODO: make smarter (currently just the same as smartRandomSearch)
function [xbest, fbest, history, all_points, all_values] = smartRandomSearch(f, n, bounds, kmax)
    xbest = bounds(1) + (bounds(2) - bounds(1)) * rand(1, n); % generate random point
    fbest = f(xbest);
    history = zeros(kmax, 1);
    all_points = zeros(kmax, n);
    all_values = zeros(kmax, 1);   
    all_points(1, :) = xbest;
    all_values(1) = fbest;
    history(1) = fbest;   
    k = 1;
    while k <= kmax
        lambda = 1 - k / kmax; % Update lambda based on the iteration number
        xnew = bounds(1) + (bounds(2) - bounds(1)) * rand(1, n);
        xnew = lambda * xnew + (1 - lambda) * xbest; % Mix xnew with xbest
        fnew = f(xnew);
        all_points(k, :) = xnew;
        all_values(k) = fnew;
        history(k) = fbest;
        if fnew < fbest
            xbest = xnew;
            fbest = fnew;
        end
        k = k + 1;
    end
end