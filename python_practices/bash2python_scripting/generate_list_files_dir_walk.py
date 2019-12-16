#!/usr/bin/bash

import os
import sys
import subprocess

def walkDir(thisDirectory):
    for root, dirs, files in os.walk(thisDirectory, topdown=False):
        for name in files:
            print (os.path.join(root, name))
        for name in dirs:
            print (os.path.join(root, name))

def main():
    # Clear the screen
    subprocess.call('clear', shell=True)
    # Clear buffer
    sys.stdout.flush()

    while True:
        try:
            directoryInput = input ("Enter directory to walk: ")
            if not directoryInput:
                print ("You haven't typed any directory, try again...")
                continue
            print ("Directory to be walked", directoryInput)
            break
        except ValueError as e:
            print(e)
            sys.exit()
        except KeyboardInterrupt:
            print ("You pressed Ctrl+C")
            sys.exit()

    print(walkDir(directoryInput))

if __name__ == "__main__":
    main()

# Output execution when walking input dir /tmp
#Enter directory to walk: /tmp
#Directory to be walked /tmp
#/tmp/firefox/.parentlock
#/tmp/incron-tests/p.txt
#/tmp/incron-tests/not-affects
#/tmp/.vbox-israel-ipc/ipcd
#/tmp/.vbox-israel-ipc/lock
# ...
