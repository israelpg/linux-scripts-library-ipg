def increment(num):
    print('The number you have entered: ', num, ' is going to be displayed in a range two by two until +10: ')
    for i in range(num, num+10, 2):
        print(i)

inputNum = int(input('Please enter an integer: '))
increment(inputNum)
