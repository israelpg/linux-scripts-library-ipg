#!/usr/bin/python3

import sys
import subprocess
import string
from random import *

def generate_password():
    characters = string.ascii_letters + string.punctuation  + string.digits
    password =  "".join(choice(characters) for x in range(randint(8, 16)))
    print (password)

def main():
    subprocess.call("clear", shell=True)
    sys.stdout.flush()
    while True:
        try:
            numberPasswords = int(input("Please, type the number of passwords to generate: "))
            if not numberPasswords:
                print ("You must type an integer value")
                continue
            elif numberPasswords < 0:
                print ("You must type an integer value > 0")
                continue
            print ("You have typed %d number of passwords to be generated, proceeding..." % (numberPasswords))
            count = 0
            while count <= numberPasswords:
                generate_password()
                count += 1
            break
        except ValueError as e:
            print(e)
            sys.exit()
        except KeyboardInterrupt:
            print ("You pressed Ctrl+C")
            sys.exit()

if __name__ == "__main__":
    main()
