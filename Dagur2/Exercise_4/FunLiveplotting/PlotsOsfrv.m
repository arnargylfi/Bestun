func1 = @(t,y) -y +3*cos(3*t)*exp(-t);
func1correct =  @(t) sin(3*t).*exp(-t);
y01 = 0;
func2 = @(t,y) y;
func2correct = @(t) exp(t);
y02 = 1;

range = [0,5];
x = range(1):0.005:range(2);
hlist = 0.005:0.005:0.25;
for i = 0:length(hlist)-1
    clf
    h = hlist(length(hlist)-i);
    YEuler1 = Euler(h,func1,y01,range);
    YAdamB1 = AdamsBashforth(h,func1,y01,range);
    
    YEuler2 = Euler(h,func2,y02,range);
    YAdamB2 = AdamsBashforth(h,func2,y02,range);
    
    
    t = range(1):h:range(2);
    subplot(1,2,1)
    hold on
    plot(x,func1correct(x),'b-')
    plot(t,YEuler1,'black--','LineWidth',2)
    plot(t,YAdamB1,'r.-')
    legend('Correct solution','Euler approximation','Adams Bashforth approximation')
    set(gca, 'LineWidth',2, 'XGrid','on', 'GridLineStyle','--')
    hold off
    title("$y' = -y+\cos(3t) \cdot e^{-t}$", 'Interpreter', 'latex');
    subplot(1,2,2)
    hold on
    plot(x,func2correct(x),'b-')
    plot(t,YEuler2,'black--','LineWidth',2)
    plot(t,YAdamB2,'r.-')
    legend('Correct solution','Euler approximation','Adams Bashforth approximation')
    set(gca, 'LineWidth',2, 'XGrid','on', 'GridLineStyle','--')
    title("$y' = y$", 'Interpreter', 'latex');
    sgtitle(['Comparison of Correct Solution and Approximations ($h = $' num2str(h) ')'], 'Interpreter', 'latex');
    pause(0.1)
end

