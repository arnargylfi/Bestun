f1 = @(x) x.^2;
df1 = @(x) 2*x;
x1 = 5;

f2 = @(x) log(x);
df2 = @(x) 1./x;
x2 = 0.1;

f3 = @(x) x.^4;
df3 = @(x) 4*x.^3;
x3 = 5;

f4 = @(x) x.^0.5-2;
df4 = @(x) 1./( 2*x.^0.5);
x4 = 10;

struct = {{f1,df1,x1},...
          {f2,df2,x2},...
          {f3,df3,x3},...
          {f4,df4,x4}}; 

for i = 1:size(struct,2)
    name = func2str(struct{i}{1});
    h = figure('Name',name(5:end))
    Newton(struct{i}{1},struct{i}{2},struct{i}{3})
end
% 
%     title(sprintf('Newton Method on function, %s with initial guess, %f',func2str(struct{i}{1}),struct{i}{3}))

