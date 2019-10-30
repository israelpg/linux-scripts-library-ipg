import subprocess
subprocess.call(["ls", "-ltr"])

# without arguments use the shell=True ::

subprocess.call("ls", shell=True)

