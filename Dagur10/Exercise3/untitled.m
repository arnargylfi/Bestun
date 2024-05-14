close all
ub = 1;
lb = 0;
N0 = 10;
points = rand(N0,2);
points(1:4,:) = [lb lb; ub lb; ub ub; lb ub];
for i = 1:200
    Delaunay = delaunayTriangulation(points(:,1),points(:,2));
    tri = Delaunay.ConnectivityList;
    centers = incenter(Delaunay);
    triplot(tri, points(:,1), points(:,2),'bo-');
    hold on 

    max_area = -inf;
    for j = 1:length(tri)
        Area = det([points(tri(j,:),:),ones(3,1)]);
        if Area > max_area
            max_area=Area;
            center_of_G = centers(j,:);
        end
    end
    points = [points;center_of_G(1),center_of_G(2)];
    scatter(center_of_G(1),center_of_G(2),'ro')
    pause(0.05)
    hold off 
end


