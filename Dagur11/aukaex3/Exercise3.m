    clear
    plotmeshsize = 20;
    x=linspace(-3,3,plotmeshsize);
    y=linspace(-3,3,plotmeshsize);
    [xi,yi]=meshgrid(x,y);
    
    zi = zeros(plotmeshsize);
    for j=1:plotmeshsize
        for k=1:plotmeshsize
            zi(k,j)=exercise_3_function([x(j) y(k)]'); 	% evaluate function f
        end
    end
    surf(xi,yi,zi,'FaceAlpha',0.2); 				% surface plot of the function f
    hold on
        
    %Gaussian basis functions
    N = 3;
    xgrid=linspace(-3,3,N);
    ygrid=linspace(-3,3,N);
    [X,Y]=meshgrid(xgrid,ygrid);
    % Compute distances
    N = 169;
    xgrid = linspace(-3, 3, sqrt(N));
    ygrid = linspace(-3, 3, sqrt(N));
    [X, Y] = meshgrid(xgrid, ygrid);
    XY = [X(:),Y(:)];
    Phi = zeros(N);
    for i = 1:N
        for j = 1:N
            Phi(i,j) = exp(-(norm(XY(i,:)-XY(j,:))^2));
        end
    end
    Z = zeros(N,1);
    for i = 1:N
        Z(i) = exercise_3_function(XY(i,:));
    end
    lambda = Phi\Z;
    Zpredicted = Phi*lambda
    plot3(X(:),Y(:),Zpredicted,'k.','MarkerSize',10)

    