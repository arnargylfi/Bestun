function [iter, func_root, x_root] = Newton(func,Df,x0)
x = x0;
iter = 0;
plotting_range = 0:0.1:10;
    while abs(func(x)) > eps
        background = plot(plotting_range,func(plotting_range),'b');       
        hold on
        yline(0)
        line([x, x - func(x)/Df(x)],[func(x), 0],'Color','r')
        line([x - func(x)/Df(x), x - func(x)/Df(x)],[0, func(x - func(x)/Df(x))],'Color','r')
        x = x0 -func(x0)/Df(x0);
        x0 = x;
        pause(0.5)
        set(background,'Visible','Off')
        iter = iter+1;
        func_root = func(x0);
        x_root = x0;
        sprintf('f(x) = %f, x = %f',func(x0),x0)
        title(sprintf('$(x,f(x)) = (%f, %f)$, number of iterations $= %d$', x_root, func_root, iter),'Interpreter','latex','FontSize',12)
    end
plot(plotting_range,func(plotting_range),'b');       
end


