#!/usr/bin/python3
import socket
import subprocess
import sys

# Clear the screen
subprocess.call('clear', shell=True)

# Clear buffer
sys.stdout.flush()

# Ask for input
remoteServer = input("Enter a remote host to check availability: ")
remoteServerIP  = socket.gethostbyname(remoteServer)

# Print a nice banner with information on which host we are about to scan
print ("-" * 60)
print ("Please wait, checking remote host availability", remoteServerIP)
print ("-" * 60)

# We also put in some error handling for catching errors
try:
    port = 80
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    result = sock.connect_ex((remoteServerIP, port))
    if result == 0:
        print ("Port {}:      Open".format(port))
        print ("Host {} is running and available".format(remoteServer))
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

