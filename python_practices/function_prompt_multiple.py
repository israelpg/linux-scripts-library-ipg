def prompt_number():
    print('Please, enter a number: ')
    value = int(input())
    return value
    # return value = int(input('Please, enter a number:'))

print('This program asks for two integers:')
value1 = prompt_number()
value2 = prompt_number()
sum = value1 + value2
print('The sum of ', value1, ' + ', value2, ' = ', sum) 
