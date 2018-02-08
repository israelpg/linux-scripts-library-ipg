#!/bin/bash

# adding a key in apt for authenticating source and automate updates, for instance in jenkins:

wget -q -O - https://whatever.io.key | sudo apt-key add -

# explanation: -q for not displaying too many details
# -O for redirecting the content of the url into a file or standard input, in this case:
# - (std input)
# which is used as input for the apt-key add - (using again -)


