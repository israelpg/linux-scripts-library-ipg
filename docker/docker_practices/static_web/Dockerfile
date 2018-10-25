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
