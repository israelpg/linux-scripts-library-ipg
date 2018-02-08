#!/bin/bash

# todos los files que encuentra en /backup los procesa con xargs
# y los redirige a un archivo .md5, se usa >> append para incrementar

find /backup -type f -print0 | xargs md5sum >> directory.md5


