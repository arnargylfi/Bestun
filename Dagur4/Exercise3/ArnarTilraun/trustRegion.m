function [x_min,func_min] = trustRegion(f,X)


delta = 0.005;
kmax = 10000000;
k = 0;
found = false;
delta_halli = 1e-5;
while ~found && k<=kmax
    %gradient
    grad = X;
    for i = 1:length(X)
        Xnow = zeros(length(grad));
        Xnow(i) = X(i);
        grad(i) =(f(Xnow+delta_halli)-f(Xnow))/delta_halli;
    end
    q = @(h) f(X)+h*grad';
    k = k+1;
    htr = -grad*delta/(norm(grad));
    r = (f(X)-f(X+htr))/(q(zeros(1,length(X)))-q(htr));
    if r>0.75
        delta = 2*delta;
    elseif r<0.25
        delta = delta/3;
    end
    if r>0
        X = X+htr;
    end
x_min = X;
func_min = f(X);
end

