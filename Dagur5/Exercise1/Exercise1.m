clear
f1 = @(X) 2*X(:,1).^2 + 3*X(:,2).^2 - 3*X(:,1).*X(:,2) + X(:,1);
minimum1 = -2;
maximum1 = 8;
P1 = [5,8];

f2 = @(X) (1-X(:,1)).^2+5*(X(:,1)-X(:,2).^2).^2;
minimum2 = -0.5;
maximum2 = 1.5;
P2 = [-0.5,1.5];

f3 = @(X) (X(:,1)+2*X(:,2)).*(1-0.9.*exp(-0.3*(X(:,1)-2.5).^2-2*(X(:,2)-3.5).^2)).*(1-0.9*exp(-(X(:,1)-3).^2-(X(:,2)-3).^2));
minimum3 = 1;
maximum3 = 5;
P3 = [4,2];

f4 = @(X) exp(X(:,1)./5)+exp(X(:,2)./3);
minimum4 = -10;
maximum4 = 10;
P4 = [5,8];


PatternSearch(P4,f4,1,minimum4,maximum4)