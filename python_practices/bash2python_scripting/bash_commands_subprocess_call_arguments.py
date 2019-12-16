#!/usr/bin/python3

import sys
import subprocess
subprocess.call(["ls", "-ltr"])

# without arguments use the shell=True ::
# Warning: Using shell=True can be a security hazard. See the warning under Frequently Used Arguments for details.
subprocess.call("ls", shell=True)

# checking a call:

try:
    subprocess.check_call(["ls", "-ltr"])
except:
    print("Unexpected error:", sys.exc_info()[0])
    raise