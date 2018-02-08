#!/bin/bash

find backup/ -type f -user israel ! -perm 777 | xargs sha1sum >> directory.sha1

