# Some monitoring tasks with subprocess.call

import subprocess

# disk
diskSpace = "df"
diskSpace_arg = "-h"

# mem
freeMem = "free"
freeMem_arg = "-m"

print('Disk Info:')
subprocess.call([diskSpace,diskSpace_arg])

print('Mem Info:')
subprocess.call([freeMem,freeMem_arg])
print('')

# An easy way to pass a command+args is to do the following subprocess.call : 

subprocess.call("ps -eo pmem,pcpu,nice,comm,tty,user --sort=-pmem | head -n 6", shell=True)


