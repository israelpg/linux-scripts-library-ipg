import subprocess

# subprocess.call(["some_command", "some_argument", "another_argument_or_path"])

subprocess.call("pwd")

subprocess.call(["ls", "-lah", "/tmp"])


### passing variables, here using the ipython shell:

In [14]: uname="uname"

In [15]: uname_arg="-a"

In [16]: subprocess.call([uname, uname_arg])
Linux W9980173 4.13.0-37-generic #42~16.04.1-Ubuntu SMP Wed Mar 7 16:03:28 UTC 2018 x86_64 x86_64 x86_64 GNU/Linux


### For instance, designing a py script which executes some monitoring tasks:
# see script : monitoring_tasks.py
