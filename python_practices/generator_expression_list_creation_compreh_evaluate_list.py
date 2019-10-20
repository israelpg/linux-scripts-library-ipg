# evaluate a list using a regular expression and do something with its elements:

list11 = [2, -5, 50, 0, -55, 60, 1, -4, 8, 10, 2]
# now we update the list to just keep >=0
[x for x in list11 if x >= 0]
list11
[2, 50, 0, 60, 1, 8, 10, 2]

# or evaluating element data type in a list:
listMixed = ['ABC', 5, -1, 'C', 10]
listMixed
[x for x in listMixed if type(x) == str]
['ABC', 'C']
# you can evaluate opposite as: if type(x) != str

