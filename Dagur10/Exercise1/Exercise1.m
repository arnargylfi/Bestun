function uniformity = Exercise1(points)
close all
uniformity = 0;
n = size(points, 1);
dimension = size(points,2);
for i = 1:n
    uniformity = uniformity + sum(1 ./ sum((points(i+1:end,:) - points(i,:)).^2, 2));
end

num_plots = dimension*(dimension-1)/2;
plot_no = 1;
for k = 1:dimension
    for l = k+1:dimension
        subplot(ceil(num_plots/2), 2, plot_no)
        scatter(points(:,k), points(:,l))
        xlabel(['x_', num2str(k)])
        ylabel(['x_', num2str(l)])
        plot_no = plot_no + 1;
    end
end
end

