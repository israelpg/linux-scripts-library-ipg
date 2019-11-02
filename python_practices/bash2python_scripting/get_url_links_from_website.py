#!/usr/bin/python3

import sys
import subprocess
from urllib.request import urlopen
import re

def main():
    subprocess.call("clear", shell=True)
    sys.stdout.flush()
    while True:
        try:
            thisURL = input("Please, type a url: ")
            if not thisURL:
                print ("You must type a url")
                continue
            #connect to a URL
            website = urlopen(thisURL)
            #read html code
            html = website.read().decode('utf-8')
            #use re.findall to get all the links
            links = re.findall('"((http|ftp)s?://.*?)"', html)
            print (links)
            break
        except ValueError as e:
            print(e)
            sys.exit()
        except KeyboardInterrupt:
            print ("You pressed Ctrl+C")
            sys.exit()

if __name__ == "__main__":
    main()
