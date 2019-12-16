import sys
import subprocess
import socket

def pingHost(hostname):
    remoteServerIP  = socket.gethostbyname(hostname)
    response=subprocess.Popen(["ping", "-c", "1", remoteServerIP],
    stdout=subprocess.PIPE,
    stderr=subprocess.STDOUT)
    stdout, stderr = response.communicate()
    print(stdout)
    print(stderr)

def main():
    sys.stdout.flush()
    # getting user input: hostname
    while True:
        try:
            thisHostname = input("Please enter a hostname to ping: ")
            if not thisHostname:
                print ("You need to enter a hostname")
                continue
            print ("Ping to ", thisHostname, " in progress...")
            break
        except ValueError as e:
            print(e)
            sys.exit()
        except KeyboardInterrupt:
            print ("You pressed Ctrl+c")
            sys.exit()

    pingHost(thisHostname)    

if __name__ == "__main__":
    main()