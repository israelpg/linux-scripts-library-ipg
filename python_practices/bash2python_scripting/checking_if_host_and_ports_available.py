#!/usr/bin/python3
import socket
import subprocess
import sys

# Clear the screen
subprocess.call('clear')

# Clear buffer
sys.stdout.flush()

# Ask for input
remoteServer = input("Enter a remote host to check availability: ")
remoteServerIP  = socket.gethostbyname(remoteServer)
print ("Enter a port range to be explored:")
portFrom = int(input("From: "))
portTo = int(input("To: "))

# Print a nice banner with information on which host we are about to scan
print ("-" * 90)
print ("Please wait, checking remote host availability", remoteServerIP, " from port: ", portFrom, " to: ", portTo)
print ("-" * 90)

# We also put in some error handling for catching errors
try:
    for port in range(portFrom, portTo+1):
        sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        result = sock.connect_ex((remoteServerIP, port))
        if result == 0 and port == 80:
            print ("Port:  {}  is open. Host {} is running and available via http.".format(port, remoteServer))
            sock.close()
        if result == 0 and port == 22:
            print ("Port:  {}  is open. Host {} is running and available via ssh.".format(port, remoteServer))
            sock.close()
        elif result == 0:
            print ("Port: ", port, " is open.")
            sock.close()
        else:
            print ("Port: ", port, " is closed.")
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

