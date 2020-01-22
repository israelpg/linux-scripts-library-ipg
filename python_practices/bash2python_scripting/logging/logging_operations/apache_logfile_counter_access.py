#!/usr/bin/python3

import subprocess
import sys
import os
import collections

def main():
    # Clear the screen
    subprocess.call('clear')
    # Clear buffer
    sys.stdout.flush()
    # Listing all log files in this . directory:
    subprocess.call(['ls', '-lah'])
    while True:
        logfile = input('Please, type a log file name or q to exit: ')
        if logfile == "q": sys.exit() 
        if not os.path.isfile(logfile):
            print('File', logfile, ' does not exist, try again: ')
        else:
            print('Processing log file: ', logfile)
            break
    
    try:
        logfile = open("yourlogfile.log", "r")
        if logfile.mode == "r":
            clean_log=[]
            for line in logfile:
                try:
                    line = line.strip()
                    # copy the URLS to an empty list.
                    # We get the part between GET and HTTP with a slice (using .index to determine positions)
                    clean_log.append(line[line.index("GET")+4:line.index("HTTP")]) # same as line[52:83]
                except:
                    pass

            counter = collections.Counter(clean_log)

            # get the Top 3 most popular URLs
            for count in counter.most_common(3):
                print(str(count[1]) + "	" + str(count[0]))
        else:
            print('Cannot open file for reading')
    except KeyboardInterrupt:
        print ("You pressed Ctrl+C")
        sys.exit()
    except ValueError:
        print ("There was an error")
        raise
    except IOError as e:
        print ("I/O error({0}): {1}".format(e.errno, e.strerror))
        raise
    except:
        print ("Unexpected error:", sys.exc_info()[0])
        raise
    finally:
        logfile.close()

if __name__ == "__main__":
    main()