from sys import argv
from math import sqrt

def main():
    if len(argv) < 3:
        print('You must supply at least two integers as arguments')
    else:
        for i in range(int(argv[1]), int(argv[2]) + 1):
            print(i, sqrt(i))
            print()

    print("Script completed")

if __name__ == "__main__":
    main()
