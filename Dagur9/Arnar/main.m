ft1 = @(x) x(1);
ft2 = @(x) (1/x(1)) * (1+(x(2)^2 + x(3)^2))^0.25 * ((sin(50 * (x(2)^2 + x(3)^2)^0.1))^2 + 1);

ff1 = @(x) 1 - exp(-sum((x - 1/sqrt(8)).^2));
ff2 = @(x) 1 - exp(-sum((x + 1/sqrt(8)).^2));


poi = GAFP(ff1,ff2,100,10,[-2 2],0.7,0.2,10,3)

