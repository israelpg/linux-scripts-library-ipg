In [113]: stringChars = "this is a string"

In [114]: converted2List = list(stringChars.split())

In [115]: type(converted2List)
Out[115]: list

In [116]: converted2List
Out[116]: ['this', 'is', 'a', 'string']

In [117]: for element in converted2List:
     ...:     print (element)
     ...:     
this
is
a
string

# in the example below includes a mapping to int:

In [111]: name = "3 34 67 12 78"
     ...: converted_list = list(map(int, name.split()))
     ...: print(converted_list)
     ...: 
[3, 34, 67, 12, 78]

