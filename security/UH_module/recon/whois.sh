#!/bin/bash

# whois filtering only DNS Servers information:

whois 10.198.22.58 | grep 'Name Server' | awk -F ':' '{print $2}'

#Advanced

# If  you  are  feeling  brave...  you  might  have  identified  an  individual,  or  a  number  of  individuals  working  for  an 
# organisation  and  you  just  might  want  to  identify  everything  they  are  responsible  of,  as  far  as  NETENUM  is 
# concerned. The following example will return all of the ‘whois’ records maintained by the lovely Yahoo people.
# man whois
# -i ATTR[,ATTR]...
# Search  objects  having  associated  attributes. ATTR is attribute name.  Attribute value is positional
# OBJECT argument.


whois –i mnt-by YAHOO-MNT

#OK? Impressed? What is that? You want the IP address ranges? Here you are:

whois –i mnt-by YAHOO-MNT | grep inetnum
