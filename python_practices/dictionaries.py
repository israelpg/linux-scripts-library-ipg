# create a dictionary

In [143]: thisdict = {
     ...:   "brand": "Ford",
     ...:   "model": "Mustang",
     ...:   "year": 1964
     ...: }
     ...: print(thisdict)
     ...:
{'brand': 'Ford', 'model': 'Mustang', 'year': 1964}

# getting specific key value:

In [144]: print(thisdict['year'])
1964



# change value for a key:

In [145]: thisdict['year'] = 1968

In [146]: print(thisdict['year'])
1968

# print all keys in a loop:

In [147]: for key in thisdict:
     ...:     print(key)
     ...:
brand
model
year

# or:

print thisdict.keys()

# print values instead of keys:

print thisdict.values()

#or:
In [148]: for key in thisdict:
     ...:     print(thisdict[key])
     ...:
Ford
Mustang
1968

# or like this:
In [149]: for value in thisdict.values():
     ...:     print(value)
     ...:
Ford
Mustang
1968

# check if a key exists in the dict:

In [152]: if "year" in thisdict: print("Yes, year is a key in thisdict")
Yes, year is a key in thisdict

# check if a value exists:

In [166]: if "Ford" in thisdict.values():
     ...:     print("Ford is a valid model")
     ...:
Ford is a valid model

# adding more values to the dict:

In [168]: thisdict["color"] = "blue"

In [169]: thisdict
Out[169]: {'brand': 'Ford', 'color': 'blue', 'model': 'Mustang', 'year': 1968}

# getting key for a specific value:
x = thisdict.has_key('blue')
print(x)
color

# remove items:

In [179]: thisdict.pop("color")
Out[179]: 'blue'

In [180]: thisdict
Out[180]: {'brand': 'Ford', 'model': 'Mustang', 'year': 1968}

# or use del:

del thisdict["color"]

# del also used to remove the whole dict:

del thisdict

# reference to a dict:

refthisdict = thisdict
# changes in one dict affects the other one

# to copy a dict use copy() ::

thisdict2 = thisdict.copy()

In [190]: thisdict
Out[190]: {'brand': 'Ford', 'model': 'Mustang', 'year': 1968}

In [191]: thisdictcopy = thisdict.copy()

In [192]: thisdictcopy
Out[192]: {'brand': 'Ford', 'model': 'Mustang', 'year': 1968}
