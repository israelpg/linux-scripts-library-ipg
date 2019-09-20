import socket
    
thisHostname = socket.gethostname()
thisIP = socket.gethostbyname(socket.gethostname())
print('Details for this machine: Hostname is ', thisHostname, ' and IP is: ', thisIP)
