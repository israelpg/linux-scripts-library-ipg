1/ BIOS and Boot Loader Security
2/ Login and Password Security Policy (pam.d)
3/ Administrative Controls (who has an account in the system)
4/ Available Network Services (systemctl) + ports management (nmap - /etc/services)
5/ Personal Firewalls - scan ports with nmap, assign ports /etc/services, open ports with firewallcmd
6/ Security Enhanced Communication Tools (extra tools): xinetd for managing services
7/ Packages - GPG: workspace_linux_scripts/security_RedHat/update_install_packages_gpg
8/ Filesystems mounted as read-only
9/ bin login control or sshd login control (pam.d with /etc/security/)
10/ tcp wrappers: /etc/hosts.allow /etc/hosts.deny
11/ blocking protocols, like icmp/ping: /etc/sysctl.conf
12/ ssh: via pam.d or /etc/ssh/sshd_config

1/ Protecting BIOS, just set a password in the BIOS menu itself.

+ Linux Boot control: You can also set a GRUB password: Protection Boot Loader by implementing GRUB password:
Generate the hashed password (rh: /sbin/grub2-setpassword) or in debian following instructions in:
bootLoader_securing.sh

+ protecting Linux in case is Dual Boot with Win. By editing: grub config file (/boot/grub/grub.conf)
title DOS
lock
+ password --md5 <hashedpassword> windowsBootLine

+ not allowing prompt option while booting
/etc/sysconfig/init
PROMPT = no

2/ 
# Login and password definitions / policy
# Summary: global definition of logins in terms of password creation, uid/sid: /etc/login.defs
# password attempts, plus more rules for defining creation in length and class terms: /etc/pam.d/passwd
# faillock: defining when to block account due to wrong password entered: /etc/pam.d/system-auth & password.auth
# manual changes to edit in one specific account: chage .. passwd
# account clocked after inactivity of n days: /etc/pam.d/login (auth required pam_lastlog.so inactive=10)
# root restriction: blocking root login: chsh -s /sbin/login root ... ssh no root: PermitRootLogin no (check ssh section)

Login and password definitions : login_password_access.sh

Example: Basically module pam.d making use of login or password .so libraries: login_password_expiration_inactive.sh

Index of activities / listing script with instructions and examples:

- Setting manual password: sudo passwd username (it will use definition in /etc/login.defs)
- Changing user and password settings manually via commands: chage, usermod, passwd
- More settings for password definition extending /etc/login.defs via pam.d module service password
- Locking and account after several days of inactivity
- Locking account after several failed attempts entering password: account_locking_failedPasswd.sh
+
- Protecting services restricting to users from a file list (services: imap, pop, ssh, vsftpd ...) / protecting_services_by_user_fileList.sh
+
- Preventing root shell: (/sbin/nologin ... /etc/securetty ... ssh/sshd_config 'PermitRootLogin no' ... AllowGroups) / root_preventing_directShell.sh
+
- Preventing access to login or ssh by username, group, from IP range ... / access_sec_config_local_and_ssh.sh
- Limit maxlogins per user: access_sec_config.sh
+
- Checking last login sessions: last, lastlog (again, pam.d module loading lib) / log__lastlog_check.sh
+ account locked after inactivity of n days: /etc/pam.d/login (auth required pam_lastlog.so inactive=10)

4/ Network Services:

The ones which are not used, disable them. Specially telnet, ftp, mail ... which are insecure:
Or at least handle who can use them: protecting_services_by_user_fileList.sh

5/ FIREWALLS AND PORTS (RH)
#Ports are managed/assigned via:
/etc/services

#scan for open ports only with nmap: 
nmap -sT localhost
#scan a specific port:
nmap -p 22 localhost

# listening:
ss -ntl
# or:
lsof -i4 -N -P

#open a port in rh by using firewall-cmd:
firewall-cmd --permanent --add-port=<portnumber>/<tcp/udp>

6/ Using xinetd to manage services access control

7/

8/ When mounting a filesystem, use udev rules to just allow read-only: /etc/udev/rules.d/80-udisks.rules

Details under file: filesystem_only_read_mount.sh

+ info about mounting USB devices as read-only (same in udev rules)

9/ pam.d : this module allows many possibilities using its libraries for access, limit, or time control

Info and examples in file: login_password_access/access_sec_config_local_and_ssh.sh

It is useful for controlling who has access to login, if so, which services are restricted or not: both bin login or ssh
Limiting number of login sessions
Limiting sessions by time frame

# libraries added in:
/etc/pam.d/system-auth
/etc/pam.d/sshd

# rules under:
/etc/security/access.conf
/etc/security/limit.conf
/etc/security/time.conf

12/ 

# pam.d/sshd --> defining access, limits, and time .conf for security purposes in terms of ssh login sessions
# /etc/ssh/sshd_config --> allowing access to specific groups: AllowGroups <groupname>
# or blocking root login via ssh: PermitRootLogin no
