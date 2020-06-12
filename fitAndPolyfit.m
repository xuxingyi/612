x = 1:10000000;
y = 2.3*x + sqrt(x);
x = x';
y = y';


tic
d = polyfit(x, y, 1);
d1 = d(1);

toc

c = fit(x ,y, 'poly1');
c1 = c.p1;
toc

