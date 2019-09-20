import os

hostsfile=open("listHosts.txt", "r")

lines=hostsfile.readlines()

for line in lines:
    response=os.system("ping -c 1 " + line)
    if (response == 0):
        status = line.rstrip() + " is reachable"
    else:
        status = line + " is not reachable"
    print(status)
