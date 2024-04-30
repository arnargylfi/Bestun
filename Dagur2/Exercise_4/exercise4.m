clear all, close all, clc
t0 = 0; tEnd = 5; h = [0.2, 0.1, 0.05, 0.01]; % step sizes

% Define the ODE
f1 = @(t, y) -y + 3*cos(3*t)*exp(-t);
f2 = @(t, y) y;
% Define the exact solutions
sol1 = @(t) sin(3*t).*exp(-t);
sol2 = @(t) exp(t);


% Loop through each step size and plot results
for hi = h
    figure
    hold on
    grid on
    % Test for first ODE
    y_euler = eulerMethod(f1, t0, 0, hi, tEnd);
    y_adams = adamsBashforthMethod(f1, t0, 0, hi, tEnd);
    t_vals = t0:hi:tEnd;
    plot(t_vals, y_euler, 'b-', t_vals, y_adams, 'r--', t_vals, sol1(t_vals), 'k-');
    title(['Step size h = ', num2str(hi), ' for y'' = -y + 3cos(3t)exp(-t)']);
    legend('Euler Method', 'Adams-Bashforth Method', 'Exact Solution');
    hold off;

    % Test for second ODE
    figure
    hold on
    grid on
    y_euler = eulerMethod(f2, t0, 1, hi, tEnd);
    y_adams = adamsBashforthMethod(f2, t0, 1, hi, tEnd);
    t_vals = t0:hi:tEnd;
    plot(t_vals, y_euler, 'b-', t_vals, y_adams, 'r--', t_vals, sol2(t_vals), 'k-');
    title(['Step size h = ', num2str(hi), ' for y'' = y']);
    legend('Euler Method', 'Adams-Bashforth Method', 'Exact Solution');
    hold off;
end


function y = eulerMethod(f, t0, y0, h, tEnd)
    times = t0:h:tEnd;
    y = zeros(1, length(times));
    y(1) = y0;
    for i = 1:length(times)-1
        y(i+1) = y(i) + h * f(times(i), y(i));
    end
end


function y = adamsBashforthMethod(f, t0, y0, h, tEnd)
    y1 = y0 + h * f(t0, y0); % Initialize using Euler's step
    times = t0:h:tEnd;
    y = zeros(1, length(times));
    y(1) = y0;
    y(2) = y1;
    for i = 2:length(times)-1
        y(i+1) = y(i) + 1.5 * h * f(times(i), y(i)) - 0.5 * h * f(times(i-1), y(i-1));
    end
end
% 
% %first ODE
% function ydot = f1(t, y)
%     ydot = -y + 3*cos(3*t)*exp(-t);
% end
% 
% %second ODE
% function ydot = f2(t, y)
%     ydot = y;
% end
