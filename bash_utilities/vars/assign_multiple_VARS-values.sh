#!/bin/bash

nameservers="server1.net server2.net server3.net"

# ups, I forgot to add server4.net

nameservers="${nameservers} server4.net"

read -r sn1 sn2 sn3 sn4 <<< "$nameservers"

# another example:

pwd=$(tail -n 1 /etc/passwd)

IFS=: # Internal File Separator, instead of default value space, is now : (as /etc/passwd requires)

read -r login password uid gid info home shell <<< "$pwd"
printf "Your login name is %s, uid %d, gid %d, home dir set to %s with %s as login shell\n" $login $uid $gid $home $shell


