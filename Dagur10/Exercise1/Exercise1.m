function uniformity = Exercise1(points)
uniformity = 0;
n = size(points, 1);
dimension = size(points,2);
for i = 1:n
    uniformity = uniformity + sum(1 ./ sum((points(i+1:end,:) - points(i,:)).^2, 2));
end
LHSplot(points)
% num_plots = dimension*(dimension-1)/2;
% plot_no = 1;
% for k = 1:dimension
%     for l = k+1:dimension
%         subplot(ceil(num_plots/2), 2, plot_no)
%         scatter(points(:,k), points(:,l))
%         xlabel(['x_', num2str(k)])
%         ylabel(['x_', num2str(l)])
%         plot_no = plot_no + 1;
%     end
% end
end

function LHSplot(samples)
    dimensions = size(samples, 2);
    pairs = nchoosek(1:dimensions, 2);
    numPlots = size(pairs, 1);
    currentFigure = 1; % Figure counter

    for i = 1:numPlots
        if mod(i-1, 3) == 0
            figure;
            currentFigure = currentFigure + 1;
        end
        
        subplotIndex = mod(i-1, 3) + 1;
        subplot(3, 1, subplotIndex);
        scatter(samples(:, pairs(i, 1)), samples(:, pairs(i, 2)));
        title(sprintf('2D Projection: x%d and x%d', pairs(i, 1), pairs(i, 2)));
        xlabel(sprintf('x%d', pairs(i, 1)));
        ylabel(sprintf('x%d', pairs(i, 2)));
    end
end

