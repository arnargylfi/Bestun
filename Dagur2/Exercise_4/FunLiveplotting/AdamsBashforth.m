function y = AdamsBashforth(h,func,y0,range)
t = range(1):h:range(2);
y = zeros(length(t),1);
y(1) = y0;
y(2) = y(1)+h*func(t(1),y(1));
for i = 3:length(t)
    y(i) = y(i-1)+1.5*h*func(t(i-1),y(i-1))-0.5*h*func(t(i-2),y(i-2));
end
