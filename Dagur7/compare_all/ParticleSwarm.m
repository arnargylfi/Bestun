function [fbest] = ParticleSwarm(func,dimension,range,maxIteration)
c1 = 2.05;
chi = 0.7298;
SwarmSize = 20;
c2 = 4.1-c1;
x = (range(2) - range(1)) * rand(SwarmSize,dimension) + range(1);  
func_evaluations = arrayfun(@(i) func(x(i,:)),1:SwarmSize);
[fbest,g] = min(func_evaluations); %global best
g = x(g,:);
xbest = x; %initial local best
max_velocity = (range(2)-range(1))/5;
min_velocity = -max_velocity;
v = (max_velocity - min_velocity) * rand(SwarmSize,1) + min_velocity;
iter = 0;


while iter <=maxIteration
    r1 = rand(SwarmSize,dimension);
    r2 = rand(SwarmSize,dimension);
    v = chi*(v+c1*r1.*(xbest-x)+c2*r2.*(g-x));
    x = x+v;
    x(x < range(1)) = range(1);
    x(x > range(2)) = range(2); %to remove out of bounds x

    func_evaluations = arrayfun(@(i) func(x(i,:)),1:SwarmSize);
    [fbestnew,gnew] = min(func_evaluations);
    xbest_index = arrayfun(@(i) func(x(i,:)),1:SwarmSize)<arrayfun(@(i) func(xbest(i,:)),1:SwarmSize); %update local best
    xbest_index = repmat(xbest_index,dimension,1);
    xbest = ~xbest_index'.*xbest+xbest_index'.*x;
    if fbestnew < fbest
        fbest = fbestnew;
        g = x(gnew,:);
    end

    iter = iter+1;
end
end

