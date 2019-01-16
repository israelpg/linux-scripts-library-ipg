#### Backup & Recovery : Using tools and utils in package : rear

Name       : rear

Arch       : x86_64

Version    : 2.00

Release    : 1.el5

Size       : 464 k

Repo       : epel

Summary    : Relax-and-Recover is a Linux disaster recovery and system migration tool

URL        : http://relax-and-recover.org/

License    : GPLv3

Description: Relax-and-Recover is the leading Open Source disaster recovery and system

           : migration solution. It comprises of a modular

           : frame-work and ready-to-go workflows for many common situations to produce

           : a bootable image and restore from backup using this image. As a benefit,

           : it allows to restore to different hardware and can therefore be used as

           : a migration tool as well.

           :

           : Currently Relax-and-Recover supports various boot media (incl. ISO, PXE,

           : OBDR tape, USB or eSATA storage), a variety of network protocols (incl.

           : sftp, ftp, http, nfs, cifs) as well as a multitude of backup strategies

           : (incl.  IBM TSM, HP DataProtector, Symantec NetBackup, EMC NetWorker,

           : Bacula, Bareos, BORG, Duplicity, rsync).

           :

           : Relax-and-Recover was designed to be easy to set up, requires no maintenance

           : and is there to assist when disaster strikes. Its setup-and-forget nature

           : removes any excuse for not having a disaster recovery solution implemented.

           :

           : Professional services and support are available.


#### Source / Git Repo: https://github.com/rear/rear.github.com/blob/master/documentation 


yum install rear genisoimage syslinux
 
# several libraries might be missing, instead of keymaps install package kbd*

#### Operations:

# create rescue point

rear mkrescue


# To make ReaR use its internal backup method, add these lines to the /etc/rear/local.conf file:

BACKUP=NETFS

BACKUP_URL=<backup location>
# valid schemes: nfs cifs usb tape file iso sshfs ftpfs
 
# You can also configure ReaR to keep the previous backup archives when the new ones are created by adding the following line to /etc/rear/local.conf:

NETFS_KEEP_OLD_BACKUP_COPY=y
 

# To make the backups incremental, meaning that only the changed files are backed up on each run, add this line to /etc/rear/local.conf:

BACKUP_TYPE=incremental


#### an example of restore and relax backup scenario using a remote nfs folder to backup files from a server:

#Storing on a central NFS server
#The most straightforward way to store your DR images is using a central NFS server. The configuration below will store both a backup and the rescue CD in a directory on the share.
/etc/rear/local.conf

OUTPUT=ISO
BACKUP=NETFS
BACKUP_URL="nfs://192.168.122.1/nfs/rear/"

## other options instead of nfs:
# local file as long as path is pointing to another disk:
BACKUP_URL=file:///
# samba server :
BACKUP_URL=cifs://


#### for USB backup and restore:

#Recovery from USB
#Prepare your rescue media using

rear format /dev/sdX
#It will be labeled REAR-000. The /etc/rear/local.conf can be as simple as:

OUTPUT=USB
BACKUP=NETFS
BACKUP_URL="usb:///dev/disk/by-label/REAR-000"
#Run rear -v mkbackup to create the rescue media including the archive of the Operating System.
# Better use mkrescue, which integrates with other tools.

#Rescue system
#Relax-and-Recover will not automatically add itself to the Grub bootloader. It copies itself to your /boot folder.

#To enable this, add

GRUB_RESCUE=1
#to your local configuration.

#The entry in the bootloader is password protected. The default password is REAR. Change it in your own local.conf

GRUB_RESCUE_PASSWORD="SECRET"


#### integration with other backup tools:
#Backup integration
#Relax-and-Recover integrates with various backup solutions. Your backup software takes care of backing up all system files, Relax-and-Recover recreates the 
#filesystems and starts the file restore.

#Currently Bacula, Bareos, SEP Sesam, HP DataProtector, CommVault Galaxy, Symantec NetBackup, EMC NetWorker (Legato), FDR/Upstream, and IBM Tivoli Storage Manager are supported.

#The following /etc/rear/local.conf uses a USB stick for the rescue system and Bacula for backups. Multiple systems can use the USB stick since the size of the 
#rescue system is probably less than 40M. It relies on your Bacula infrastructure to restore all files.

BACKUP=BACULA
OUTPUT=USB
OUTPUT_URL="usb:///dev/disk/by-label/REAR-000"


#### monitoring backups :

#Monitoring integration
#Relax-and-Recover integrates with your monitoring. The rear checklayout command will tell you if the most recent rescue environment deviates from your storage configuration 
#(e.g. LVM changes, filesystem resized, …)

#In good Unix tradition rear checklayout returns 0 if your system is in sync with your rescue image. A return code of 1 should lead to a red light in your monitoring screen 
#because a new rescue image is needed. Create a rescue image and the next time rear checklayout runs, it will return 0 again, and your monitoring will switch to green.

#You can also automate the creation of rescue images by adding a cron job for /usr/sbin/rear checklayout || /usr/sbin/rear mkrescue. And make sure the OUTPUT_URL points to a 
#central location for storing your rescue images. By default, a rear installation via a package manager will automatically install a cron entry - see:

 # cat /etc/cron.d/rear
 30 1 * * * root /usr/sbin/rear checklayout || /usr/sbin/rear mkrescue
#Furthermore, rear will write an exit code to the /var/log/messages file which you could use to search via an integrated monitoring system (search for the rear keyword).
