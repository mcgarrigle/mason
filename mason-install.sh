#!/bin/bash

yum install -y epel-release
yum install -y vim git ruby wget uind-utils yum tree
yum install -y dnsmasq syslinux httpd redis

cp configuration/dnsmasq.conf /etc/dnsmasq.conf

mkdir -p /var/lib/tftpboot/pxelinux.cfg

cp configuration/{default,template} /var/lib/tftpboot/pxelinux.cfg

cp /usr/share/syslinux/pxelinux.0 /var/lib/tftpboot
cp /usr/share/syslinux/menu.c32   /var/lib/tftpboot
cp /usr/share/syslinux/memdisk    /var/lib/tftpboot
cp /usr/share/syslinux/mboot.c32  /var/lib/tftpboot
cp /usr/share/syslinux/chain.c32  /var/lib/tftpboot

mount -o loop *.iso /mnt/

mkdir -p /var/lib/tftpboot/centos/x86_64/7.4
cp /mnt/images/pxeboot/* /var/lib/tftpboot/centos/x86_64/7.4

mkdir -p /var/www/html/centos
cp -r /mnt/ /var/www/html/centos/7.4/

restorecon -r /var/lib/tftpboot /var/www/html

cp configuration/mason.service /lib/systemd/system

# -------------------------------------------------------

gem install bundler
bundle install

# -------------------------------------------------------

systemctl stop firewalld
systemctl disable firewalld

systemctl start dnsmasq
systemctl enable dnsmasq

systemctl start httpd
systemctl enable httpd

systemctl start redis
systemctl enable redis

systemctl start mason
systemctl enable mason

systemctl stop firewalld
systemctl disable firewalld

# -------------------------------------------------------
# end
