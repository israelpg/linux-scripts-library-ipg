# regex evaluation using imported library :: re
# method: match
# evaluating that string is composed of 3 integers d dash - 4 integers d

import re
for test_string in ['555-1212', '5444-42']:
    if re.match(r'^\d{3}-\d{4}$', test_string):
        print(test_string, 'is a valid US local phone number.')
    else:
        print(test_string, 'rejected, not a valid US number.')

In [55]: for test_string  in phones:
    ...:     if re.match(r'^\d{3}-\d{4}$', test_string):
    ...:         print (test_string, 'is a valid US local phone number')
    ...:     else:
    ...:         print (test_string, 'rejected')
    ...:
('555-1212', 'is a valid US local phone number')
('ILL-EGAL', 'rejected')

