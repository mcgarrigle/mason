
url --url http://{{mason.address}}/centos/7.4

install 

lang en
keyboard uk
skipx

network --hostname={{fqdn}}
network --device={{interfaces.0.mac}} --noipv6 --bootproto=static --ip={{interfaces.0.ip}} --netmask={{interfaces.0.netmask}}
network --device={{interfaces.1.mac}} --noipv6 --bootproto=static --ip={{interfaces.1.ip}} --netmask={{interfaces.1.netmask}} --gateway={{interfaces.1.gateway}} --nameserver={{nameserver}}

authconfig --useshadow --passalgo=sha256 --kickstart

rootpw "letmein"
user --name=rescue --plaintext --password letmein

timezone --utc UTC

bootloader --location=mbr --append="nofb quiet splash=quiet" 

zerombr
clearpart --all

part /boot --size=1024 --ondisk=sda
part pv.01 --size=1    --ondisk=sda --grow

volgroup linux pv.01

logvol /              --fstype=xfs --name=root          --vgname=linux --size=10240
logvol /home          --fstype=xfs --name=home          --vgname=linux --size=5120
logvol /tmp           --fstype=xfs --name=tmp           --vgname=linux --size=5120
logvol /opt           --fstype=xfs --name=opt           --vgname=linux --size=2048
logvol /var           --fstype=xfs --name=var           --vgname=linux --size=2048 --grow
logvol /var/log       --fstype=xfs --name=var_log       --vgname=linux --size=10240
logvol /var/log/audit --fstype=xfs --name=var_log_audit --vgname=linux --size=1024

text
reboot --eject

%packages --ignoremissing
yum
yum-utils
dhclient
wget
curl
vim
git
@Core
%end

%post --log=/root/kickstart-post.log
  echo "UseDNS no" >> /etc/ssh/sshd_config
  echo "{{interfaces.1.ip}} {{fqdn}}" >> /etc/hosts
  echo "rescue ALL=(root) ALL" >> /etc/sudoers.d/rescue
%end
