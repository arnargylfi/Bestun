function history = PatternSearch(X0,func, gridsize,minimum,maximum)
[X, Y] = meshgrid(minimum-2:0.1:maximum+2, minimum-2:0.1:maximum+2);
Z = func([X(:),Y(:)]);
Z = reshape(Z, size(X));
contour(X,Y,Z,40)
colorbar
prev_point = X0;
max_iter = 100;
hold on
history = [];
    for i = 1:max_iter
        snapped_point = gridsize * round(X0 / gridsize);
        plot([prev_point(1), X0(1)], [prev_point(2), X0(2)], 'b.-');
        
        pause(0.5)
        prev_point = X0;
        U = func(snapped_point);
        history=[history;X0(1),X0(2),U];
        sprintf('Iteration = %d, point = %f,%f, function value = %f',i, snapped_point, U)
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
            if trial_points(j,1) >= minimum && trial_points(j,1) <= maximum && trial_points(j,2) >= minimum && trial_points(j,2) <= maximum
                function_values(j) = func(trial_points(j,:));
            else
                function_values(j) = Inf;
            end
        end
        [min_value,min_index] = min(function_values);
        if min_value <U
            X0 = trial_points(min_index,:);
        else
            gridsize = gridsize/3;
        end
    end
end

