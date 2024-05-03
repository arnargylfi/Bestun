function [func_min, x_min] = goldensearch(func,x1,x2,tolerance)
goldenratio = (1+sqrt(5))/2;
X = [x1,x2,0,0];
[func_min,x_mindex] = min(func(X));
x_min = X(x_mindex);
sprintf('Minimal function value = %f, value of x = %f',func_min,X(x_mindex))
plot(x1:abs(x1-x2)/100:x2,func(x1:abs(x1-x2)/100:x2))
hold on
c = linspace(1,10,length(X));
while abs(X(2)-X(1)) > tolerance
    X(3) = X(2)-(X(2)-X(1))/goldenratio;
    X(4) = X(1)+(X(2)-X(1))/goldenratio;
    scatter_handle = scatter(X, func(X),[],c,'filled');
    [func_min,x_mindex] = min(func(X));
    x_min = X(x_mindex);
    sprintf('Minimal function value = %f, value of x = %f',func_min,x_min)
    pause(0.2)
    [~,max_index] = max(func(X));
    if max_index == 1
        X(1) = X(3);
    elseif max_index == 2
        X(2) = X(4);
    end
    set(scatter_handle, 'Visible', 'off') % Clear scatter plot points
end
sprintf('Final minimal function value = %f, value of x = %f',func_min,x_min)
end
