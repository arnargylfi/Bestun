clear all, close all, clc
t0 = 0; tEnd = 5; h = [0.2, 0.1, 0.05, 0.01]; % step sizes

% Define the ODE
f1 = @(t, y) -y + 3*cos(3*t)*exp(-t);
f2 = @(t, y) y;
% Define the exact solutions
sol1 = @(t) sin(3*t).*exp(-t);
sol2 = @(t) exp(t);


% First ODE
figure 
for i = 1:length(h)
    subplot(2,2,i)
    hold on
    grid on
    y_euler = eulerMethod(f1, t0, 0, h(i), tEnd);
    y_adams = adamsBashforthMethod(f1, t0, 0, h(i), tEnd);
    t_vals = t0:h(i):tEnd;
    plot(t_vals, y_euler, 'b-', t_vals, y_adams, 'r--', t_vals, sol1(t_vals), 'k-');
    title(['Step size h = ', num2str(h(i))]);
    legend('Euler Method', 'Adams-Bashforth Method', 'Exact Solution');
    
end
sgtitle("y' = -y + 3cos(3t)exp(-t)")

% Second ODE
figure
for i = 1:length(h)
    subplot(2,2,i)
    hold on
    grid on
    y_euler = eulerMethod(f2, t0, 1, h(i), tEnd);
    y_adams = adamsBashforthMethod(f2, t0, 1, h(i), tEnd);
    t_vals = t0:h(i):tEnd;
    plot(t_vals, y_euler, 'b-', t_vals, y_adams, 'r--', t_vals, sol2(t_vals), 'k-');
    title(['Step size h = ', num2str(h(i))]);
    legend('Euler Method', 'Adams-Bashforth Method', 'Exact Solution','location','northwest' );
    hold off;
end
sgtitle("y' = y")

function y = eulerMethod(f, t0, y0, h, tEnd)
    steps = t0:h:tEnd;
    y = zeros(1, length(steps));
    y(1) = y0;
    for i = 1:length(steps)-1
        y(i+1) = y(i) + h * f(steps(i), y(i));
    end
end

function y = adamsBashforthMethod(f, t0, y0, h, tEnd)
    y1 = y0 + h * f(t0, y0); % Initialize using Euler's step
    steps = t0:h:tEnd;
    y = zeros(1, length(steps));
    y(1) = y0;
    y(2) = y1;
    for i = 2:length(steps)-1
        y(i+1) = y(i) + 1.5 * h * f(steps(i), y(i)) - 0.5 * h * f(steps(i-1), y(i-1));
    end
end

