close all; clear all; clc;
x = 0.0:0.2:10.0;
y = [2.9004, 2.8718, 2.6121, 2.5500, 2.3605, 2.0048, 1.8463, 1.5930, 1.2475, 1.1892, ...
     1.0805, 0.9076, 0.7522, 0.7779, 0.6789, 0.6358, 0.5275, 0.5860, 0.6809, 0.7591, ...
     0.7995, 0.8182, 0.9791, 0.9631, 1.0600, 1.1088, 1.1188, 1.0386, 0.9028, 0.8256, ...
     0.6602, 0.6062, 0.4935, 0.3788, 0.2423, 0.1860, 0.1158, 0.1396, 0.1260, 0.1131, ...
     0.0669, 0.0647, 0.0174, 0.0864, 0.0424, 0.0190, 0.0805, 0.0670, 0.0761, 0.0242, ...
     0.0561];
% %Plotted initially so visualize the data
% figure;
% plot(x,y, 'ro');
% Decided that using cos(x) and exp(-x) would be a good approach due to the
% shape of the data
fun1 = @(param1, x) param1(1) * cos(param1(2) * x) + param1(3) * exp(-param1(4) * x) + param1(5);
objectiveFun1 = @(param1) fun1(param1, x) - y;
initialParams1 = [1, 1, 1, 1, 1];

options = optimoptions('lsqnonlin', 'Display', 'iter');
fittedParams1 = lsqnonlin(objectiveFun1, initialParams1, [], [], options);
y_fitted1 = fun1(fittedParams1, x);

%I saw after the first run that is was an okay fit but I wanted a better
%fit so I added terms 1, x and x^2
fun2 = @(param2, x) param2(1) + param2(2) * x + param2(3) * x.^2 + param2(4) * cos(param2(5) * x) + param2(6) * exp(-param2(7) * x);
objectiveFun2 = @(param2) fun2(param2, x) - y;
initialParams2 = [1, 1, 1, 1, 1, 1, 1];

fittedParams2 = lsqnonlin(objectiveFun2, initialParams2, [], [], options);
y_fitted2 = fun2(fittedParams2, x);

figure;
plot(x, y, 'bo', x, y_fitted1, 'r-',x, y_fitted2, 'g-', 'LineWidth', 1);
title('Input Data and Fitted Regression Functions');
xlabel('x');
ylabel('y');
legend('Data', 'First fitted Model', 'Final fitted Model', 'Location', 'northwest');
grid on;