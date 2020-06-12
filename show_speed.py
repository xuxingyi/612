import numpy as np
import numba as nb
# 用numba加速的求和函数
@nb.jit()
def nb_sum(a):
    Sum = 0
    for i in range(len(a)):
        Sum += a[i]
    return Sum

# 没用numba加速的求和函数
def py_sum(a):
    Sum = 0
    for i in range(len(a)):
        Sum += a[i]
    return Sum

import numpy as np
a = np.linspace(0,100,100) # 创建一个长度为100的数组

%timeit np.sum(a) # numpy自带的求和函数
%timeit sum(a) # python自带的求和函数
%timeit nb_sum(a) # numba加速的求和函数
%timeit py_sum(a) # 没加速的求和函数

%timeit nb_sum(a) # numba加速的求和函数 again