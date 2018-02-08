#!/bin/bash

# using package mcrypt (crypt is obsolete)

mcrypt < file_to_encrypt > encrypted # and you will type paraphrase/passwd

# to decrypt:

mcrypt -d encrypted > output
