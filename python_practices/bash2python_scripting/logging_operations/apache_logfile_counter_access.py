#!/usr/bin/python3

import subprocess
import sys
import os
import collections

def main():
    # Clear the screen
    subprocess.call('clear', shell=True)
    # Clear buffer
    sys.stdout.flush()
    
    while True:
        logfile = input("Type the log file name: ")
        if os.path.isfile(logfile):
            try:
                logfile = open("yourlogfile.log", "r")
                break
            except IOError:
                print ("Error, cannot open file")
        else:
            print ("Log file name", logfile, " does not exist")
            continue
          
    clean_log=[]

    for line in logfile:
        try:
            # copy the URLS to an empty list.
            # We get the part between GET and HTTP (from line the 4th to http)
            clean_log.append(line[line.index("GET")+4:line.index("HTTP")])
        except:
            pass

    counter = collections.Counter(clean_log)

    # get the Top 50 most popular URLs
    for count in counter.most_common(50):
        print(str(count[1]) + "	" + str(count[0]))

    logfile.close()

if __name__ == "__main__":
    main()
