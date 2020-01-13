# This program adds up float numbers that have been passed as arguments in the command line
import sys
try:
    total = sum(float(arg) for arg in sys.argv[1:])
    print ('sum =', total)
except ValueError:
    print ('Please supply numbers')

###

# [israel@w50019045l-mutworld-be python_practices]$ python3 arguments_command_line_adding.py 23.5 5
# sum = 28.5

