clear 
fr = @(x) sum((1 - x(1:end-1)).^2 + 100 .* (x(2:end) - x(1:end-1).^2).^2); % rosenbrock
fp = @(x) -exp(-norm(x)^2/2) * prod(cos(10*x));
fa = @(x) -20 * exp(-0.2 * sqrt(mean(x.^2))) - exp(mean(cos(2*pi*x))) + 21; % auckley

N  = 20;
mutateP = 0.2;
crossP = 0.7;
dimensions = 2;
range = [-2 2];

[xbestr,fbestr] = GAFP(fr,100,5,range,crossP,mutateP,20,2)
%%
[xbestr,fbestr] = GAFP(fr,1000,3,range,crossP,mutateP,100,3)

%%
[xbestp1,fbestp1] = GAFP(fr,N,10,range,crossP,mutateP,30,1)

%%

[xbestp2,fbestp2] = GAFP(fp,N,3,range,crossP,mutateP,30,2)

%%
[xbesta1,fbesta1] = GAFP(fa,N,3,range,crossP,mutateP,30,1)


%%

[xbesta2,fbesta2] = GAFP(fa,N,3,range,crossP,mutateP,30,2)

%%

[xbesta3,fbesta3] = GAFP(fa,N,3,range,crossP,mutateP,30,3)
