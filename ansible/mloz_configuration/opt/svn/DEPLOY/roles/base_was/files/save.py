save = 0

def savework(AdminConfig):
	if save:
		print 'Saving work'
		AdminConfig.save()
	else:
		print '!!! Dry run only - NOT saving work !!!'
