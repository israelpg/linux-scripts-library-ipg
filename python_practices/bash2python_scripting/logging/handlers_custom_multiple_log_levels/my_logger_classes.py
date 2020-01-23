# Handlers: Using a logging class
# Warnings are displayed in the Console / Shell
# Errors are written in a log file

import logging

def func1():
    a = 5
    b = 0

    try:
        c = a / b
        print(c)
    except Exception:
        logger.error("Exception occurred", exc_info=True)

# Create a custom logger named logger
logger = logging.getLogger(__name__)

# Create handlers for Console (StreamHandler) and File (FileHandler)
c_handler = logging.StreamHandler()
f_handler = logging.FileHandler('logfile1.log')
c_handler.setLevel(logging.WARNING)
f_handler.setLevel(logging.ERROR)

# Create formatters and add it to handlers
c_format = logging.Formatter('Logger: %(name)s - pid: %(process)d - %(levelname)s - %(message)s')
f_format = logging.Formatter('%(asctime)s - Logger: %(name)s - pid: %(process)d - %(levelname)s - %(message)s: %(pathname)s')
c_handler.setFormatter(c_format)
f_handler.setFormatter(f_format)

# Add handlers to the logger
logger.addHandler(c_handler)
logger.addHandler(f_handler)

logger.warning('This is a warning')

# raising an error
func1()

# Output in file looks like this:
# In [40]: cat logfile1.log
# 2020-01-23 10:38:13,510 - __main__ - pid: 448795 - ERROR - This is an error in file: : my_logger_classes.py
# NoneType: None
# 2020-01-23 10:46:09,278 - Logger: __main__ - pid: 450890 - ERROR - Exception occurred: my_logger_classes.py
# Traceback (most recent call last):
#   File "my_logger_classes.py", line 8, in func1
#     c = a / b
# ZeroDivisionError: division by zero