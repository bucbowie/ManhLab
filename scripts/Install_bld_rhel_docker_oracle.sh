#!/bin/bash
mkdir /opt/src
yum -y update && yum -y upgrade
yum -y groupinstall "GNOME Desktop"
yum -y groupinstall "Development Tools"
systemctl mask firewalld
systemctl stop firewalld
systemctl disable firewalld
setenforce 0
yum -y install vim docker tigervnc-server xorg-x11-font-Type1
groupadd oinstall
useradd -m -g oinstall -G wheel oracle
cp /lib/systemd/system/vncserver\@.service /etc/systemd/system/vncserver@:3.service
systemctl enable docker
systemctl start docker
systemctl stop docker
rm -rf /var/lib/docker
sed -i 's/DOCKER_STORAGE_OPTIONS=/DOCKER_STORAGE_OPTIONS=--storage-opt dm.basesize=32G/g' /etc/sysconfig/docker-storage
sed -i 's/<USER>/oracle/g' /etc/systemd/system/vncserver@:3.service
systemctl daemon-reload
systemctl enable /etc/systemd/system/vncserver@:3.service
systemctl start /etc/systemd/system/vncserver@:3.service
systemctl start docker
cd /opt/src
wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
sudo rpm -Uvh epel-release-latest-7*.rpm
wget ftp://195.220.108.108/linux/dag/redhat/el7/en/x86_64/dag/RPMS/flash-plugin-11.2.202.394-0.1.el7.rf.x86_64.rpm
sudo rpm -Uvh flash-plugin-11.2.202.394-0.1.el7.rf.x86_64.rpm
ln -s /usr/lib64/flash-plugin/libflashplayer.so /lib/mozilla/plugins/libflashplayer.so
echo "FROM oraclelinux" > /opt/src/Dockerfile
echo "MAINTAINER jaskew" >> /opt/src/Dockerfile
echo "RUN  yum -y --enablerepo=ol7_addons install oracle-rdbms-server-12cR1-preinstall vim bzip2 xorg-x11-xauth xeyes xhost sudo" >> /opt/src/Dockerfile
docker build -t oraol7 .
