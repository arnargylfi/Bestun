fr = @(x) sum((1 - x(1:end-1)).^2 + 100 .* (x(2:end) - x(1:end-1).^2).^2); % rosenbrock
fp = @(x) -exp(-norm(x)^2/2) * prod(cos(10*x));
fa = @(x) -20 * exp(-0.2 * sqrt(mean(x.^2))) - exp(mean(cos(2*pi*x))) + 21; % auckley


[xbestr,fbestr] = MultipleRunGS(fr,[-2,2],2,20)
%%

[xbestp1,fbestp1] = MultipleRunGS(fp,[-2,2],1,40)
%%
[xbestp2,fbestp2] = MultipleRunGS(fp,[-2,2],2,40)
%%
[xbesta1,fbesta1] = MultipleRunGS(fa,[-10,10],1,40)
%%

[xbesta2,fbesta2] = MultipleRunGS(fa,[-10,10],2,200)
%%
sol = [];
best = [];
for i = 1:30
    [solution, best_value] = MultipleRunGS(fa,[-10,10],3,40);
    sol = [sol; solution];
    best = [best; best_value];
end
%%
mean([sol,best])
[bestbest, index] = min(best);
[worst,index2] = max(best)
[sol(index,:),bestbest]
[sol(index2,:),worst]

