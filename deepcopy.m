clear all
a = 1:200000000;
b = a;       %浅复制
a(1) = a(1)+ 1;   %浅复制偷偷的变为了深复制
C = a(1:end - 1)  ;   %切片索引直接深复制                           