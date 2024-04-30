clear all
%%
%create grid
N = 20;
[x,y] = meshgrid(1:N, 1:N); %Create grid
P = 0.4; %Obstacle density
% -sum(obstacles(:))/(N*N) % real obstacle density
obstacles = -(rand(N) > 1-P); 
obstacles(1,:) = obstacles(1,:) + (obstacles(1,:) == 0);
%%
label = 1; %inital path label

while 1
    continew = false;
    indices = find(obstacles == label); %gefur linear index þar sem path label er current gæjinn
    [row,col] = ind2sub(size(obstacles),indices); %breytir linear index í row,col
    for i = 1:length(row)
        if row(i) < N && obstacles(row(i)+1,col(i)) == 0
           obstacles(row(i)+1,col(i)) = label+1;
           continew = true;
        end
        if col(i)<N && obstacles(row(i),col(i)+1) == 0
            obstacles(row(i),col(i)+1) = label+1;
            continew = true;
        end
        if col(i)>1 && obstacles(row(i),col(i)-1) == 0
            obstacles(row(i),col(i)-1) = label+1;
            continew = true;
        end
    end
    label = label +1;
    if ~continew

        break;
    end
end

%%
%backtracking & plotting
index_af_ollu_jakvaedu = find(obstacles(N,:) > 0);  %finn seinustu röðina fyrir utan -1 til að taka max af því fyrir upphafspunkt
starting_point = obstacles(N,:);
starting_point = min(starting_point(index_af_ollu_jakvaedu)); %minnsta skrefalengd sem komst á botn
k = find(obstacles(N,:)==starting_point);
index = [N,k];
path = zeros(N);
path(index(1),index(2)) = 1;

for j = 0:starting_point-1
    label = starting_point -j
    if index(1) < N && obstacles(index(1)+1,index(2)) == label-1
        index = [index(1)+1,index(2)];
        path(index(1),index(2)) = 1;
    elseif index(1) > 1 && obstacles(index(1)-1,index(2)) == label-1
        index = [index(1)-1,index(2)];
        path(index(1),index(2)) = 1;
        obstacles(index)
    elseif index(2) < N && obstacles(index(1),index(2)+1) == label-1
        index = [index(1),index(2)+1];
        path(index(1),index(2)) =1;
    elseif index(2) >1 &&obstacles(index(1),index(2)-1) == label-1
        index = [index(1),index(2)-1];
        path(index(1),index(2)) =1;
    end
end
hold on
plot(x(obstacles == -1),N+1-y(obstacles == -1),'ro','MarkerSize',7.5)
plot(x(path == 1),N+1-y(path == 1),'blacko','MarkerFaceColor','blue','MarkerSize',5)
hold off



