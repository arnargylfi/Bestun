    N = 40;
    disp('Ný keyrsla')
    cities = randi([1,100],N,2);
    %%
    iterations = 1000;
    connections = 1:N; % original connections:
    connections = [connections,1]; %circular path
    hold on
    olddist = Inf;
    for j = 1:iterations
        clf
        dist = 0;
%         plot(cities(:,1),cities(:,2),'bo') %c COMMENT IN FOR ANIMATION
%         title(['Distance = ', num2str(olddist)]);
        for i=1:length(connections)-1   
            start_city = connections(i);
            end_city = connections(i+1);
            dist = dist+sqrt((cities(start_city,1)-cities(end_city,1))^2+(cities(start_city,2)-cities(end_city,2))^2);
%             line([cities(start_city, 1), cities(end_city, 1)], [cities(start_city, 2), cities(end_city, 2)], 'Color', 'r');
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
%         pause(0.05)
    if mod(j,1000) == 0 %to keep track of number of iterations
        disp(['iteration ',num2str(j)])
    end
    end
%%

subplot(1,2,1)
plot(cities(:,1),cities(:,2),'bo')
hold on
original_connect = [1:N,1];
for i=1:N
    start_city = original_connect(i);
    end_city = original_connect(i+1);
    dist = dist+sqrt((cities(start_city,1)-cities(end_city,1))^2+(cities(start_city,2)-cities(end_city,2))^2);
    line([cities(start_city, 1), cities(end_city, 1)], [cities(start_city, 2), cities(end_city, 2)], 'Color', 'r');
end
title(['Initial path, total length = ',num2str(original_dist) ])
subplot(1,2,2)
plot(cities(:,1),cities(:,2),'bo')
hold on
for i=1:length(connections)-1   
    start_city = connections(i);
    end_city = connections(i+1);
    dist = dist+sqrt((cities(start_city,1)-cities(end_city,1))^2+(cities(start_city,2)-cities(end_city,2))^2);
    line([cities(start_city, 1), cities(end_city, 1)], [cities(start_city, 2), cities(end_city, 2)], 'Color', 'r');
end

title(['Optimized path, total length = ',num2str(olddist)])
sgtitle(['Optimized path path length divided by initial path length =',num2str(olddist/original_dist)])


