    N = 5;
    iterations = 100;
    cities = randi([1,100],N,2);
    connections = 1:N; % original connections:
    connections = [connections,1]; %circular path
    plot(cities(:,1),cities(:,2),'bo')
    hold on
    olddist = Inf;
    for j = 1:iterations
    dist = 0;
        for i=1:length(connections)-1   
            start_city = new_connections(i);
            end_city = new_connections(i+1);
            dist = dist+sqrt((cities(start_city,1)-cities(end_city,1))^2+(cities(start_city,2)-cities(end_city,2))^2);
            line([cities(start_city, 1), cities(end_city, 1)], [cities(start_city, 2), cities(end_city, 2)], 'Color', 'r');
        end
    if dist <= olddist
        new_connections

        swapping_indices = randi([1,length(connections)],1,2);
        new_connections = connections;
        new_connections(swapping_indices(1)) = connections(swapping_indices(2));
        new_connections(swapping_indices(2)) = connections(swapping_indices(1));
    end




