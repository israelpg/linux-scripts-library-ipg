var1 = eval(input('Enter a number: '))

status = True if var1 > 5 else False

print('Well done, approved') if status == True else print('Butthead')

# or all in one line:
print('Well done, genius') if var1 > 49 else print('What a dick')
