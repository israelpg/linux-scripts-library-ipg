# Source: https://docs.fedoraproject.org/en-US/quick-docs/dnf-system-upgrade/

# 1) Update Current Release:

sudo dnf upgrade --refresh

# 2) Install the dnf-plugin-system-upgrade package if it is not currently installed:

sudo dnf install dnf-plugin-system-upgrade


# 3) Download the updated packages:

sudo dnf system-upgrade download --refresh --releasever=33

# 4) Adding Key

sudo rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-fedora-34-primary

# 5) Trigger the upgrade process

sudo dnf system-upgrade reboot

