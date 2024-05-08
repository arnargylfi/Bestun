fr = @(x) sum((1 - x(1:end-1)).^2 + 100 .* (x(2:end) - x(1:end-1).^2).^2); % rosenbrock
fp = @(x) -exp(-norm(x)^2/2) * prod(cos(10*x));
fa = @(x) -20 * exp(-0.2 * sqrt(mean(x.^2))) - exp(mean(cos(2*pi*x))) + 21; % auckley


[xbestr,fbestr] = ParticleSwarm(fr,[-2,2],2,200)
%%

[xbestp1,fbestp1] = ParticleSwarm(fp,[-2,2],1,40)
%%

[xbestp2,fbestp2] = ParticleSwarm(fp,[-2,2],2,40)
%%
[xbesta1,fbesta1] = ParticleSwarm(fa,[-10,10],1,40)
%%

[xbesta2,fbesta2] = ParticleSwarm(fa,[-10,10],2,200)
%%

[xbesta3,fbesta3] = ParticleSwarm(fa,[-10,10],3,40)
