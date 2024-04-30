%% Test the PathFinder function for different grid sizes
clear all; close all; clc;

PathFinder(20,0.3,true);
PathFinder(20,0.6,true);

N = flip(20:20:100); % Grid size
P = 0.3; % obstacle density

for i = 1:length(N)
    PathFinder(N(i),P,true);
end

%% Plot the success rate vs obstacle density

% Grid size and number of simulations per density
N = 20;
numSimulations = 100;

% Density range
P_range = 0:0.005:1;
successRates = zeros(length(P_range), 1);

% Main simulation loop
for p_idx = 1:length(P_range)
    P = P_range(p_idx);
    numSuccess = 0;

    for sim = 1:numSimulations

        [path,found] = PathFinder(N,P,false);        
        if found
            numSuccess = numSuccess + 1;
        end
    end

    % Calculate success rate for current density
    successRates(p_idx) = numSuccess / numSimulations;
end

% Plot the results
figure;
plot(P_range, successRates, 'b-','LineWidth',1);
xlabel('Obstacle Density (P)');
ylabel('Success Rate');
title('Success Rate of Finding a Path vs. Obstacle Density');
ylim([-0.1 1.1])
grid on;


