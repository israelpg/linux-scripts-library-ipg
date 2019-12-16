# This program adds up integers that have been passed as arguments in the command line
# Note how the argument to be summed starts in position 1, since 0 is the script name!
# Positions reminder:
# h   e   l   p   A
# 0   1   2   3   4
# -5  -4  -3  -2  -1

import sys

def main():
    try:
        total = sum(int(arg) for arg in sys.argv[1:])
        print ('sum =', total)
    except ValueError:
        print ('Please supply integer arguments')

if __name__ == "__main__":
    main()

### output looks as follows:
# [israel@w50019045l-mutworld-be python_practices]$ python3 arguments_command_line_adding.py 10 5
# sum = 15

