
# element, start, end

In [13]: list1 = [1, 2, 3, 4, 1, 1, 1, 4, 5]

# index of element 4 starting from index 4 to 8 (therefore discarding 4 in index 3)
In [14]: print(list1.index(4, 4, 8))
7

# index can be useful when slicing a log file:
# example of a log line: '127.0.0.1 - frank [10/Oct/2000:13:55:36 -0700] "GET http://myweb.com/apache_pb.gif HTTP/1.0" 200 2326'
# Getting access date:
In [127]: line[line.index("[")+1:line.index("]")]
Out[127]: '10/Oct/2000:13:55:36 -0700'

# or getting the url:
line[line.index("GET")+4:line.index("HTTP")]

# a nice script can be found here:
# /home/israel/git_repos/linux-scripts-library-ipg/python_practices/bash2python_scripting/logging_operations
# script name: apache_logfile_counter_access.py
