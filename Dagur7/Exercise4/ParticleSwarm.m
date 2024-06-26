function [g,fbest] = ParticleSwarm(func,SwarmSize,c1,dimension,range,maxIteration,xcorrect)
if nargin <7
    xcorrect =0;
end

c2 = 4.1-c1;
phi = c1+c2;
chi = 2 / abs(2 - phi - sqrt(phi^2 - 4*phi));

x = (range(2) - range(1)) * rand(SwarmSize,dimension) + range(1);  
func_evaluationsold = arrayfun(@(i) func(x(i,:)),1:SwarmSize);
[fbest,g] = min(func_evaluationsold); %global best
g = x(g,:);
xbest = x; %initial local best
max_velocity = (range(2)-range(1))/5;
min_velocity = -max_velocity;
v = (max_velocity - min_velocity) * rand(SwarmSize,1) + min_velocity;
iter = 0;
evaluation_num = 0;
if dimension == 2
    xplot = linspace(range(1), range(2), 400);
    yplot = linspace(range(1), range(2), 400);
    [X, Y] = meshgrid(xplot, yplot);
    Z = arrayfun(@(ix, iy) func([ix, iy]), X, Y); 

    figure;
    contour(X, Y, Z, 20);
    colorbar
    hold on;
    best = scatter([0,0], [0,0], 1, 'o','Color',"#EDB120");
    swarm = scatter(x(:, 1), x(:, 2), 50, 'x', 'r');
end


while iter <=maxIteration
    r1 = rand(SwarmSize,dimension);
    r2 = rand(SwarmSize,dimension);
    v = chi*(v+c1*r1.*(xbest-x)+c2*r2.*(g-x));
    x = x+v;
    x(x < range(1)) = range(1);
    x(x > range(2)) = range(2); %to remove out of bounds x
    if dimension ==2
        set(swarm,'MarkerEdgeColor','blue','SizeData',10)
        swarm = scatter(x(:, 1), x(:, 2), 80, 'x', 'r','LineWidth',1.2);
    end
    func_evaluations = arrayfun(@(i) func(x(i,:)),1:SwarmSize);
    [fbestnew,gnew] = min(func_evaluations);
    xbest_index = func_evaluations<func_evaluationsold; %update local best
    func_evaluationsold = ~xbest_index.*func_evaluationsold+xbest_index.*func_evaluations;
    evaluation_num = evaluation_num + SwarmSize;
    xbest_index = repmat(xbest_index,dimension,1);
    xbest = ~xbest_index'.*xbest+xbest_index'.*x;

    if fbestnew < fbest
        fbest = fbestnew;
        g = x(gnew,:);
    end
    if dimension == 2
        set(best,'Visible','Off')
        best = scatter(xbest(1, 1), xbest(1, 2), 130, 'o','Color',"#EDB120",'LineWidth',2.2);
        pause(0.1)
    end
    if nargin == 7
        error = max(abs(g - xcorrect));
    if xcorrect == 0
        fprintf('Iteration: %d, function evaluations: %d xbest: %s, fbest: %f, error = %f\n', iter, evaluation_num, mat2str(g), fbest,error)
    else
        fprintf('Iteration: %d, function evaluations: %d xbest: %s, fbest: %f, error = %f%%\n', iter, evaluation_num, mat2str(g), fbest, max(abs((g - xcorrect)./(xcorrect))) * 100)
    end

    else
        fprintf('Iteration: %d, function evaluations: %d xbest: %s, fbest: %f\n,',iter,evaluation_num,mat2str(g),fbest)
    end
    iter = iter+1;
end
end

