string1 = 'abcdef'

print(string1.upper())

# assign upper and keep it requires the var to be declared and assigned again:
string1 = string1.upper()
print(string1)

string2 = 'Israel'

print(string2.rjust(15,'*'))

# other string built-in functions: ljust, strip ... check book Fundamentals

string3 = '    This is some text    '
print('No strip: ', string3)
print('Below strip: ')
print(string3.strip())
