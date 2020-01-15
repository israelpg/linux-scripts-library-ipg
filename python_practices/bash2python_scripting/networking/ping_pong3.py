import sys
import os
import subprocess

def main():
    subprocess.call(['clear'])
    sys.stdout.flush()

    if os.path.isfile("listHosts.txt"):
        hostsfile=open("listHosts.txt", "r")
        if hostsfile.mode == "r":
            lines=hostsfile.readlines()
        else:
            print('Cannot open file for reading')
    else:
        print('File does not exist')

    try:
        for line in lines:
            response=subprocess.Popen(["ping", "-c", "1", line.strip()],
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT)
            stdout, stderr = response.communicate()
            print(stdout)
            print(stderr)

            if (response.returncode == 0):
                status = line.rstrip() + " is Reachable"
            else:
                status = line.rstrip() + " is Not reachable"
            
            print(status)

    except ValueError as e:
        print(e)
        sys.exit()

    except KeyboardInterrupt:
        print ("You pressed Ctrl+C")
        sys.exit()

    sys.exit()

if __name__ == "__main__":
    main()