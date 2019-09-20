import os

host = input('Please, enter host to ping: ')
response = os.system("ping -c 1 " + host)

if (response == 0):
    status = host + " is Reachable"
else:
    status = host + " is Not reachable"

print(status)
