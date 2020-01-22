#!/usr/bin/python3

# Two options:
# import whois
# or install whois package using pip:
# sudo pip install python-whois

In [13]: infoSite = whois.whois("pythonforbeginners.com")

In [14]: infoSite
Out[14]:
{u'address': [u'DomainsByProxy.com', u'14455 N. Hayden Road'],
 u'city': u'Scottsdale',
 u'country': u'US',
 u'creation_date': datetime.datetime(2012, 9, 15, 20, 41, 46),
 u'dnssec': u'unsigned',
 u'domain_name': [u'PYTHONFORBEGINNERS.COM', u'pythonforbeginners.com'],
 u'emails': [u'abuse@godaddy.com',
  u'pythonforbeginners.com@domainsbyproxy.com'],
 u'expiration_date': datetime.datetime(2020, 9, 15, 20, 41, 46),
 u'name': u'Registration Private',
 u'name_servers': [u'NS-1464.AWSDNS-55.ORG',
  u'NS-1840.AWSDNS-38.CO.UK',
  u'NS-489.AWSDNS-61.COM',
  u'NS-980.AWSDNS-58.NET'],
 u'org': u'Domains By Proxy, LLC',
 u'referral_url': None,
 u'registrar': u'GoDaddy.com, LLC',
 u'state': u'Arizona',
 u'status': [u'clientDeleteProhibited https://icann.org/epp#clientDeleteProhibited',
  u'clientRenewProhibited https://icann.org/epp#clientRenewProhibited',
  u'clientTransferProhibited https://icann.org/epp#clientTransferProhibited',
  u'clientUpdateProhibited https://icann.org/epp#clientUpdateProhibited',
  u'clientTransferProhibited http://www.icann.org/epp#clientTransferProhibited',
  u'clientUpdateProhibited http://www.icann.org/epp#clientUpdateProhibited',
  u'clientRenewProhibited http://www.icann.org/epp#clientRenewProhibited',
  u'clientDeleteProhibited http://www.icann.org/epp#clientDeleteProhibited'],
 u'updated_date': [datetime.datetime(2019, 9, 16, 13, 39, 13),
  datetime.datetime(2019, 9, 16, 13, 39, 12)],
 u'whois_server': u'whois.godaddy.com',
 u'zipcode': u'85260'}

In [15]: infoSite.name_servers
Out[15]:
[u'NS-1464.AWSDNS-55.ORG',
 u'NS-1840.AWSDNS-38.CO.UK',
 u'NS-489.AWSDNS-61.COM',
 u'NS-980.AWSDNS-58.NET']

In [16]:

