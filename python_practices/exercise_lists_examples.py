#!/usr/bin/python3

# detecting which elements are the same in two different lists:

list1=['A','C','F','Z','L']
list2=['K','C','L','Z','I']

# using enumerate, comprehension list, and dict:

for positionList1, elementList1 in enumerate(list1):
    for match in (elementList2 for elementList2 in list2 if elementList2 == elementList1):
        print ('Element: ', match, ' is in both lists')

# What about getting sames values if only in same position/index:
# using comprehension list, zip, and dict

outputDict2={}
for positionList2 in (list2.index(y) for x, y in zip(list1, list2) if y == x):
    element = list2[positionList2]
    outputDict2.update( {positionList2 : element} )

print("outputDict2 : ")
for (key, value) in outputDict2.items() :
    print(key , " :: ", value)

