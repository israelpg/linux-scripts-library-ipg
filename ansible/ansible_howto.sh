#!/bin/bash

# Installation and setup:

# 1st) Make sure the epel-release repository is installed

sudo yum list installed epel-release

# otherwise, install it as follows:

sudo yum install -y epel-release

# then install ansible package:

sudo yum install -y ansible

##### Rational: The Ansible Server needs to be configured:

## 1) Configuring Ansible hosts: These are the hosts managed by Ansible Server

## You can create groups of servers, to create lists within config file:

sudo vim /etc/ansible/hosts

# simple_hosts in our network
[simple_hosts]
ubuntu1 ansible_ssh_host=10.136.137.110

# the alias does not need to map the real hostname, is just internal to ansible
# ansible_ssh_host is a property name of ansible, must be used
# just indicate the IP for the host

## 2) Configure the variables for the simple_hosts, including defined host ubuntu1, and the username to be used for connecting:

mkdir /etc/ansible/group_vars && sudo vim /etc/ansible/group_vars/simple_hosts

# then use this nomenclature at the beginning of the YAML-formatted file:
# It specifies that Ansible will use username: ip14aai in order to connect to the ansible simple_host
---
ansible_ssh_user: ip14aai

# check the connectivity from ansible server to host (it is via ssh):
# NOTE: You better add id_rsa.pub from server to each client host machine
ssh-copy-id user@host-client 
# or: 
ssh-copy-id -i /folder/this_key.pub user@host-client

## 3) Check connectivity from server to host:

[ip14aai@02DI20161235444 ~]$ ansible -m ping all
ubuntu1 | SUCCESS => {
    "changed": false, 
    "ping": "pong"
}

# You can also specify host or group:

[ip14aai@02DI20161235444 ~]$ ansible -m ping ubuntu1
ubuntu1 | SUCCESS => {
    "changed": false, 
    "ping": "pong"
}

[ip14aai@02DI20161235444 ~]$ ansible -m ping simple_hosts
ubuntu1 | SUCCESS => {
    "changed": false, 
    "ping": "pong"
}

## From Ansible Server executing a command in the client, output in server:

[ip14aai@02DI20161235444 ~]$ ansible ubuntu1 -m command -a "cat /etc/hosts"
ubuntu1 | SUCCESS | rc=0 >>
#127.0.0.1	localhost 02DI20161542844.ip14aai.com 02DI20161542844
127.0.0.1	localhost host01.example.com
127.0.1.1	02DI20161542844.ip14aai.com 02DI20161542844
10.136.137.110	02DI20161542844.ip14aai.com 02DI20161542844
192.168.1.1	02DI20161542844.ip14aai.com 02DI20161542844
192.168.56.101	02DI20161542844.ip14aai.com 02DI20161542844

### PLAYBOOKS:

# Create an .yml file, with a syntax like follows in the case of testing ping connection for recorded clients in hosts file:

[ip14aai@02DI20161235444 playbooks]$ cat test_connection.yml 
---
- hosts: simple_hosts
  remote_user: ip14aai
  tasks:
    - name: test connection
      ping:
      remote_user: Israel
[ip14aai@02DI20161235444 playbooks]$ ansible-playbook test_connection.yml 

PLAY [simple_hosts] ***********************************************************************************************************************************************************************************************

TASK [Gathering Facts] ********************************************************************************************************************************************************************************************
ok: [ubuntu2]
ok: [ubuntu1]

TASK [test connection] ********************************************************************************************************************************************************************************************
ok: [ubuntu1]
ok: [ubuntu2]

PLAY RECAP ********************************************************************************************************************************************************************************************************
ubuntu1                    : ok=2    changed=0    unreachable=0    failed=0   
ubuntu2                    : ok=2    changed=0    unreachable=0    failed=0   
