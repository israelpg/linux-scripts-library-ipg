list1 = list(range(0, 21, 2))

for i in range(-2, 23):
    if i in list1:
        print('Number ', i, ' is in the list list1', list1)
    if i not in list1:
        print('Number ', i, ' is not in the list list1', list1)
