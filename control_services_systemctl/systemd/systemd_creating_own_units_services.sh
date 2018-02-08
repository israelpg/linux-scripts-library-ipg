# units may be created for adding new services to systemd, another option is to modify a current unit / systemd

# practical example:

# As a sysadmin creating a second instance of sshd service:
# you may adapt the configuration file, with some parameters, and then the systemd service itself, see below:

# first creating a config copy of sshd.conf

cp /etc/ssh/sshd_config /etc/ssh/sshd-second_config

# edit some parameters for this new config file:

nano -c /etc/ssh/sshd-second_config

Port 22220
PidFile /var/run/sshd-second.pid # this is created automatically by the system at first run

# create a copy of the systemd default unit file for sshd.service: to find it use systemctl status sshd.service
# the default .service file is stored in /usr/lib ... but needs to be placed in /etc/systemd/system for running it:

cp /usr/lib/systemd/system/sshd.service /etc/systemd/system/sshd-second.service

nano -c /etc/systemd/system/sshd-second.service

# original settings:

[Unit]
Description=OpenSSH server daemon
Documentation=man:sshd(8) man:sshd_config(5)
After=network.target sshd-keygen.service
Wants=sshd-keygen.service

[Service]
Type=forking
PIDFile=/var/run/sshd.pid
EnvironmentFile=/etc/sysconfig/sshd
ExecStart=/usr/sbin/sshd $OPTIONS
ExecReload=/bin/kill -HUP $MAINPID
KillMode=process
Restart=on-failure
RestartSec=42s

[Install]
WantedBy=multi-user.target

# modified for this second config of the systemd unit service for sshd service called: sshd-second.service

# original settings:

[Unit]
Description=OpenSSH server daemon - second config instance daemon - sysadmin testing purposes
Documentation=man:sshd(8) man:sshd_config(5)
After=network.target sshd-keygen.service syslog.target auditd.service sshd.service ### notice sshd.service must start before this 2nd !!!
Wants=sshd-keygen.service

[Service]
EnvironmentFile=/etc/sysconfig/sshd
ExecStart=/usr/sbin/sshd -D -f /etc/ssh/sshd-second_config $OPTIONS # necessary to run second config!
ExecReload=/bin/kill -HUP $MAINPID
KillMode=process
Restart=on-failure
RestartSec=42s

[Install]
WantedBy=multi-user.target

# if using SELinux, add the port for the second instance of sshd to SSH ports, otherwise the second instance of sshd will be rejected to bind to the port:

semanage port -a -t ssh_port_t -p tcp 22220

# enable sshd-second.service, so that it starts automatically upon boot:

systemct enable sshd-second.service

# check status, and connect to the service to test it:

systemct status sshd-second.service

ssh -p 22220 user@server


# Creating an extension of a service in subfolder within systemd: /etc/systemd/system/<servicename>.service.d/<configfilename>.conf :
nano -c /etc/systemd/system/<name.service.d>/<file>.conf
# for example with httpd.service:
nano -c /etc/systemd/system/httpd.d/httpd.conf
# and modify the .service file:
nano -c /etc/systemd/system/<existing_servicename>.service # this is a replacement

# or you can create the extension within folder:

nano -c /etc/systemd/system/init.d/<existing_servicename>.service # and it will extend the original .service file in .. folder

systemctl daemon-reload

systemctl restart <servicename>.service








