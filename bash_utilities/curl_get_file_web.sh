#!/bin/bash

curl -O https://apt.puppetlabs.com/puppetlabs-release-pc1-xenial.deb

# You can download a file from source and pipe to execution in bash:

curl -s https://raw.githubusercontent.com/AWSinAction/code/master/chapter5/irc-create-cloudformation-stack.sh | bash -ex
