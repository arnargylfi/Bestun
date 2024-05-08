fp = @(x) -exp(-norm(x)^2/2) * prod(cos(10*x));
fr = @(x) sum((1 - x(1:end-1)).^2 + 100 .* (x(2:end) - x(1:end-1).^2).^2); % rosenbrock
fa = @(x) -20 * exp(-0.2 * sqrt(mean(x.^2))) - exp(mean(cos(2*pi*x))) + 21; % auckley

fprintf('fp function: n=1')
Diff_Evolution(fp,1,[-2 2],1,0.5);
Diff_Evolution(fp,1,[-2 2],0.25,0.1);
Diff_Evolution(fp,1,[-2 2],0.5,0.01);
fprintf('fp function: n=2')
Diff_Evolution(fp,2,[-2 2],1,0.5);
Diff_Evolution(fp,2,[-2 2],0.25,0.1);
Diff_Evolution(fp,2,[-2 2],0.5,0.01);

fprintf('Rosenbrock function: n=2')
Diff_Evolution(fr,1,[-2 2],1,0.5);
Diff_Evolution(fr,1,[-2 2],0.25,0.1);
Diff_Evolution(fr,1,[-2 2],0.5,0.01);

fprintf('Auckley function: n=1')
Diff_Evolution(fa,1,[-10 10],1,0.5);
Diff_Evolution(fa,1,[-10 10],0.25,0.1);
Diff_Evolution(fa,1,[-10 10],0.5,0.01);
fprintf('Auckley function: n=2')
Diff_Evolution(fa,2,[-10 10],1,0.5);
Diff_Evolution(fa,2,[-10 10],0.25,0.1);
Diff_Evolution(fa,2,[-10 10],0.5,0.01);
fprintf('Auckley function: n=3')
Diff_Evolution(fa,3,[-10 10],1,0.5);
Diff_Evolution(fa,3,[-10 10],0.25,0.1);
Diff_Evolution(fa,3,[-10 10],0.5,0.01);

