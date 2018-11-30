ssh-keygen -t rsa

# keys are generated for user running the command under folder:
~/.ssh


# .pub key to be copied in the server's folder:

/etc/authorized_keys

# command to copy ssh key:

ssh-copy-id user@hostname


# when moving to another machine, backup the .ssh folder and paste it in the new machine, it will be easier than generate again the key

# connecting to a server, fingerprint crosscheck with your pub key, to see if is valid:

ssh-keygen -l -f ~/id-rsa.pub

# more info :

The authenticity of host 'penguin.example.com' can\'t be established.
SHA256 key fingerprint is SHA256:vuGKK9dsW34zrZzwjl5g+vOE6EZQvHRQ8zObKYO2mW4.
SHA256 key fingerprint is MD5:7e:15:c3:03:4d:e1:dd:ee:99:dc:3e:f4:b9:67:6b:62.
Are you sure you want to continue connecting (yes/no)?

ssh-keygent -l -f ~/.ssh/id-rsa.pub
SHA256:vuGKK9dsW34zrZzwjl5g+vOE6EZQvHRQ8zObKYO2mW4

# SHA256 fingerprint for this server is using a key ended up in mW4 ... check your pub key to see whether is yours, if so, then "yes" and connect

# Client to remove the key from the known_hosts file:

ssh-keygen -R hostname
