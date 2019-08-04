def promptUser():
    return eval(input('Please enter a number: '))

n1 = promptUser()
n2 = promptUser()
print('The sum of ', n1, ' and ', n2, ' is = ', n1 + n2)
