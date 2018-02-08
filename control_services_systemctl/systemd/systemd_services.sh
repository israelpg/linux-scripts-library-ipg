### systemd (always use .service extension!!!)

# listing all services available in our system (enabled/disabled):

systemctl -a

# listing loaded services:

systemctl list-units --type service

# listing enabled/disabled services:

systemctl list-unit-files --type service

# enable a service:

systemctl enable <service_name>

# disable:

systemctl disable <service_name>

# service status

systemctl status <service_name>

# to determine if is-active one of the services specifically:

systemctl is-active <service_name>

# to determine if is-enabled

systemctl is-enabled <service_name>

### dependencies, and determine the start order for several dependent services:
# for instance, which service to start before service gdm.service:

systemctl list-dependencies --after gdm.service

# to list what services are ordered to start after the specified service:

systemctl list-dependencies --before gdm.service

# different actions:

systemctl start sshd.service
systemctl stop sshd.service
systemctl restart sshd.service

# even reloading config, for instance in bind9 after config changes, eg: updating zones:
systemctl reload bind9.service

# disable and enable again:

systemctl reenable httpd.service

### targets:

# targets substitute sysv runlevels, for instance, graphical.target is runlevel 5 equivalence. And it collects an architectural list of services (dependencies)

systemctl list-units --type target

# to get default target, normally graphical.target, type:

systemctl get-default

# to change to another target, let's say: multi-user, but just for this session:

systemctl isolate multi-user.target

# to change, in this case DEFAULT TARGET:

systemctl set-default multi-user.target

# TO ENTER IN RECUE MODE:

systemctl rescue
# without wall message:

systemct rescue --no-wall rescue

# even more critical: emergency mode

systemctl emergency
systemctl --no-wall emergency


### CONTROLLING SHUTDOWN, SLEEP, SUSPEND, AND SO ON VIA SYSTEMCTL:

# electricity off:

systemctl poweroff

# at a certain time:

systemctl poweroff --halt 15:45

# just shutdown:

systemctl shutdown
systemctl --no-wall shutdown

# cancel shutdown as root:

shutdown -c

# restart

systemctl restart

# reboot:

systemctl reboot

# suspend: saving state in RAM, faster but vulnerable to power cut off

systemctl suspend

# hibernate: saving state in hard disk

systemctl hibernate

# both: hibernate and suspend:

systemctl hybrid-sleep



### CONTROLLING SYSTEMD ON A REMOTE MACHINE:

systemctl --host username@hostname command

# example:

systemctl -H natasa@10.57.121.192 status httpd.service



