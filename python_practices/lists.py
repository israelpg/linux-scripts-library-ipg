numbers = [10, 22, 43, 11, 5, 55]

print(numbers)

print(numbers[3])

# assign value to a specific index of the list
numbers[3] = 12

print(numbers[3])

# print last number of the list
print(numbers[-1])

# print number of elements in a list
print(len(numbers))

# print all alements but without [], and using a \n

for element in numbers:
    print(element, '\n')

# print from last element to first element

nums = [2, 4, 6, 8]

for i in range(len(nums) - 1, -1, -1): # range starting from len = 4 with last index being 3  to 0 (-1) with a reverse jump -1
    print(nums[i])

# adding elements to a list:

list1 = ['a', 'b', 'c', 'd']

list1 = list1 + ['e', 'f', 'g']
print(len(list1))
print(list1)
['a', 'b', 'c', 'd', 'e', 'f', 'g']

# adding only one element to a list:

list1 += ['h']

# or with append function:

list1.append('h')

# Removing an element from the list:

list1 = [10, 20 ,30, 40, 50]
del list1[2]
list1
# [10, 20, 40, 50]

# two or more elements by index:
del list1[1], list1[3]

# several elements by slicing :

lista = [10, 20, 30, 40, 50, 60]
del lista[2:4]
lista
# [10, 20, 50, 60]

# evaluate a list and do something with its elements:

list11 = [2, -5, 50, 0, -55, 60, 1, -4, 8, 10, 2]
list11
[x for x in list11 if x >= 0]
list11
[2, 50, 0, 60, 1, 8, 10, 2]

# or evaluating element type in a list:

listMixed = ['ABC', 5, -1, 'C', 10]
listMixed
[x for x in listMixed if type(x) == str]
['ABC', 'C']
# you can evaluate opposite as: if type(x) != str
