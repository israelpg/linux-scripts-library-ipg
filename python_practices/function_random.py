from random import randrange, seed

# setting seed function, which establishes the initial value from which the sequence of pseudorandom numbers is generated. If num was 100, next one would from 123 ...
seed(23)
for i in range(0, 100):
    print(randrange(1, 1001), end=' ')
    print()
