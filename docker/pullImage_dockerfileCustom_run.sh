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
docker run --privileged --name container_name -it israelpg/centos_systemd

# Now we have a container for that image:
# Image:
israelpg/centos_systemd   latest              a9424d05b04a        22 minutes ago      438 MB
# Container just run:
israel@W9980173 ~/docker/centos_systemd $ docker ps -l
CONTAINER ID        IMAGE                     COMMAND             CREATED             STATUS                     PORTS               NAMES
5c032ce38e44        israelpg/centos_systemd   "/bin/bash"         21 minutes ago      Exited (0) 9 minutes ago                       tender_jepsen


### Then you can run same image instead of container_id of first runtime :

docker run --privileged --name container_name -it israelpg/centos_systemd

# Voila!!! You have another container for running that same image!
CONTAINER ID        IMAGE                     COMMAND                  CREATED             STATUS                         PORTS                   NAMES
38e0a536beed        israelpg/centos_systemd   "/bin/bash"              16 seconds ago      Exited (0) 10 seconds ago                              inspiring_poitras
5c032ce38e44        israelpg/centos_systemd   "/bin/bash"              24 minutes ago      Exited (0) 3 minutes ago                               tender_jepsen


