#!/bin/bash

# -i to overwrite file with output -n silent remove pattern:
sed -n -i '/mobile phones/!p' prueba.txt 
