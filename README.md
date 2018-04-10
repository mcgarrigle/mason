Mason
=====

An API driven PXE builder that _laboratory_ can use via its mason plugin to
build guests created by laboratory.

It can also function as the DNS server for guests as records are created for each node.

Typical Deployment Scenario
---------------------------

```
                            { intertubes } 10.0.40.1
                                   |
             10.0.40.2             |
  |----------+-------------+-------+------+-------|  10.0.40.0/24 (vbox natnetwork)
             |             |              |
      enp0s8 |             |              |
      +------+----+  +-----+-----+  +-----+------+
      |   mason   |  |  guest1   |  |   guest2   |
      +------+----+  +-----+-----+  +-----+------+
      enp0s3 |             |              |
             |             |              |
  |-----+----+-------------+--------------+---------|  10.0.30.0/24 (vbox hostonly)
        |    10.0.30.2
        |
   +----+---------+
   |     host     |
   |  laboratory  |
   +--------------+
```

Prereqisites
------------

* A CentOS 7 VM 
* Minimum 3G disk
* Minimum 1G RAM
* Connected via hostonly/internal interface to a subnet where the other machines will boot
* Connected via natnetwork/nat interface to the internet so you can download packages 
* A CentOS 7 minimal ISO

Installation Instructions
-------------------------

```
# git clone https://github.com:mcgarrigle/mason.git 
# cd mason
# vi configuration/dnsmasq.conf    {change DHCP range if required}
# wget http://mozart.ee.ic.ac.uk/CentOS/7/isos/x86_64/CentOS-7-x86_64-Minimal-1708.iso
# ./mason-install.sh
```

What is installed
-----------------
* DNSMASQ for TFTP and DNS
* TFTP boot environemnt is configured
* Apache HTTPD installed and the ISO unpacked for net boot
* Redis is installed as a backing store for Mason
* Dependent gems are installed
* Mason is started as a service on port 9090
* Firewalls are disabled (FIXME)

Mason API
---------

Node structure
--------------
```json
{
  "fqdn": "server.foo.local",
  "nameserver": "10.0.40.2",
  "interfaces":[
    { "mac": "080027D55CEC", "ip": "10.0.30.20", "netmask": "255.255.255.0" },
    { "mac": "080027B9B383", "ip": "10.0.40.20", "netmask": "255.255.255.0", "gateway": "10.0.40.1" }
  ]
}
```
| Name       | Description                                                        |
|------------|--------------------------------------------------------------------|
| fqdn       | Fully qualified domain name of the node - this will be this node ID|
```
GET /version
```
returns version

```
{"version":"0.0.1"}
```
POST /node



