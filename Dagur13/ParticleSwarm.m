function [g,fbest] = ParticleSwarm(func,SwarmSize,c1,dimension,range,maxIteration)

c2 = 4.1-c1;
phi = c1+c2;
chi = 2 / abs(2 - phi - sqrt(phi^2 - 4*phi));



x = zeros(SwarmSize, dimension);
for d = 1:dimension
    x(:, d) = (range(d, 2) - range(d, 1)) * rand(SwarmSize, 1) + range(d, 1);
end
func_evaluationsold = arrayfun(@(i) func(x(i,:)),1:SwarmSize);
[fbest,g] = min(func_evaluationsold); %global best
g = x(g,:);
xbest = x; %initial local best
max_velocity = (range(2,1)-range(1,1))/5;
min_velocity = -max_velocity;
v = (max_velocity - min_velocity) * rand(SwarmSize,1) + min_velocity;
iter = 0;
evaluation_num = 0;

while iter <=maxIteration
    r1 = rand(SwarmSize,dimension);
    r2 = rand(SwarmSize,dimension);
    v = chi*(v+c1*r1.*(xbest-x)+c2*r2.*(g-x));
    x = x+v;
    for d = 1:dimension
        x(x(:, d) < bounds(d, 1), d) = bounds(d, 1);
        x(x(:, d) > bounds(d, 2), d) = bounds(d, 2);
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
    iter = iter+1;
end
sprintf('fbest = %f, [x1,x2] = %s',fbest,mat2str(g))
end

