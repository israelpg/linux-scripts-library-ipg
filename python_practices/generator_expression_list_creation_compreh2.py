for val in (x for x in range(10) if x not in [3, 5, 7]):
    print(val, end = ' ')
print()

# comprehension list:
# In [81]: [x for x in range(10) if x not in [3, 5, 7]]
# Out[81]: [0, 1, 2, 4, 6, 8, 9]