#!/bin/bash

tar -cvf - *.{txt,sh} | ssh natasa@10.57.122.76 "tar -xvf - -C ~/tests"

tar -cvf - user_input | sudo ssh natasa@10.57.122.76 "tar -xvf - -C ~/tests"


# When compressing, we do not specify a filename, instead we use - to indicate it will be input
# then pipe | and we open ssh executing a command by using double quotes " "
# decompress the file we passed as argument with - , indicate which folder we decompress by typing -C (change dir)
