grade = eval(input('Please, enter your grade: '))

print('Your grade is: ', ('Outstanding' if grade > 79 else 'What did you do?'))

print('Your grade is Outstanding') if grade > 79 else print('Not outstanding')

print('Your grade is Outstanding' if grade > 79 else 'Not outstanding')