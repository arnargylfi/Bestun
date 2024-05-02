    N = 40;
    disp('Ný keyrsla')
    iterations = 1000;
    cities = randi([1,100],N,2);
    connections = 1:N; % original connections:
    connections = [connections,1]; %circular path
    hold on
    olddist = Inf;
    for j = 1:iterations
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
            original_dist = dist;%vista fyrsta sem original distance 
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
        pause(0.05)
    end


%%
subplot(1,2,1)
for i=1:N-1
    start_city = i;
    end_city = i+1;
    dist = dist+sqrt((cities(start_city,1)-cities(end_city,1))^2+(cities(start_city,2)-cities(end_city,2))^2);
    line([cities(start_city, 1), cities(end_city, 1)], [cities(start_city, 2), cities(end_city, 2)], 'Color', 'r');
end
title(['Initial path, total length = ',num2str(original_dist) ])
subplot(1,2,2)
for i=1:length(connections)-1   
    start_city = connections(i);
    end_city = connections(i+1);
    dist = dist+sqrt((cities(start_city,1)-cities(end_city,1))^2+(cities(start_city,2)-cities(end_city,2))^2);
    line([cities(start_city, 1), cities(end_city, 1)], [cities(start_city, 2), cities(end_city, 2)], 'Color', 'r');
end
title(['Optimized path, total length = ',num2str(olddist)])
sgtitle(['Optimized path path lengthdivided by initial path length =',num2str(olddist/original_dist)])


