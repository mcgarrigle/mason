#!/bin/bash

yum install -y epel-release
yum install -y vim git wget bind-utils yum tree
yum install -y dnsmasq syslinux httpd

mkdir -p /var/lib/tftpboot/images/centos/x86_64/7.4

cp /usr/share/syslinux/pxelinux.0 /var/lib/tftpboot
cp /usr/share/syslinux/menu.c32   /var/lib/tftpboot
cp /usr/share/syslinux/memdisk    /var/lib/tftpboot
cp /usr/share/syslinux/mboot.c32  /var/lib/tftpboot
cp /usr/share/syslinux/chain.c32  /var/lib/tftpboot

mount -o loop centos-gold-7.4.1708.iso /mnt/

cp /mnt/images/pxeboot/* /var/lib/tftpboot/images/centos/x86_64/7.4
cp -r /mnt /var/www/html/centos-7.4

restorecon -r /var/lib/tftpboot /var/www/html

# -------------------------------------------------------

systemctl disable firewalld
systemctl stop firewalld

systemctl start dnsmasq
systemctl enable dnsmasq

systemctl start httpd
systemctl enable httpd

# -------------------------------------------------------
# end
