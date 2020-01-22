#!/usr/bin/python3

# This script counts the number of accesses to a Nginx Server from a specific remote IP address

# Example of Nginx access_log file:
# tail -f /var/log/nginx/domain1.access.log
# 47.29.201.179 - - [28/Feb/2019:13:17:10 +0000] "GET /?p=1 HTTP/2.0" 200 5316 "https://domain1.com/?p=1" "Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/72.0.3626.119 Safari/537.36" "2.75"

import os
import sys
import subprocess
import collections

def find_files(filename, search_path):
    print ("Searching {thisFile} in path {thisPath}".format(thisFile=filename, thisPath=search_path))
    result = []
    # Walking top-down from the root
    for root, dir, files in os.walk(search_path):
        if filename in files:
            result.append(os.path.join(root, filename))
            return result

def main():
    # Clear the screen
    subprocess.call('clear')
    # Clear buffer
    sys.stdout.flush()
    try:
        ips = []
        if os.path.isfile("nginx_access.log"): # this should point to /var/log/nginx/ in real life :)
            fh = open("nginx_access.log", "r").readlines()
            for line in fh:
                line = line.strip()
                ip = line.split(" ")[0] # split(" ") is equivalent to awk -F ' ' , and you get first element therefore [0]
                if 6 < len(ip) <=15:
                    ips.append(ip)
            
            counter = collections.Counter(ips)
            # get the Top 3
            for count in counter.most_common(3):
                print(str(count[1]) + "	" + str(count[0]))
        else:
            print ("There is a problem, file 'nginx_access.log' no longer exists or changed its location...")
            print ("Searching for it with a walk in the whole /var directory...for this example testing in /tmp dir")
            print(find_files("nginx_access.log", "/tmp"))
    except ValueError as e:
        print ("Error ", e)
        sys.exit()
    except KeyboardInterrupt:
        print ("You pressed Ctrl+C")
        sys.exit()
    except IOError as e:
        print ("I/O error({0}): {1}".format(e.errno, e.strerror))
        raise
    except:
        print ("Unexpected error:", sys.exc_info()[0])
        raise
    finally:
        fh.close()

if __name__ == "__main__":
    main()
