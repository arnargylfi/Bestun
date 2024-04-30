function y = Euler(h,func,y0,range)
t = range(1):h:range(2);
y = zeros(length(t),1);
y(1) = y0;
for i = 2:length(t)
    y(i) = y(i-1)+h*func(t(i-1),y(i-1));
end
