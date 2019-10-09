In [31]: class Person:
    ...:     def __init__(self, name, age):
    ...:         self.name = name
    ...:         self.age = age
    ...:     def myFunc(self):
    ...:         print("Hello my name is " + self.name)
    ...:         

In [32]: person1 = Person("Israel", 41)

In [34]: person1.myFunc()
Hello my name is Israel

In [35]: print(person1.age)
41

In [44]: class Person:
    ...:     def __init__(self, name, age):
    ...:         self.name = name
    ...:         self.age = age
    ...:     def namePerson(self):
    ...:         print("Hello my name is " + self.name)
    ...:     def agePerson(self):
    ...:         print(self.age)
    ...:
    ...:

In [45]: person2 = Person("Natasa", 38)

In [46]: person2
Out[46]: <__main__.Person instance at 0x7f3ecb85d128>

In [47]: person2.name
Out[47]: 'Natasa'

In [48]: person2.age
Out[48]: 38

In [49]: person2.namePerson()
Hello my name is Natasa

In [50]: person2.agePerson()
38

# Modify Object Properties:

In [51]: person2.age = 37

In [52]: person2.agePerson()
37

# Delete Object Property:

del person2.age

# Delete Object:

del person2


