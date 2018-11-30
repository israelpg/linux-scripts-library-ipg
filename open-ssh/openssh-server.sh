Package: openssh-server

# It works as a daemon: systemd service

systemctl enable sshd.service

# The sshd daemon depends on the network.target target unit, which is sufficient for static configured network interfaces and for default ListenAddress 0.0.0.0 options. 
# To specify different addresses in the ListenAddress directive and to use a slower dynamic network configuration, add dependency on the network-online.target target unit 
# to the sshd.service unit file. To achieve this, create the /etc/systemd/system/sshd.service.d/local.conf file with the following options:

  [Unit]
  Wants=network-online.target
  After=network-online.target


# After this, reload the systemd manager configuration using the following command:

systemctl daemon-reload


# Make sure client authentication is key-based instead of password:

/etc/ssh/sshd_config 
PasswordAuthentication no


# To use key-based authentication with NFS-mounted home directories, enable the use_nfs_home_dirs SELinux boolean first:

setsebool -P use_nfs_home_dirs 1


# Generate ssh key:

keygen -t rsa

# .pub key is to be copied in /etc/authorized_keys 
