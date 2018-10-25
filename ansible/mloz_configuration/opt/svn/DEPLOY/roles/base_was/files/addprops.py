import sys
sys.path.append('../share/procs')

import save
import validateparams

def setprop(sname, pname,pvalue):
  server = AdminConfig.getid('/Server:'+sname+'/')
  print "found %s" % server
  jvm = AdminConfig.list('JavaVirtualMachine', server)
  print "found %s" % jvm
  AdminConfig.modify(jvm,[
                ['systemProperties',[[['name',pname],['value',pvalue]]]]
                ])

validateparams.validateparams([])