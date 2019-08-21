# Important functionality, combining break to skip a loop which actually terminates script in this case
# plus the fact that the sum will only be printed in case the count reached 5, controlled with the else

count = sum = 0

print('Please, provide five non-negative numbers when prompted: ')
while count < 5:
    num = eval(input('Enter an integer: '))
    if num < 0:
        print('Negative number not allowed, terminating script!')
        break
    else:
        count += 1
        sum = sum + num
else:
    print('You have entered 5 integers, sum is: ', sum)
