lst = [10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 110, 120]
print(lst)
# [10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 110, 120]

print(lst[0:3])
# [10, 20, 30]

print(lst[4:8])
# [50, 60, 70, 80]

print(lst[2:5])
# [30, 40, 50]

print(lst[-5:-3])
# [80, 90]

print(lst[:3])
# [10, 20, 30]

print(lst[4:])
# [50, 60, 70, 80, 90, 100, 110, 120]

print(lst[:])
# [10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 110, 120]

print(lst[-100:3])
# [10, 20, 30]

print(lst[4:100])
# [50, 60, 70, 80, 90, 100, 110, 120]

print(lst[2:-2:2])
# [30, 50, 70, 90]

print(lst[::2])
# [10, 30, 50, 70, 90, 110]

print(lst[::-1])
# [120, 110, 100, 90, 80, 70, 60, 50, 40, 30, 20, 10]

print(bikes[::2]) #print alternate elements

print(bikes[::-1]) #prints reversed list

print(bikes[::-2]) #prints reversed list with alternate elements

# last element:

print(bikes[-1])
