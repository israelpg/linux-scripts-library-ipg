# Source: https://docs.fedoraproject.org/en-US/quick-docs/dnf-system-upgrade/

# 1) Update Current Release:

sudo dnf upgrade --refresh

# 2) Install the dnf-plugin-system-upgrade package if it is not currently installed:

sudo dnf install dnf-plugin-system-upgrade


# 3) Download the updated packages:

sudo dnf system-upgrade download --refresh --releasever=33
