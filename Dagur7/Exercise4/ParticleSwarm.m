N = 20;
chi = 1;
c1 = 2.05;
c2 = 4.1-c1;
n = 2;
range = [-2,2];

x = (range(2) - range(1)) * rand(N,n) + range(1);
max_velocity = (range(2)-range(1))/5;
min_velocity = -max_velocity;
v = (max_velocity - min_velocity) * rand(N,1) + min_velocity;

