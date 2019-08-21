# Install Docker in OpenSuse:

sudo zypper install docker


# Daemon:

systemctl start docker.service


# Check info about docker and host:

docker info


# Add regular user to docker group in Linux:

sudo usermod -a -G docker israel


# IMAGES AVAILABLE ON DOCKER HUB:

# http://hub.docker.com


# To run a specific image, e.g.: Ubuntu

docker run -i -t ubuntu /bin/bash

# (-i for allowing stdin in the container, and -t for assigning a tty)


# To get out of the bash execution of the ubuntu image:

exit

# In the command below we also create a volume:
docker run -it --name ubuntu-test-3 -v /onefolder/onesubfolder ubuntu:latest /bin/bash

# Here another container based on same ubuntu:latest version image
# The volume is now labelled >>> ubuntu-test-4-volume ... this is done by using separator : >>> origin(local):destination_folder
docker run -it --name ubuntu-test-4 -v ubuntu-test-4-volume:/onefolder/onesubfolder ubuntu:latest /bin/bash

docker ps -l
bdc6427876d8        ubuntu:latest                "/bin/bash"              21 seconds ago      Up 8 seconds                                    ubuntu-test-4

docker volume ls
local               ubuntu-test-4-volume
# inside the container:
root@bdc6427876d8:/# ls
bin  boot  dev  etc  home  lib  lib64  media  mnt  onefolder  opt  proc  root  run  sbin  srv  sys  tmp  usr  var


# checking containers:

israel@linux-c4nt:~> sudo docker ps -a
[sudo] password for root: 
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS                      PORTS               NAMES
b4082730a567        ubuntu              "/bin/bash"         9 minutes ago       Exited (0) 12 seconds ago                       jovial_jang

# for listing the last running docker container:

sudo docker ps -l


# With the container id we can start the container:

sudo docker start b4082730a567

# and get in the container with:

sudo docker attach b4082730a567


# Execute a command in a container:
# Or directly use docker exec -it <container name> <command> to execute whatever command you specify in the container.


# Running a daemonized container: Ideal for running web app

sudo docker run --name daemon_ubuntu_background_appServer -d ubuntu /bin/sh -c "while true; do echo Hello World; sleep 3; done"

# You can check logs:

sudo docker logs -f daemon_ubuntu_background_appServer
# or using ID:
sudo docker logs -f jd9834kj98cx9xc8

# or inspecting the running processes for our background daemonized container:

israel@linux-c4nt:~> sudo docker top f83eaa18276d
UID                 PID                 PPID                C                   STIME               TTY                 TIME                CMD
root                22908               22891               0                   14:30               ?                   00:00:00            /bin/sh -c while true; do echo Hello World; sleep 3; done
root                23540               22908               0                   14:45               ?                   00:00:00            sleep 3


## Using format to complement or filter inspect:

# Rationale: When listing with inspect a container, you see a tree, just refer to the hierarchy.element you want to inspect

# inspect two containers at the same time, returning results for running status:

linux-c4nt:~ # docker inspect --format '{{ .Name}} {{.State.Running}}' daemon_ubuntu_background_appServer jovial_jang
/daemon_ubuntu_background_appServer true
/jovial_jang false

# Other inspect --format possibilities:

linux-c4nt:~ # docker inspect --format '{{ .NetworkSettings.IPAddress }}' daemon_ubuntu_background_appServer
172.17.0.2



# Deleting a container:

docker rm docker_id


# IMAGES:

docker images
	
# images are stored under: /var/lib/docker/<image_name>

# Search for a specific image, and pull image:

docker search fedora

NAME                                 DESCRIPTION                                     STARS               OFFICIAL            AUTOMATED
fedora                               Official Docker builds of Fedora                714                 [OK]                
fedora/apache                                                                        35                                      [OK]
mattsch/fedora-nzbhydra              Fedora NZBHydra                                 5                                       [OK]
..
..

docker pull fedora

# Now you can run the image:

docker run -i -t --name fedora_latest fedora:latest /bin/bash


# Login to Docker Hub via command shell:

linux-c4nt:/home/israel/Documents/docker_practices # docker login
Login with your Docker ID to push and pull images from Docker Hub. If you don't have a Docker ID, head over to https://hub.docker.com to create one.
Username: israelpg
Password: 
Login Succeeded

# Creating a custom image:
# First you run a container, e.g.: ubuntu:latest (and install apache2)

docker run -i -t ubuntu:latest "/bin/bash"

root@879a95dcfd62:/# apt-get -y install apache2
root@879a95dcfd62:/# apt-get -yqq update
docker commit 1d373556d1fb pepe/pepe_ubuntu_1604

# Then you commit changes as a new custom image with its repo/image_name: You must point to the new image 879... and repo israelpg, image name whatever you want:

linux-c4nt:/home/israel/Documents/docker_practices # docker commit -m="A new custom image: ubuntu with apache2" --author="israelpg" 879a95dcfd62 israelpg/cust-ubuntu-apache2
sha256:99cdbf9c2f2a7f98c8bbcbf30d5b120afdda241676a15e710258a1d8bf55b74c

linux-c4nt:/home/israel/Documents/docker_practices # docker images
REPOSITORY                     TAG                 IMAGE ID            CREATED             SIZE
israelpg/cust-ubuntu-apache2   latest              99cdbf9c2f2a        54 seconds ago      223MB
...


### There is a better approach for customizing and getting an image:
# tag and build using a Dockerfile

israel@linux-c4nt:~/Documents/docker_practices/static_web> cat Dockerfile 
# Version: 0.0.1
FROM ubuntu:16.04
MAINTAINER Israel Garcia "israelpg@gmail.com"
RUN echo 'Acquire::http::proxy "http://10.198.205.226:8080";' >>/etc/apt/apt.conf
RUN echo 'Acquire::https::proxy "https://10.198.205.226:8080";' >>/etc/apt/apt.conf
RUN echo 'Acquire::ftp::proxy "ftp://10.198.205.226:8080";' >>/etc/apt/apt.conf
RUN apt-get update
RUN apt-get install -y nginx
RUN echo 'Hi, I am in your container' >/usr/share/nginx/html/index.html
EXPOSE 80

sudo docker build -t="israelpg/static_web" .

# israelpg is the repo name, static_web the image name ... filename is always Dockerfile

# TIP: If there is an error building the image, you can try to run the image, execute instructions, and see the error, once fixed, try to build again the customized image

## history

# note that image id changes with each instruction execution of the Dockerfile:

$ sudo docker images

REPOSITORY                     TAG                 IMAGE ID            CREATED             SIZE
israelpg/static_web            latest              75a42f0431a5        8 minutes ago       213MB
israelpg/cust-ubuntu-apache2   latest              99cdbf9c2f2a        2 weeks ago         223MB
fedora                         latest              c582c1438f27        6 weeks ago         254MB
ubuntu                         16.04               b9e15a5d1e1a        6 weeks ago         115MB
ubuntu                         latest              cd6d8154f1e1        6 weeks ago         84.1MB

$ sudo docker history 75a42f0431a5

# or using image name: docker history israelpg/static_web

IMAGE               CREATED             CREATED BY                                      SIZE                COMMENT
75a42f0431a5        8 minutes ago       /bin/sh -c #(nop)  EXPOSE 80/tcp                0B                  
7e91eeef15c9        8 minutes ago       /bin/sh -c echo 'Hi, I am in your containe...   27B                 
f852523e3a83        9 minutes ago       /bin/sh -c apt-get install -y nginx             56.5MB              
548fa9f1b52b        9 minutes ago       /bin/sh -c apt-get update                       41MB                
8c5a64d9089d        9 minutes ago       /bin/sh -c #(nop)  MAINTAINER Israel Garci...   0B                  
b9e15a5d1e1a        6 weeks ago         /bin/sh -c #(nop)  CMD ["/bin/bash"]            0B                  
<missing>           6 weeks ago         /bin/sh -c mkdir -p /run/systemd && echo '...   7B                  
<missing>           6 weeks ago         /bin/sh -c sed -i 's/^#\s*\(deb.*universe\...   2.76kB              
<missing>           6 weeks ago         /bin/sh -c rm -rf /var/lib/apt/lists/*          0B                  
<missing>           6 weeks ago         /bin/sh -c set -xe   && echo '#!/bin/sh' >...   745B                
<missing>           6 weeks ago         /bin/sh -c #(nop) ADD file:a83ab1826f43e88...   115MB

# Launching a Container from the image we just created using the Dockerfile to customize passing instructions:

docker run -d -p 80 --name static_web israelpg/static_web nginx -g "daemon off;"

de74cc47e5c2762d8984875849f3dccc3e8b724818cf55eb4bc58f4714dc43d7

docker ps -l

CONTAINER ID        IMAGE                 COMMAND                  CREATED             STATUS              PORTS                   NAMES
de74cc47e5c2        israelpg/static_web   "nginx -g 'daemon ..."   5 seconds ago       Up 4 seconds        0.0.0.0:32768->80/tcp   static_web

# binding to another port: In the example below, instead of 80 it will use 8080

$ sudo docker run -d- p 8080:80 --name static_web jamtur01/static_web nginx -g "daemon off;"

# binding to a specific interface:

$ sudo docker run -d -p 127.0.0.1:80:80 --name static_webjamtur01/static_web nginx -g "daemon off;"

# in case we don't need the build cache, meaning it won't check all steps to see whether are to be executed or not for applying changes, faster mode:
# for instance, avoiding the apt-get update:

$ sudo docker build --no-cache -t="israelpg/static_web" .

# Using the build cache for templating:
# env var with date of last refresh for containers created with image for Ubuntu using Dockerfile
FROM ubuntu:14.04
MAINTAINER James Turnbull "james@example.com"
ENV REFRESHED_AT 2014-07-01
RUN apt-get -qq update

# same but for Fedora:
FROM fedora:20
MAINTAINER James Turnbull "james@example.com"
ENV REFRESHED_AT 2014-07-01
RUN yum -y -q upgrade

##### running a container which will be created by using an image fedora with the nginx installed:

israel@W9980173 ~/git/workspace_linux_scripts/docker/docker_practices/static_web $ sudo docker images

REPOSITORY            TAG                 IMAGE ID            CREATED             SIZE
israelpg/static_web   latest              8d3b59359007        30 hours ago        197 MB
<none>                <none>              60c20ad5a0bf        30 hours ago        116 MB
<none>                <none>              5db9f4254b9e        30 hours ago        116 MB
ubuntu                16.04               4a689991aa24        6 days ago          116 MB
nginx                 latest              dbfc48660aeb        9 days ago          109 MB
fedora                latest              c582c1438f27        6 weeks ago         254 MB

israel@W9980173 ~/git/workspace_linux_scripts/docker/docker_practices/static_web $ sudo docker ps -a

CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS                     PORTS               NAMES
e41a738dcae0        fedora              "/bin/bash"         30 hours ago        Exited (1) 8 minutes ago                       brave_hamilton
israel@W9980173 ~/git/workspace_linux_scripts/docker/docker_practices/static_web $ sudo docker run -d -P --name fedora_nginx israelpg/static_web nginx -g "daemon off;"
7d226ed84dc93668474eb8030946c96465e68dc9ec991027ac7cb79dd4eac117

israel@W9980173 ~/git/workspace_linux_scripts/docker/docker_practices/static_web $ sudo docker ps -l
CONTAINER ID        IMAGE                 COMMAND                  CREATED             STATUS              PORTS                   NAMES
7d226ed84dc9        israelpg/static_web   "nginx -g 'daemon ..."   6 seconds ago       Up 5 seconds        0.0.0.0:32768->80/tcp   fedora_nginx


#### For checking how to execute several containers for the same image, the example in file:


pullImage_dockerfileCustom_run.sh

# content below:


#Pull image:

docker pull centos/systemd

#First create a Dockerfile and setup the required service or services. Systemd can launch multiple services.

FROM centos/systemd

MAINTAINER "Your Name" <you@example.com>

RUN yum -y install httpd; yum clean all; systemctl enable httpd.service

EXPOSE 80

CMD ["/usr/sbin/init"]


#Then build it.

docker build --rm --no-cache -t httpd .

# IPG: -t to tag the image with a specified name:
sudo docker build --rm --no-cache -t israelpg/centos_systemd .


#Launch it.

docker run --privileged --name httpd-container -v /sys/fs/cgroup:/sys/fs/cgroup:ro -p 80:80 -d  httpd

# IPG:
docker run --name centos_containerAB --privileged -it israelpg/centos_systemd

# Now we have a container for that image:
# Image:
israelpg/centos_systemd   latest              a9424d05b04a        22 minutes ago      438 MB
# Container just run:
israel@W9980173 ~/docker/centos_systemd $ docker ps -l
CONTAINER ID        IMAGE                     COMMAND             CREATED             STATUS                     PORTS               NAMES
5c032ce38e44        israelpg/centos_systemd   "/bin/bash"         21 minutes ago      Exited (0) 9 minutes ago                       tender_jepsen


### Then you can run same image instead of container_id of first runtime :

docker run --name centos_container1 --privileged -it israelpg/centos_systemd

# Voila!!! You have another container for running that same image!
CONTAINER ID        IMAGE                     COMMAND                  CREATED             STATUS                         PORTS                   NAMES
38e0a536beed        israelpg/centos_systemd   "/bin/bash"              16 seconds ago      Exited (0) 10 seconds ago                              inspiring_poitras
5c032ce38e44        israelpg/centos_systemd   "/bin/bash"              24 minutes ago      Exited (0) 3 minutes ago                               tender_jepsen



