#!/usr/bin/python3

import sys
from datetime import datetime

sys.stdout.flush()

now = datetime.now()

mm = str(now.month)

dd = str(now.day)

yyyy = str(now.year)

hour = str(now.hour)

mi = str(now.minute)

ss = str(now.second)

print ('datetime.now is: ', now)

print (mm + "/" + dd + "/" + yyyy + " " + hour + ":" + mi + ":" + ss)

# in case of errors with bad magic number, execute:
# find . -name "*.pyc" -exec rm -f {} \;

