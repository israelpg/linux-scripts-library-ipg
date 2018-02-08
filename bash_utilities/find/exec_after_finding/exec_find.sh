#!/bin/bash

find . -type f ! -user natasa -exec chown natasa:profesores {} \;

sudo sudo find . -type d -perm 755 -exec chmod 775 {} \;
