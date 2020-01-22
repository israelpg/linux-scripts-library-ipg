#!/usr/bin/python3

import sys
import subprocess
import string
import random

def generate_password():
    characters = string.ascii_letters + string.punctuation  + string.digits
    password =  "".join(random.choice(characters) for x in range(random.randint(8, 16)))
    print (password)

# you can also select all pwds of n chars, e.g. 10 chars: range(10)

def main():
    subprocess.call("clear")
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
