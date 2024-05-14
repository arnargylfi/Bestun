close all
ub = -2;
lb = 2;
N0 = 10;
points = (ub - lb) * rand(N0, 2) + lb;
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


