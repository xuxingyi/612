tic
n = 200;
A = 500;
a = zeros(n);
for i = 1:n
    a(i) = max(abs(eig(rand(A))));
end
toc


n = 200;
A = 50;
a = zeros(n);
parfor i = 1:n
    a(i) = max(abs(eig(rand(A))));
end


tic
n = 200;
A = 500;
a = zeros(n);
parfor i = 1:n
    a(i) = max(abs(eig(rand(A))));
end
toc