FROM centos:7

MAINTAINER Israel Palomino Garcia <israelpg@gmail.com>

ENV container=docker

# if proxy is needed:
RUN echo 'proxy=http://10.198.205.226:8080' >>/etc/yum.conf

RUN yum -y --setopt=tsflags=nodocs upgrade \
    && yum -y --setopt=tsflags=nodocs install pcs which \
    && yum -y clean all

#### LABEL the image (optional --- to investigate further!)
#### RUN build with two options: a) cluster_manager container, or b) regular_node_container :
# a) manager_container binding port 2224 to localhost is just for manager's container
#LABEL RUN /usr/bin/docker run -d \$OPT1 --privileged --net=host -p 2224:2224 -v /sys/fs/cgroup:/sys/fs/cgroup -v /etc/localtime:/etc/localtime:ro -v /run/docker.sock:/run/docker.sock -v /usr/bin/docker:/usr/bin/docker:ro --name \$NAME \$IMAGE \$OPT2 \$OPT3

# b) regular node: Not binding port 2224 (notice the specification of Docker subnet and IP: Probably IP should be automated?)
#LABEL RUN /usr/bin/docker run -d \$OPT1 --privileged -v /sys/fs/cgroup:/sys/fs/cgroup -v /etc/localtime:/etc/localtime:ro -v /run/docker.sock:/run/docker.sock -v /usr/bin/docker:/usr/bin/docker:ro --ip 172.18.0.11 --net mydockernet --name \$NAME \$IMAGE \$OPT2 \$OPT3

# When running node with Tomcat, some packages to install are listed below:
# Java: JDK 1.8.0
RUN yum install -y java-1.8.0-openjdk-src

# Install wget package, and define proxy settings:
RUN yum install -y wget.x86_64
RUN echo 'http_proxy = http://10.198.205.226:8080/' >>/etc/wgetrc

# Tomcat installation: https://tecadmin.net/steps-to-install-tomcat-server-on-centos-rhel/
COPY resources/tomcat_users.xml /tmp

WORKDIR /tmp
RUN wget -O tomcat7.tar.gz http://www-us.apache.org/dist/tomcat/tomcat-7/v7.0.92/bin/apache-tomcat-7.0.92.tar.gz \
    && tar -xvf tomcat7.tar.gz -C /usr/local/ \
    && rm tomcat7.tar.gz

WORKDIR /usr/local/apache-tomcat-7.0.92
RUN mv /tmp/tomcat_users.xml . \
	&& chown root:root tomcat_users.xml

# start Tomcat:
ENTRYPOINT ["/bin/bash", "-c", "./bin/startup.sh"]

# systemd enable pcsd service:
RUN mkdir -p /etc/systemd/system-preset/
RUN echo 'enable pcsd.service' > /etc/systemd/system-preset/00-pcsd.preset
RUN systemctl enable pcsd

EXPOSE 2224

CMD ["/usr/lib/systemd/systemd", "--system"]
