for val in (2**x for x in range(10)):
    print(val, end = ' ')
print()

# you can also get the same values in a list using comprehension list:
# In [75]: [2**x for x in range(10)]
# Out[75]: [1, 2, 4, 8, 16, 32, 64, 128, 256, 512]

# applying module to just calculate the pair numbers:
# In [76]: [2**x for x in range(10) if x%2 == 0]
# Out[76]: [1, 4, 16, 64, 256]