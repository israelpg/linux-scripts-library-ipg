processes = !ps -aux
In [85]: listProcesses=processes.grep('israel').fields(1)
In [85]: for process in listProcesses:                 
    ...:     print(process)  

18482
18601
18956
19056
19059
19072

# ok one way to kill processes in a loop:

for process in listProcesses:
    ...:     !kill -9 process


