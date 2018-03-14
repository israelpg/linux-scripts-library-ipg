#!/bin/bash

od -a filename.txt

israel@israel-N56JN:~/git/workspace_linux_scripts$ od -a /tmp/test.txt
0000000   t   h   i   s  sp   i   s  sp   a  sp   s   a   m   p   l   e
0000020  sp   t   e   x   t  sp   f   i   l   e  sp  nl
0000034
israel@israel-N56JN:~/git/workspace_linux_scripts$ sed -i 's/[[:space:]]*$//' /tmp/test.txt
israel@israel-N56JN:~/git/workspace_linux_scripts$ od -a /tmp/test.txt
0000000   t   h   i   s  sp   i   s  sp   a  sp   s   a   m   p   l   e
0000020  sp   t   e   x   t  sp   f   i   l   e  nl
0000033

