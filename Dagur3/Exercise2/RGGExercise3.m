function [binHeight, positions] = packRectangles(W, N, w, h)
    % Initialize the height array for the bin
    heights = zeros(1, W);
    
    % Initialize positions array to store the bottom-left corner (x, y) of each rectangle
    positions = zeros(N, 2);
    
    % Loop through each rectangle
    for i = 1:N
        % Initialize minimum height found for the rectangle
        minHeight = inf;
        bestX = 0;

        % Try placing the rectangle at every possible x position
        for x = 1:(W - w(i) + 1)
            % Maximum height in the range that the rectangle would occupy
            maxH = max(heights(x:x+w(i)-1));
            
            % Check if this position is better (lower) than what we have found so far
            if maxH < minHeight
                minHeight = maxH;
                bestX = x;
            end
        end

        % Place the rectangle at the best found position
        positions(i, :) = [bestX, minHeight];
        
        % Update the heights array to reflect the added rectangle
        heights(bestX:bestX+w(i)-1) = minHeight + h(i);
    end
    
    % The maximum height in the heights array is the total height used
    binHeight = max(heights);
end
