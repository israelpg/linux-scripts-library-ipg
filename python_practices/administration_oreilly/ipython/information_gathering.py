# pdef: definition of function or object
# pdoc: documentation for that function or object
# psource: code for that function or object
# pinfo: Complete information (all of above)
# alternatively use ? or ??
# to search for an object (like a function): psearch regex

processes = !ps -aux

# pagination:
page processes


# pdef :: Checking the function signature:
In [31]: def sumaNumbers(a,b,c,d):
    ...:     resultado = a+b+c+d
    ...:     return resultado
    ...:

In [32]: sumaNumbers(2,4,6,3)
Out[32]: 15

In [33]: pdef sumaNumbers
 sumaNumbers(a, b, c, d)

# Return function documentation:
In [109]: def myFunction2(a,b):
     ...:     """it just calculates a sum"""
     ...:     total = a+b
     ...:     print total
     ...:         

In [110]: myFunction2(2,4)
6

In [111]: %pdoc myFunction2
Class docstring:
    it just calculates a sum
Call docstring:
    x.__call__(...) <==> x(...)

# Gathering all info about a function, APPLICABLE TO BUILT-IN FUNCTIONS:
In [113]: myFunction2??
Signature: myFunction2(a, b)
Source:
def myFunction2(a,b):
    """it just calculates a sum"""
    total = a+b
    print total
File:      ~/scm-migrations/<ipython-input-109-a9fc0ea296a5>
Type:      function

# CHECK ::
os??
Type:        module
String form: <module 'os' from '/usr/lib64/python2.7/os.pyc'>
File:        /usr/lib64/python2.7/os.py
Source:
"""OS routines for NT or Posix depending on what system we're on.
... bla bla bla ..."""

### pinfo :: Get info about a file, like a py module
# Example below:

#!/usr/bin/env python
class Foo:
    """my Foo class"""
    def __init__(self):
        pass

class Bar:
    """my Bar class"""
    def __init__(self):
        pass

class Bam:
    """my Bam class"""
    def __init__(self):
        pass

In [25]: import exampleModule

In [26]: pinfo exampleModule
Type:        module
String form: <module 'exampleModule' from 'exampleModule.py'>
File:        ~/tests/exampleModule.py
Docstring:   <no docstring>

In [28]: pinfo exampleModule.Foo
Init signature: exampleModule.Foo(self)
Docstring:      my Foo class
File:           ~/tests/exampleModule.py
Type:           classobj

# same results as with pinfo by using the ? and ?? ::
In [30]: exampleModule?
Type:        module
String form: <module 'exampleModule' from 'exampleModule.py'>
File:        ~/tests/exampleModule.py
Docstring:   <no docstring>

In [31]: exampleModule??
Type:        module
String form: <module 'exampleModule' from 'exampleModule.py'>
File:        ~/tests/exampleModule.py
Source:
#!/usr/bin/env python
class Foo:
    """my Foo class"""
    def __init__(self):
        pass

class Bar:
    """my Bar class"""
    def __init__(self):
        pass

class Bam:
    """my Bam class"""
    def __init__(self):
        pass

## for getting just the code of the function:

In [34]: %psource exampleModule
#!/usr/bin/env python
class Foo:
    """my Foo class"""
    def __init__(self):
        pass

class Bar:
    """my Bar class"""
    def __init__(self):
        pass

class Bam:
    """my Bam class"""
    def __init__(self):
        pass

## searching for an object, like for example variables that start by letter b (use regex):

In [35]: a = 2

In [36]: aa = 22

In [37]: aaabbb = 55

In [38]: %psearch a*
a
aa
aaabbb
abs
all
any
apply

# it is possible to exclude the builtin functions in the psearch using -e exclude:
In [43]: psearch -e builtin a*
a
aa
aaabbb

# another psearch, in this case returns a module py with a function:

In [39]: %psearch example*
exampleModule

# You can also search using the ? as long as you have imported library os (import os)
In [41]: example*?
exampleModule

# The psearch function also allows searching for specific types of objects. Here, we search
# the user namespace for integers:
In [13]: psearch -e builtin * int
a
b
c

# and here we search for strings:
In [14]: psearch -e builtin * string
__
___
__name__
aa
bb
cc


### concerning objects, it is possible to list them all with who:

In [52]: who
a	 aa	 aaabbb	 exampleModule

In [59]: who int
a	 aaabbb	 

In [60]: who str
aa	 bb	 cc	 

In [61]: %who_ls
Out[61]: ['a', 'aa', 'aaabbb', 'bb', 'cc', 'exampleModule']

In [62]: who_ls int
Out[62]: ['a', 'aaabbb']

In [63]: who_ls str
Out[63]: ['aa', 'bb', 'cc']

### a nice trick, since who_ls returns a list, we can get latest output listed and use loop to see elements:
# the symbol _ represents the latest output from a list

In [74]: who_ls
Out[74]: ['a', 'aa', 'aaabbb', 'bb', 'cc', 'exampleModule']

In [75]: for n in _:
    ...:     print n
    ...:
a
aa
aaabbb
bb
cc
exampleModule

In [76]: who_ls int
Out[76]: ['a', 'aaabbb']

In [77]: for n in _:
    ...:     print n
    ...:     
a
aaabbb

### to get more complete info than who, use whos ::

In [78]: whos
Variable        Type      Data/Info
-----------------------------------
a               int       2
aa              str       hola
aaabbb          int       55
bb              str       adios
cc              str       pos vale
exampleModule   module    <module 'exampleModule' from 'exampleModule.py'>
n               str       aaabbb

In [79]: whos int
Variable   Type    Data/Info
----------------------------
a          int     2
aaabbb     int     55

In [80]: whos module
Variable        Type      Data/Info
-----------------------------------
exampleModule   module    <module 'exampleModule' from 'exampleModule.py'>

#### checking history of commands:
# hist || history (use -n for getting ids)
hist -n
...
78: whos
79: whos int
80: whos module
...


