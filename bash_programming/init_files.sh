# about shell login and no-shell login:
# easy, when you start the system, you login with a certain user, that is a shell login
# if you open a new terminal, or swith with su to another user, then is a non-login shell

# init file are classified among two categories:
# global ones, and user profile, located in:
/etc
# global:
/etc/environment # save the proxy settings here, for instance
/etc/bashrc # several settings and definitions, like more env variables -- DO NOT PLAY WITH THIS!
# better as best practice to apply changes do not edit these files, better under folder:
/etc/profile.d # create the corresponding init files
# for instance, aliases:
cp /etc/bashrc /etc/profile.d/custom.sh
nano -c /etc/profile.d/custom.sh
alias c="clear"

# for just a specific user, then better configure the file available under ~, eg:
nano -c ~/.bashrc
alias c="clear

# env variables, like PATH, to be defined individually at:
~/.bash_profile

# in case of errors with /etc/bashrc leading to wrong tty sessions, regenerate it:
cp /etc/bashrc /etc/bashrc.damaged
rm /etc/bashrc
yum reinstall $(rpm -qf /etc/bashrc)





