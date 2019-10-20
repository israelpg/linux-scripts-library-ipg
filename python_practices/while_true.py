#! python

while True:
    inputUser = eval(input('Enter a number: '))
    if inputUser == 0:
        print('You typed 0, exiting.')
        break
    else:
        print('You typed ', inputUser)

print('Script completed')

### programming user input:

In [70]: while True:
    ...:     try:
    ...:         x = int(raw_input("Please enter a number: "))
    ...:         break
    ...:     except ValueError:
    ...:         print "Oops! That was no valid number.  Try again..."
    ...:
Please enter a number: a
Oops! That was no valid number.  Try again...
Please enter a number: 5

In [71]:

