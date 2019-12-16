# import the regular expressions library: re

import re

# re to just get words starting with f

In [190]: r=re.findall(r'\bf[a-z]*', 'which foot or hand fell fastest')
     ...:
     ...: print r
     ...:
['foot', 'fell', 'fastest']

# giving also the index / position:

for m in re.finditer(r'\bf[a-z]*', 'which foot or hand fell fastest'):
     print('%02d-%02d: %s' % (m.start(), m.end(), m.group(0)))

# output:
# 06-10: foot
# 19-23: fell
# 24-31: fastest