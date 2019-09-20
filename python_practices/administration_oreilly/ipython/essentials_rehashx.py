In [165]: %rehashx?
Docstring:
Update the alias table with all executable files in $PATH.

rehashx explicitly checks that every entry in $PATH is a file
with execute access (os.X_OK).

Under Windows, it checks executability as a match against a
'|'-separated string of extensions, stored in the IPython config
variable win_exec_ext.  This defaults to 'exe|com|bat'.

This function also resets the root module cache of module completer,
used on slow filesystems.
File:      /usr/lib/python2.7/site-packages/IPython/core/magics/osm.py

