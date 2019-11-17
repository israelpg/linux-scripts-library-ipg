In [32]: string1 = "A normal string"

In [33]: type(string1)
Out[33]: str

In [34]: print(isinstance(string1, str))
True

# This isinstance bif gives some useful tips, so that we evaluate what kind of data type we are dealing with

In [35]: int1 = 5

In [36]: type(int1)
Out[36]: int

In [37]: if isinstance(int1, int): print ('You can proceed, is an integer')
You can proceed, is an integer

# You can also evaluate a Class in OOP:

# wrinting a class
class SampleClass:
   # constructor
   def __init__(self):
      self.sample = 5
# creating an instance of the class SampleClass
sample_class = SampleClass()
# accessing the sample class variable
print(sample_class.sample)
# invoking the isinstance(object, class) function
print(isinstance(sample_class, SampleClass))

# Output:
# 5
# True
