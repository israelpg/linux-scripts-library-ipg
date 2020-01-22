import logging

logging.debug('This is a debug message')
logging.info('This is an info message')
logging.warning('This is a warning message')
logging.error('This is an error message')
logging.critical('This is a critical message')

WARNING:root:This is a warning message
ERROR:root:This is an error message
CRITICAL:root:This is a critical message

# Notice that the debug() and info() messages didn’t get logged. 
# This is because, by default, the logging module logs the messages 
# with a severity level of WARNING or above. You can change that by 
# configuring the logging module to log events of all levels if you want. 
# You can also define your own severity levels by changing 
# configurations, but it is generally not recommended as it can cause 
# confusion with logs of some third-party libraries that you might be using.

# Configure the logging options:
# basicConfig
# default message uses this kind of format --> ERROR:root:This is an error message

# Some of the commonly used parameters for basicConfig() are the following:

# level: The root logger will be set to the specified severity level.
# filename: This specifies the file.
# filemode: If filename is given, the file is opened in this mode. The default is a, which means append.
# format: This is the format of the log message.

import logging

logging.basicConfig(level=logging.DEBUG)
logging.debug('This will get logged')

DEBUG:root:This will get logged

### Logging to a file rather than the console:

# Similarly, for logging to a file rather than the console, filename and filemode can be used, and 
# you can decide the format of the message using format. The following example shows the usage of all three:
# basicConfig --> Basically, this function can only be called once!!!

logging.basicConfig(filename='app.log', filemode='w', format='%(asctime)s - %(name)s - %(levelname)s - %(message)s')
logging.warning('This will get logged to a file')

root - ERROR - This will get logged to a file

# The default configuration for filemode is a, which is append.

# All options to basicConfig on: https://docs.python.org/3/library/logging.html#logging.basicConfig
# and here: https://docs.python.org/3/library/logging.html