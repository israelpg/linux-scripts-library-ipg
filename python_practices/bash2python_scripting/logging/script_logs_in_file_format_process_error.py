import sys
import subprocess
import logging

def func1():
    a = 5
    b = 0

    try:
        c = a / b
        print(c)
    except Exception:
        logging.error("Exception occurred", exc_info=True)

FORMAT = '%(asctime)s - %(name)s - pid: %(process)d - %(levelname)s - %(message)s: %(pathname)s \
raised at line %(lineno)d on function: %(funcName)s'
logging.basicConfig(filename='app_process.log', filemode='a+', format=FORMAT, level=logging.ERROR)

# I trigger an error, nothing relevant, just trigger to test error line in log file:
func1()

# dbbglbgl
# ZGJiZ2xiZ2w=