# import the regular expressions library: re

import re

# re to just get words starting with f

In [190]: r=re.findall(r'\bf[a-z]*', 'which foot or hand fell fastest')
     ...:
     ...: print r
     ...:
['foot', 'fell', 'fastest']
