#!/usr/bin/bash

from urllib.request import urlopen
import re

def main():
    try:
        thisURL = "http://checkip.dyndns.org"
        print ("Checking this website {checkURL} in order to get IP Address".format(checkURL=thisURL))
        request = urlopen(thisURL).read().decode("utf-8")
        theIP = re.findall(r"[0-9]+(?:\.[0-9]+){3}", request)
        print ("Your public IP Address is: ",  theIP)
    except ValueError as e:
        print (e)
        sys.exit()

if __name__ == "__main__":
    main()
