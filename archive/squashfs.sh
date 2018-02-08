# for filesystems, high compression using squashfs

sudo mksquashfs /etc test.squashfs

# created in parallel by multiple core processors

# Then we need to mount it so that system uses when needed without decompr:

mkdir /mnt/squash

sudo mount -o loop test.squashfs /mnt/squash

# if we need to skip files when creating the squashfs file:

sudo mksquashfs /etc test2.squashfs -ef excludelist
# excludelist is a file containing the filenames to be excluded
