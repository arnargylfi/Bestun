clear all; close all; clc;

% Define vertices
Vertices = [1 1;7 2;6 -4;3 -2;-5 -6;-2 0;-4 10;2 8];
numRotations = 10;
angleDeg = 5;

rotatePolygon(Vertices, numRotations, angleDeg);
