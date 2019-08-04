def gradeResult(assignment1, assignment2):
    averageGrade = (assignment1 + assignment2) / 2
    print('Your average grade is: ', averageGrade)

print('Please enter your assignment results: ')
first = eval(input('Enter assignment1 result: '))
second = eval(input('Enter assignment2 result: '))
gradeResult(first, second)
