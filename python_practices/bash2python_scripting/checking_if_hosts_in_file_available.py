#!/usr/bin/python3
import socket
import subprocess
import sys
import os

def main():
    # Clear the screen
    subprocess.call('clear', shell=True)
    # Clear buffer
    sys.stdout.flush()
    filename = "list_hosts.txt"
    # Print a nice banner with information
    print ("-" * 60)
    print ("Please wait, checking remote hosts availability in file", filename)
    print ("-" * 60)
    # working with the file containing list of hosts
    with open(filename) as f:
        for hostname in f:
            hostname = hostname.strip()
            remoteServerIP  = socket.gethostbyname(hostname)
            # We also put in some error handling for catching errors
            try:
                port = 80
                sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
                result = sock.connect_ex((remoteServerIP, port))
                if result == 0:
                    print ("Port {}:      Open".format(port))
                    print ("Hostname {} is running and available via IP: ".format(hostname, remoteServerIP))
                sock.close()

            except KeyboardInterrupt:
                print ("You pressed Ctrl+C")
                sys.exit()

            except socket.gaierror:
                print ("Hostname could not be resolved. Exiting")
                sys.exit()

            except socket.error:
                print ("Couldn't connect to server")
                sys.exit()

if __name__ == '__main__':
    main()
