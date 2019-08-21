count = sum = 0

print('You will be prompted to enter 5 numbers, which will be calculated to obtain the avg')

while count < 5:
    num = eval(input('Please, enter a number: '))
    if num < 0:
        break
    count += 1
    sum += num
else:
    print('The average is: ', sum/count)
