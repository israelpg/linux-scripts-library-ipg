dividend, divisor = eval(input('Please enter a dividend and a divisor like this: dividend, divisor '))

msg = dividend / divisor if divisor != 0 else 'Error, cannot divide by zero'

print(msg)
