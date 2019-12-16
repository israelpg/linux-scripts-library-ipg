#!/usr/bin/python3

# searches in a dir for a filename: recursive search
# os_walk searches in the whole dir, including subdirs, returning with a join the
# complete path/filename :)

import os
import sys
import subprocess

def find_files(filename, search_path):
    result = []
    # Walking top-down from the root : os_walk --> dirpath, dirnames, filenames
    for root, dir, files in os.walk(search_path):
        if filename in files:
            result.append(os.path.join(root, filename))
            return result

def main():
    # Clear the screen
    subprocess.call('clear', shell=True)
    # Clear buffer
    sys.stdout.flush()

    while True:
        try:
            filename = input ("Enter filename to search: ")
            if not filename:
                print ("You haven't type anything as filename, try again...")
                continue
            print ("File to be searched", filename)
            break
        except ValueError as e:
            print(e)
            sys.exit()
        except KeyboardInterrupt:
            print ("You pressed Ctrl+C")
            sys.exit()

    while True:
        try:
            rootDir = input ("Enter the root directory ( e.g.: /tmp or . ) : ")
            if not rootDir:
                print ("You haven't specified a path, try again...")
                continue
            print ("Dir to search is", rootDir)
            break
        except ValueError as e:
            print(e)
            sys.exit()
        except KeyboardInterrupt:
            print ("You pressed Ctrl+C")
            sys.exit()
    
    print(find_files(filename, rootDir))

if __name__ == "__main__":
    main()
