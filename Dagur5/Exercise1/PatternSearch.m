% function p = PatternSearch(X0,func, gridsize)
%     history = [];
clear
    func = @(X) 2*X(:,1).^2 + 3*X(:,2).^2 - 3*X(:,1).*X(:,2) + X(:,1);
    gridsize = 0.5;
    minimum = -2;
    maximum = 8;
    max_iter = 100;
    X0 = [5 8];
[X, Y] = meshgrid(minimum-2:0.1:maximum+2, minimum-2:0.1:maximum+2);
Z = func([X(:),Y(:)]);
Z = reshape(Z, size(X));
contour(X,Y,Z,40)
prev_point = X0;
hold on
    for i = 1:max_iter
        snapped_point = gridsize * round(X0 / gridsize);
        plot([prev_point(1), X0(1)], [prev_point(2), X0(2)], 'b.-');
        pause(0.5)
        prev_point = X0;
        U = func(snapped_point);
        sprintf('Iteration = %d, point = %f%f, function value = %f',i, snapped_point, U)
%         history = [history;snapped_point,U];
        pattern = [gridsize,0;
                   -gridsize,0;
                   0,gridsize;
                   0,-gridsize];
        trial_points = [snapped_point;
                        snapped_point;
                        snapped_point;
                        snapped_point] + pattern;
        function_values = zeros(length(trial_points),1);
        
        for j = 1:length(trial_points)
            function_values(j) = func(trial_points(j,:));
        end
        [min_value,min_index] = min(function_values);
        if min_value <U
            X0 = trial_points(min_index,:);
        else
            gridsize = gridsize/3;
        end
    end
