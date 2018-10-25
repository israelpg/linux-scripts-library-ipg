#!/bin/bash

$ nslookup s999lnx81.gfdi.be
Server:		127.0.1.1
Address:	127.0.1.1#53

Non-authoritative answer:
Name:	s999lnx81.gfdi.be
Address: 10.198.22.81

# using the interactive nslookup capabilities:
# checking for mail servers:
israel@W9980173 ~ $ nslookup 
> set type=MX	
> simpledns.com
Server:		127.0.1.1
Address:	127.0.1.1#53

Non-authoritative answer:
simpledns.com	mail exchanger = 0 simpledns-com.mail.protection.outlook.com.

Authoritative answers can be found from:
simpledns-com.mail.protection.outlook.com	internet address = 213.199.154.138
simpledns-com.mail.protection.outlook.com	internet address = 213.199.154.106

# checking for DNS servers:
israel@W9980173 ~ $ nslookup 
> set type=ns
> simpledns.com
Server:		127.0.1.1
Address:	127.0.1.1#53

Non-authoritative answer:
simpledns.com	nameserver = ns1.simpledns.com.
simpledns.com	nameserver = ns2.simpledns.com.

Authoritative answers can be found from:
ns1.simpledns.com	internet address = 108.61.210.155
ns1.simpledns.com	has AAAA address 2001:19f0:6c00:9009::100
ns2.simpledns.com	internet address = 104.207.152.161
ns2.simpledns.com	has AAAA address 2001:19f0:6001:1a0::100


