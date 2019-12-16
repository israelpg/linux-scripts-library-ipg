# regex evaluation using imported library :: re

import re

# re.match() checks for a match only at the beginning of the string, while re.search() checks 
# for a match anywhere in the string

re.match("c", "abcdef")    # No match
re.search("c", "abcdef")   # Match
re.search("^a", "abcdef")  # Match

# for MULTILINE, better use search:
re.search('^X', 'A\nB\nX', re.MULTILINE)  # Match in the third line

# method: match (re.match)
# Testing phone numbers: 
# Evaluating that string is composed of 3 integers d dash - 4 integers d

import re

for test_string in ['555-1212', '5444-42']:
    if re.match(r'^\d{3}-\d{4}$', test_string):
        print(test_string, 'is a valid US local phone number.')
    else:
        print(test_string, 'rejected, not a valid US number.')

# in action using ipython:
#In [55]: for test_string  in phones:
#    ...:     if re.match(r'^\d{3}-\d{4}$', test_string):
#    ...:         print (test_string, 'is a valid US local phone number')
#    ...:     else:
#    ...:         print (test_string, 'rejected')
#    ...:
#('555-1212', 'is a valid US local phone number')
#('ILL-EGAL', 'rejected')

## An example checking Belgian mobile numbers:

thisPhone = "487998338" # starts with 4 and then 8 more integers d :

if re.match(r'^4\d{8}$', thisPhone):
    print ("Good Belgian number")
else:
    print ("Not as good")
     
# For thisPhone, is good, therefore output is : Good Belgian number

# SUBSTITUTION WITH SUB()

