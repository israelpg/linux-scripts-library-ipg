In [38]: import random
    ...: 
    ...: print random.choice(['apple', 'pear', 'banana'])
    ...: 
    ...: print random.sample(xrange(100), 10)   # sampling without replacement
    ...: 
    ...: print random.random()    # random float
    ...: 
    ...: print random.randrange(6)    # random integer chosen from range(6)
    ...: 
pear
[9, 7, 6, 42, 75, 85, 65, 53, 40, 15]
0.227654923992
0

# specific range of integers:
print random.randint(1,8)

from random import randrange, seed

# setting seed function, which establishes the initial value from which the sequence of pseudorandom numbers is generated. If num was 100, next one would from 123 ...
seed(23)
for i in range(0, 100):
    print(randrange(1, 1001), end=' ')
    print()
