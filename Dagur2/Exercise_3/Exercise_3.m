close all; clear all; clc;

data = [0 0;2 -1;2.8 5;4 2;5 -1;6 5;7 8];
data1 = [0.5 1.5;1.0 -2.0;1.5 0.5;2.0 -3.0;2.5 2.5];
data2 = [-1 -3;0 1;1 -2.5;2 5;3 6;4 -4;5 3];
data3 = [-2 2;-1.5 3.5;-1 4;-0.5 5;0 5;0.5 4.5;1 4;1.5 3;2 2;2.5 1.5];

polyInterpolation(data);
polyInterpolation(data1);
polyInterpolation(data2);
polyInterpolation(data3);
