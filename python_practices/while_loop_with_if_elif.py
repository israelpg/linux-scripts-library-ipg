sum = 0

while True:
    num = eval(input('Please, enter a positive integer (999 quits)'))

    if num < 0:
        print('You have entered a negative number: ', num, ' skipping count')
    elif num != 999:
        sum += num
    else:
        break

print('Total sum : ', sum)
