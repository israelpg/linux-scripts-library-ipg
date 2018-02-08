#!/bin/bash

# total:

tar -jcvf name.tar.bz2 /folder1/*

# differential / incremental: checking timestamp, if different than already saved or is a new file, it is append:

tar -juvf name.tar.bz2 /folder1/*

## restore:

tar -jxvf name.tar.bz2 -C /here/ --keep-newer-files # if in disk we have lates version is kept, therefore not overwritten by bkp
tar -jxvf name.tar.bz2 -C /here/ --overwrite # bkp files will overwrite disk folder when restoring copy



