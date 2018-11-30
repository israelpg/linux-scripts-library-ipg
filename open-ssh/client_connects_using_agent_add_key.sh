#!/bin/bash

sudo ssh-agent bash -c 'ssh-add /home/israel/.ssh/id_rsa; git pull origin master'
