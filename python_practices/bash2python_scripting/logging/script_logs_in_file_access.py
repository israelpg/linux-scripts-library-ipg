import os
import socket
import logging

def accessed(username, IP_address):
    logging.info('Logged in from {IP} as {user}'.format(IP=IP_address, user=username))

# Define format of log file and set basicConfig:
FORMAT = '%(asctime)s - %(name)s - %(levelname)s -  %(message)s'
logging.basicConfig(filename='access.log', filemode='a+', format=FORMAT, datefmt='%d-%b-%y %H:%M:%S', level=logging.INFO)

# expected output:
# 22-Jan-20 15:28:21 - root - INFO -  Logged in from 127.0.0.1 as israel

# Setting some variables for IP origin and username, call function to log access:
IP_address = socket.gethostbyname('localhost') 
username = os.popen('whoami').read()
username = username.strip()
print('Accessing system with username: ', username, ' from IP address: ', IP_address)
accessed(username, IP_address)