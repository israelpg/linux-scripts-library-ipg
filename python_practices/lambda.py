#! python

# Lambda Forms

def make_incrementor(n):
    return lambda x: x + n
    
#==================================    
f = make_incrementor(42)

print f(0)
print f(1)
print f(15)

42
43
57

