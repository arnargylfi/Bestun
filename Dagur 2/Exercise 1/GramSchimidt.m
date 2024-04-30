%Gram Schmidt
function orthoA = GramSchmidt(A)


[linur,dalkar] = size(A);
if det(A*A')==0 || dalkar>linur % input vectors are linearly dependent
    error('Input vectors are linearly dependent')
end

v1 = A(:,1);
orthoA = zeros(size(A));
orthoA(:,1) = v1/norm(v1);
summa = 0;
for i = 2:dalkar
    vi = A(:,i);
    summa = summa + (vi'*orthoA(:,i-1))*orthoA(:,i-1);
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
    plot3([0,orthoA(1,1)],[0,orthoA(2,1)],[0,orthoA(3,1)],'b','LineWidth', 2)
    plot3([0,orthoA(1,2)],[0,orthoA(2,2)],[0,orthoA(3,2)],'b','LineWidth', 2)
    plot3([0,orthoA(1,3)],[0,orthoA(2,3)],[0,orthoA(3,3)],'b','LineWidth', 2)
 
    plot3([0,A(1,1)],[0,A(2,1)],[0,A(3,1)],'r')
    plot3([0,A(1,2)],[0,A(2,2)],[0,A(3,2)],'r')
    plot3([0,A(1,3)],[0,A(2,3)],[0,A(3,3)],'r')

    axis equal;
    grid on
    yline(0)
    xline(0)
    zline(0)
end





end
