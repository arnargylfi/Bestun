clear all; close all; clc;

% Define vertices
Vertices = [1 1;7 2;6 -4;3 -2;-5 -6;-2 0;-4 10;2 8];
numRotations = 10;
angleDeg = 5;

rotatePolygon(Vertices, numRotations, angleDeg);

function rotatePolygon(vertices, numRotations, angleDeg)
    center = [0, 0];
    %Closing the path
    vertices(end+1, :) = vertices(1, :);

    %Plotting otiginal polygon and center
    figure;
    hold on;
    axis equal;
    title('Rotating Polygon');
    axis([-12 12 -12 12]);
    plot(0, 0, 'ro', 'MarkerFaceColor', 'r');
    polygonPlot = plot(vertices(:,1), vertices(:,2), 'b-', 'LineWidth', 2);
    
    % Convert the angle from degrees to radians
    angleRad = deg2rad(angleDeg);
    for k = 1:numRotations
        %Rotation matrix
        R = [cos(angleRad) -sin(angleRad); sin(angleRad) cos(angleRad)];
        newVertices = (vertices - center) * R + center;
        vertices = newVertices;
        %Plot
        delete(polygonPlot);
        polygonPlot = plot(vertices(:,1), vertices(:,2), 'b-', 'LineWidth', 2);       
        pause(0.5);
    end
    hold off;
end



