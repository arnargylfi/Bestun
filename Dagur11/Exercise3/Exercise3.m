xg=-3:0.2:3;
yg=-3:0.2:3;
[xi,yi]=meshgrid(xg,yg);

for j=1:length(xg)
    for k=1:length(yg)
        zi(k,j)=exercise_3_function([xg(j) yg(k)]'); 	% evaluate function f
    end
end
mesh(xi,yi,zi); 				% surface plot of the function f
