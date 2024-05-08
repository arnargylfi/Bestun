function [xbest, fbest, all_points] = randomSearch(f, n, bounds, kmax)
    fbest = Inf;
    xbest = [];
    history = zeros(kmax, 1);
    all_points = zeros(kmax, n);
    all_values = zeros(kmax, 1);  
    for k = 1:kmax
        xnew = bounds(1) + (bounds(2) - bounds(1)) * rand(1, n); % Generate random point
        fnew = f(xnew);       
        all_points(k, :) = xnew;
        all_values(k) = fnew;
        if fnew < fbest
            xbest = xnew;
            fbest = fnew;
        end
        history(k) = fbest; 
    end
end