#!/bin/bash

zip --password <literalpassword> protectedCompressed.zip thisFolder/

unzip protectedCompressed.zip # it will request the password in order to uncompress the files
