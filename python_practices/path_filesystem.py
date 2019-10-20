# from one side, the system path: sys.path

In [171]: sys.path
Out[171]:
['',
 '/usr/bin',
 '/usr/lib/python27.zip',
 '/usr/lib64/python2.7',
 '/usr/lib64/python2.7/plat-linux2',
 '/usr/lib64/python2.7/lib-tk',
 '/usr/lib64/python2.7/lib-old',
 '/usr/lib64/python2.7/lib-dynload',
 '/usr/lib64/python2.7/site-packages',
 '/usr/lib64/python2.7/site-packages/gtk-2.0',
 '/usr/lib/python2.7/site-packages',
 '/usr/lib/python2.7/site-packages/IPython/extensions',
 '/home/israel/.ipython']

In [172]: sys.path[0]
Out[172]: ''

In [173]: sys.path[1]
Out[173]: '/usr/bin'

# the list can be managed, for instance appending a new element (path):

sys.path.append('/tmp')

## Another option is to use the os and check for directories, files, symblinks ...

import os
In [177]: os.path.isdir('/usr')
Out[177]: True

In [178]: os.path.isdir('/noexiste')
Out[178]: False

In [179]: os.path.isfile('noexiste')
Out[179]: False

# other options:
os.path.abspath                    os.path.defpath
                   os.path.altsep                     os.path.devnull
                   os.path.basename                   os.path.dirname                    >
                   os.path.commonprefix               os.path.exists
                   os.path.curdir                     os.path.expanduser
