### Using os.system("bash commands")
In [83]: host
Out[83]: '127.0.0.1'

In [84]: os.system("ping -c 1 " + host)

### Using subprocess.call
In [85]: subprocess.call(["ls", "-lah"])
total 0
drwxrwxr-x. 1 israel israel   72 Sep 17 17:00 .
drwxrwxr-x. 1 israel israel 3.1K Sep 16 15:40 ..
drwxrwxr-x. 1 israel israel  116 Sep 17 17:02 ipython
drwxrwxr-x. 1 israel israel  168 Sep 17 16:46 monitoring
drwxrwxr-x. 1 israel israel  104 Sep 17 16:46 networking
drwxrwxr-x. 1 israel israel   86 Sep 17 16:40 utilities
Out[85]: 0

### PREFERRED METHOD, USING Popen:
In [88]: command = ['date']
    ...: command.append('+%Y-%m-%d %H:%M:%S')
    ...: (out,err) = subprocess.Popen(command,stdout=subprocess.PIPE).communicate()
    ...: print out
    ...:
2019-09-17 17:04:38



