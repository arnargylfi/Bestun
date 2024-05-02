%Gram Schmidt
function orthoA = GramSchmidt(A)


[linur,dalkar] = size(A);
if det(A*A')==0 || dalkar>linur % input vectors are linearly dependent
    error('Input vectors are linearly dependent')
end

v1 = A(:,1);
orthoA = zeros(size(A));
orthoA(:,1) = v1/norm(v1);
for i = 2:dalkar
    vi = A(:,i);
    summa = zeros(size(vi));
    for j = 1:i-1
        summa = summa + (vi'*orthoA(:, j))*orthoA(:, j);
    end
    ti = vi - summa;
    orthoA(:,i) = ti/norm(ti);
end

if linur==2
    hold on
    plot([0,orthoA(1,1)],[0,orthoA(2,1)],'b','LineWidth', 2)
    plot([0,orthoA(1,2)],[0,orthoA(2,2)],'b','LineWidth', 2)
   
    plot([0,A(1,1)],[0,A(2,1)],'r')
    plot([0,A(1,2)],[0,A(2,2)],'r')

    axis equal;
    grid on
    yline(0)
    xline(0)
    hold off
end

if linur==3
    hold on
    quiver3(zeros(1,dalkar), zeros(1,dalkar), zeros(1,dalkar), ...
    orthoA(1,:), orthoA(2,:), orthoA(3,:), 'b', 'LineWidth', 2);
    hold on;
    
    % Plot the original vectors
    quiver3(zeros(1,dalkar), zeros(1,dalkar), zeros(1,dalkar), ...
    A(1,:), A(2,:), A(3,:), 'r');

    
    axis equal;
    grid on
    yline(0)
    xline(0)
    set(gca, 'LineWidth',2, 'XGrid','on', 'GridLineStyle','--')
end

for i = 1:dalkar
    for j = i+1:dalkar
        dot_product = dot(orthoA(:, i), orthoA(:, j));
        if abs(dot_product) == 0
            disp(['Vectors ', num2str(i), ' and ', num2str(j), ' are orthogonal. Dot product: ', num2str(dot_product)]);
        else
            disp(['Vectors ', num2str(i), ' and ', num2str(j), ' are not orthogonal. Dot product: ', num2str(dot_product)]);
        end
    end
end





end
