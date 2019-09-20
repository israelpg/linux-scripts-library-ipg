import subprocess

hostsfile=open("listHosts.txt", "r")

lines=hostsfile.readlines()

for line in lines:
    response=subprocess.Popen(["ping", "-c", "1", line.strip()],
    stdout=subprocess.PIPE,
    stderr=subprocess.STDOUT)
    stdout, stderr = response.communicate()
    #print(stdout)
    #print(stderr)

    if (response.returncode == 0):
        status = line.rstrip() + " is Reachable"
    else:
        status = line.rstrip() + " is Not reachable"
    print(status)
