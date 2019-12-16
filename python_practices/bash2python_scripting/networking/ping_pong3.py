import sys
import subprocess

sys.stdout.flush()

hostsfile=open("listHosts.txt", "r")

lines=hostsfile.readlines()

try:
    for line in lines:
        response=subprocess.Popen(["ping", "-c", "1", line.strip()],
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT)
        #stdout, stderr = response.communicate()
        #print(stdout)
        #print(stderr)

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