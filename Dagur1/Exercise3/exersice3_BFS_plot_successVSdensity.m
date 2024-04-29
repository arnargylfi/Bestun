clear all; close all; clc;

% Grid size and number of simulations per density
N = 30;
numSimulations = 100;

% Density range
P_range = 0:0.005:1;
successRates = zeros(length(P_range), 1);

% Main simulation loop
for p_idx = 1:length(P_range)
    P = P_range(p_idx);
    numSuccess = 0;
    
    for sim = 1:numSimulations
        % Generate obstacles
        obstacles = rand(N) < P;
        
        % BFS setup
        grid = -ones(N);
        grid(~obstacles) = 0;
        queue = [];

        % Initialize the BFS queue
        for i = 1:N
            if grid(N, i) == 0
                queue(end+1, :) = [N, i, 0];
                grid(N, i) = 1;
            end
        end

        % BFS to find path
        found = false;
        while ~isempty(queue)
            current = queue(1, :);
            queue(1, :) = [];
            r = current(1);
            c = current(2);

            if r == 1
                found = true;
                break;
            end

            % Explore neighbors
            directions = [0, 1; 0, -1; -1, 0; 1, 0];
            for dir = 1:4
                nr = r + directions(dir, 1);
                nc = c + directions(dir, 2);
                if nr > 0 && nr <= N && nc > 0 && nc <= N && grid(nr, nc) == 0
                    queue(end+1, :) = [nr, nc, current(3) + 1];
                    grid(nr, nc) = 1;
                end
            end
        end
        
        if found
            numSuccess = numSuccess + 1;
        end
    end
    
    % Calculate success rate for current density
    successRates(p_idx) = numSuccess / numSimulations;
end

%% Plot the results
figure;
plot(P_range, successRates, 'b-','LineWidth',1);
xlabel('Obstacle Density (P)');
ylabel('Success Rate');
title('Success Rate of Finding a Path vs. Obstacle Density');
ylim([-0.1 1.1])
grid on;
