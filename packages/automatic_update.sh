#!/bin/bash

# Install unattended-upgrades package to automate updates and upgrades (with downloads as well):

sudo apt-get install unattended-upgrades

# To configure unattended upgrades, edit /etc/apt/apt.conf.d/50unattended-upgrades : specify sources : 

Unattended-Upgrade::Allowed-Origins {
	"Ubuntu xenial-security";
	"Ubuntu xenial-updates";
};

# This packages won't be automatically updated / Blacklist:

Unattended-Upgrade::Package-Blacklist {
//	"vim";
//	"libc6";
//	"libc6-dev";
//	"libc6-i686";
};

# To enable automatic updates, edit: /etc/apt/apt.conf.d/10periodic :

APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Download-Upgradeable-Packages "1";
APT::Periodic::AutocleanInterval "7";
APT::Periodic::Unattended-Upgrade "1";

# more about apt Periodic configuration options in: /etc/cron.daily/apt script header
