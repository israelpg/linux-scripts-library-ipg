done = False

while not done:
    num1 = eval(input('Please, enter an integer: '))
    if num1 == 999:
        done = True
    else:
        print(num1)
