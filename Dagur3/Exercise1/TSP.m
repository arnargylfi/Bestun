    N = 40;
    disp('Ný keyrsla')
    iterations = 100;
    cities = randi([1,100],N,2);
    connections = 1:N; % original connections:
    connections = [connections,1]; %circular path
    hold on
    olddist = Inf;
    for j = 1:500
        clf
        dist = 0;
        plot(cities(:,1),cities(:,2),'bo')
        title(['Distance = ', num2str(olddist)]);
        for i=1:length(connections)-1   
            start_city = connections(i);
            end_city = connections(i+1);
            dist = dist+sqrt((cities(start_city,1)-cities(end_city,1))^2+(cities(start_city,2)-cities(end_city,2))^2);
            line([cities(start_city, 1), cities(end_city, 1)], [cities(start_city, 2), cities(end_city, 2)], 'Color', 'r');
        end
        if j == 1
            original_dist = dist%vista fyrsta sem original distance 
        end

        if dist >= olddist
            temp = connections(swapping_indices(1));
            connections(swapping_indices(1)) = connections(swapping_indices(2));
            connections(swapping_indices(2)) = temp; %swappa til baka ef þetta var ekki gott
        else
            olddist = dist;
        end
        swapping_indices = randi([2,length(connections)-1],1,2); %swappa öllu nema fyrsta og seinasta staki
        temp = connections(swapping_indices(1));
        connections(swapping_indices(1)) = connections(swapping_indices(2));
        connections(swapping_indices(2)) = temp;
        pause(0.1)
    end


ratio = olddist/original_dist;
disp(['Original distance divided by optimized distance = ', num2str(ratio)]);




