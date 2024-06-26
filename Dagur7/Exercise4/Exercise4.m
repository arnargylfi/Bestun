fr = @(x) sum((1 - x(1:end-1)).^2 + 100 .* (x(2:end) - x(1:end-1).^2).^2); % rosenbrock
fp = @(x) -exp(-norm(x)^2/2) * prod(cos(10*x));
fa = @(x) -20 * exp(-0.2 * sqrt(mean(x.^2))) - exp(mean(cos(2*pi*x))) + 21; % auckley

chi = 0.7298;
c1 = 2.05;
range = [-2,2];

[xbestr,fbestr] = ParticleSwarm(fr,20,c1,2,[-2 2],200,[1 1]);
%%

[xbestp1,fbestp1] = ParticleSwarm(fp,20,c1,1,[-2,2],100)
%%

[xbestp2,fbestp2] = ParticleSwarm(fp,30,c1,2,[-2,2],200,[0 0])
%%
[xbesta1,fbesta1] = ParticleSwarm(fa,20,c1,1,[-10,10],100)

%%

[xbesta2,fbesta2] = ParticleSwarm(fa,20,c1,2,[-10,10],200)
%%

[xbesta3,fbesta3] = ParticleSwarm2(fa,20,c1,3,[-10,10],350)