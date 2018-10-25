## input param validation

import save
import sys

pardict={}

def usage(reqargs):
	raise Exception, 'Usage: <script> %s' % reqargs


def validateparams(reqargs):
	arglen=len(sys.argv)
	if arglen > 0 and sys.argv[arglen-1] == '-nosave':
		params=sys.argv[:arglen-1]
		save.save=0
		arglen=arglen-1
		print 'Option -nosave specified: work will NOT be saved'
	else:
		params=sys.argv
		save.save=1
		print 'Work will be saved'

	## print "arglen "+ str(arglen)
	## print "len(reqargs) "+ str(len(reqargs))
	
	if arglen > len(reqargs):
		usage(reqargs)
		
	if arglen < len(reqargs):
		if reqargs[arglen][0] != '[':
			usage(reqargs)

	for x in range(arglen):
		curarg = sys.argv[x]
		pardict[reqargs[x]]=curarg

	## print pardict
	