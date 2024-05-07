%Exercise 4
n = [3 5 10 20];
for idx = 1:length(n)
    current_n = n(idx);
    x0 = ones(1,current_n)* (1/current_n);
    f = black_box(x0);
    
end
