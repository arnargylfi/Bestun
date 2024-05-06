function [func_min, x_min] = goldensearch(func,x1,x2,tolerance)
goldenratio = (1+5^0.5)/2;
X = [x1,x2,0,0];
[func_min,x_mindex] = min(func(X));
xlast = Inf;
sprintf('Minimal function value = %f, value of x = %f',func_min,X(x_mindex))
while abs(X(x_mindex)-xlast) > tolerance
    xlast = X(x_mindex);
    X(3) = X(2)-(X(2)-X(1))/goldenratio;
    X(4) = X(1)+(X(2)-X(1))/goldenratio;
    [~,max_index] = max(func(X));
    if max_index == 1
        X(1) = X(3);
    elseif max_index == 2
        X(2) = X(4);
    elseif max_index == 3
        X(3) = X(1);
    elseif max_index == 4
        X(4) = X(2);
    end
    [func_min,x_mindex] = min(func(X));
    sprintf('Minimal function value = %f, value of x = %f',func_min,X(x_mindex))
end
end
