#!/usr/bin/python3
import socket
import subprocess
import sys
from datetime import datetime

def main():
    # Clear the screen
    subprocess.call('clear', shell=True)
    # Clear buffer
    sys.stdout.flush()
    # Ask for input
    while True:
        try:
            remoteServer = input("Enter a remote host to scan: ")
            if not remoteServer:
                print ("Empty string")
                continue
            remoteServerIP = socket.gethostbyname(remoteServer)
            break

        except KeyboardInterrupt:
            print "You pressed Ctrl+C"
            sys.exit()

        except socket.gaierror:
            print 'Hostname could not be resolved. Exiting'
            sys.exit()

        except socket.error:
            print "Couldn't connect to server"
            sys.exit()
        
        except ValueError as e:
            print(e)
            sys.exit()

        finally:
            # Print a nice banner with information on which host we are about to scan
            print ("-" * 90)
            print ("Please wait, scanning remote hostname {hostname} with IP {IP}".format(hostname=remoteServer,IP=remoteServerIP))
            print ("-" * 90)

    # Check what time the scan started
    t1 = datetime.now()

    # Using the range function to specify ports (here it will scans all ports between 1 and 1024)
    # We also put in some error handling for catching errors
    try:
        for port in range(1,1025):  
            sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            result = sock.connect_ex((remoteServerIP, port))
            if result == 0:
                print ("Port {}: 	 Open".format(port))
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

    # Checking the time again
    t2 = datetime.now()

    # Calculates the difference of time, to see how long it took to run the script
    total =  t2 - t1

    # Printing the information to screen
    print ("Scanning Completed in: ", total)
    
if __name__== "__main__":
    main()
