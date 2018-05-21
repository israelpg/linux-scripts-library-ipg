#!/bin/bash

# chroot a folder to execute commands as root, but in an isolate environment (although you need sudo to exec)

# 1. You can do everything manually, or check my automated script: ldd_automation.sh

# 2. A file structure needs to be created with the following characteristics:
#    Folders: <chroot_folder>, bin, etc, lib, lib64
#    So that we store the binaries that will be executed, the bash.bashrc to execute commands in bash env, and lib folders

# 3. You can copy the binaries, then create the bash.bashrc with: 
#    $ echo "PS1='JAIL $ '" | sudo tee /bashjail/etc/bash.bashrc
#    and then, copy the dependency libraries for each bin: ldd <binary>

# 4. Then execute:
#    sudo chroot <chroot_folder>

# 5. Environment bash is available with prompt:
#    JAIL $
