#!/usr/bin/python3

import sys

if __name__ == "__main__":
    names={'Israel': 1, 'Natasa': 5, 'Ankica': 2}
    for name, count in names.items():
        sys.stdout.write("%d\t%s\n" % (count, name))

