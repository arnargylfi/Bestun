clear all; close all; clc
bounds2D = [0 1; 0 1];
bounds3D = [0 1; 0 1;0 1];
% n=2 N=50, 100, 200
samples2N50 = LHS(50, bounds2D);
samples2N100 = LHS(100, bounds2D);
samples2N200 = LHS(200, bounds2D);
% n=3 N=50, 100, 200
samples3N50 = LHS(50, bounds3D);
samples3N100 = LHS(100, bounds3D);
samples3N200 = LHS(200, bounds3D);

%Visualize it all
LHSplot(samples2N50);
LHSplot(samples2N100);
LHSplot(samples2N200);
LHSplot(samples3N50);
LHSplot(samples3N100);
LHSplot(samples3N200);


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