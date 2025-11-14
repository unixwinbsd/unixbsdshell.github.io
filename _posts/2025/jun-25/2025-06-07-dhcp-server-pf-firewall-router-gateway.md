---
title: Installing FreeBSD DHCP Server with PF Filter Firewall for Firewall Gateway Router
date: "2025-06-07 07:01:05 +0100"
updated: "2025-06-07 07:01:05 +0100"
id: dhcp-server-pf-firewall-router-gateway
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: DNSServer
background: https://gitflic.ru/project/unixbsdshell/ruby-static-page-jekyll-rb-openbsd/blob/raw?file=assets%2Fimages%2F25freebsd%20dhcp%20server.jpg&commit=68a9483f87b246f236bede2dd9a7a3a9418ac94c
toc: true
comments: true
published: true
excerpt: DHCP (Dynamic Host Configuration Protocol) provides automatic and static networks on client computers to obtain the configuration parameters needed to communicate with other systems in an IP (Internet Protocol)-based network. Parameters that are usually provided by a DHCP server include the assignment of IP addresses, DNS server addresses, and router addresses or default gateways.
keywords: router, gateway, firewall, dhcp, server, install, filter, pf, packet firewall, freebsd, dhcp server, dhcpd
---

DHCP (Dynamic Host Configuration Protocol) provides automatic and static networks on client computers to obtain the configuration parameters needed to communicate with other systems in an IP (Internet Protocol)-based network. Parameters that are usually provided by a DHCP server include the assignment of IP addresses, DNS server addresses, and router addresses or default gateways.

When a client computer first connects to the internet using a DHCP Server, the DHCP server immediately broadcasts a request to the local network for configuration information. The DHCP Server then answers this request with the parameters specified in the DHCP server configuration. The client computer directly applies the configuration specified by the DHCP Server to the network interface to communicate with other networks in one IP Address subnet.

DHCP servers generally assign IP addresses in one of two ways, static or dynamic. The static method allocates IP addresses to clients based on the client's hardware MAC address. This IP address will remain unchanged. Meanwhile, dynamic IP addresses are rented addresses, there is a time when the lease expires. The DHCP server assigns IP addresses from a pool or range defined by the administrator. The dynamic IP will be returned to the pool when the client disconnects from the network. If the same client rejoins the network, it may be assigned a different IP address if the previously assigned address is not available.

DHCP first appeared in October 1993 as a replacement for BOOTP (Bootstrap Protocol). Version 1 of the ISC-DHCP server was released by Ted Lemon in December 1997. The ISC-DHCP implementation remains one of the most popular and powerful open source DHCP solutions.

<br/>
![freebsd dhcp server router gateway](https://gitflic.ru/project/unixbsdshell/ruby-static-page-jekyll-rb-openbsd/blob/raw?file=assets%2Fimages%2F25freebsd%20dhcp%20server.jpg&commit=68a9483f87b246f236bede2dd9a7a3a9418ac94c)
<br/>


## 1. System Specifications:

- OS: FreeBSD 13.2 Stable
- CPU: AMD Phenom(tm) II X4 955 Processor
- IP Land Card (on board) nfe0: 192.168.5.2 (WAN)
- IP Land Card vr0: 192.168.7.1 (For LAN, private network)
- Hostname: ns1
- Domain: unixexplore.com
- Versi DHCP Server: isc-dhcp44-server-4.4.3P1


## 2. ISC-DHCP Server Installation

On FreeBSD systems ISC DHCP Server can be installed via the Ports system or with the pkg package. In this article we will explain how to install the ISC DHCP Server using the pkg package. The first thing you have to do is update the pkg package.

```console
root@ns1:~ # pkg update -f
root@ns1:~ # pkg upgrade -f
```
The update function above is to get the latest version of the DHCP Server application. After that, type the command below to install the DHCP Server.

```console
root@ns1:~ # pkg install isc-dhcp44-client
root@ns1:~ # pkg install isc-dhcp44-relay
root@ns1:~ # pkg delete isc-dhcp44-server
Checking integrity... done (0 conflicting)
Deinstallation has been requested for the following 1 packages (of 0 packages in the universe):

Installed packages to be REMOVED:
	isc-dhcp44-server: 4.4.3P1

==> You should manually remove the "dhcpd" user. 
==> You should manually remove the "dhcpd" group 
You may need to manually remove /usr/local/etc/dhcpd.conf if it is no longer needed.
root@ns1:~ # pkg install isc-dhcp44-server
Updating FreeBSD repository catalogue...
FreeBSD repository is up to date.
All repositories are up to date.
Checking integrity... done (0 conflicting)
The following 1 package(s) will be affected (of 0 checked):

New packages to be INSTALLED:
	isc-dhcp44-server: 4.4.3P1

Number of packages to be installed: 1

The process will require 7 MiB more space.

Proceed with this action? [y/N]: y
[1/1] Installing isc-dhcp44-server-4.4.3P1...
===> Creating groups.
Using existing group 'dhcpd'.
===> Creating users
Using existing user 'dhcpd'.
[1/1] Extracting isc-dhcp44-server-4.4.3P1: 100%
=====
Message from isc-dhcp44-server-4.4.3P1:

--
****  To setup dhcpd, please edit /usr/local/etc/dhcpd.conf.

****  This port installs the dhcp daemon, but doesn't invoke dhcpd by default.
      If you want to invoke dhcpd at startup, add these lines to /etc/rc.conf:

	    dhcpd_enable="YES"				# dhcpd enabled?
	    dhcpd_flags="-q"				# command option(s)
	    dhcpd_conf="/usr/local/etc/dhcpd.conf"	# configuration file
	    dhcpd_ifaces=""				# ethernet interface(s)
	    dhcpd_withumask="022"			# file creation mask

****  If compiled with paranoia support (the default), the following rc.conf
      options are also supported:

	    dhcpd_chuser_enable="YES"		# runs w/o privileges?
	    dhcpd_withuser="dhcpd"		# user name to run as
	    dhcpd_withgroup="dhcpd"		# group name to run as
	    dhcpd_chroot_enable="YES"		# runs chrooted?
	    dhcpd_devfs_enable="YES"		# use devfs if available?
	    dhcpd_rootdir="/var/db/dhcpd"	# directory to run in
	    dhcpd_includedir="<some_dir>"	# directory with config-
						  files to include

****  WARNING: never edit the chrooted or jailed dhcpd.conf file but
      /usr/local/etc/dhcpd.conf instead which is always copied where
      needed upon startup.
```
When you have finished installing the DHCP Server, an article will appear containing recommendations for configuring the DHCP Server. We will use these recommendations as a benchmark for configuring the DHCP server.


## 3. ISC-DHCP Server Configuration

Once the installation is complete, continue with configuring the DHCP Server. The first step that must be taken is to create an rc.d script, so that the DHCP server can be booted automatically when the computer is restarted/rebooted. Add the script below to the `/etc/rc.conf` file.

```console
root@ns1:~ # ee /etc/rc.conf
hostname="ns1"
ifconfig_nfe0="inet 192.168.5.2 netmask 255.255.255.0"
ifconfig_vr0="inet 192.168.7.1 netmask 255.255.255.0"
defaultrouter="192.168.5.1"
gateway_enable="YES"

dhcpd_enable="YES"
#dhcpd_flags="-q -early_chroot"
dhcpd_conf="/usr/local/etc/dhcpd.conf"
#dhcpd_ifaces="rl0"
dhcpd_withumask="022"
#dhcpd_chuser_enable="YES"
dhcpd_withuser="dhcpd"
dhcpd_withgroup="dhcpd"
#dhcpd_chroot_enable="YES"
dhcpd_devfs_enable="YES"
dhcpd_rootdir="/var/db/dhcpd"
```
The main configuration file is `dhcpd.conf`, from the script above it is clear that the file is located at `/usr/local/etc/dhcpd.conf`. Edit the `/usr/local/etc/dhcpd.conf` file, as in the example below.

```console
root@ns1:~ # ee /usr/local/etc/dhcpd.conf
# dhcpd.conf
#
# Sample configuration file for ISC dhcpd
#

# option definitions common to all supported networks...
option domain-name "unixexplore.com";
option domain-name-servers 1.1.1.1, 1.0.0.1, 8.8.8.8;
option domain-search-list code 119 = text;
option arch code 93 = unsigned integer 16;
option ldap-server code 95 = text;

default-lease-time 600;
max-lease-time 7200;

# Use this to enble / disable dynamic dns updates globally.
#ddns-update-style none;

# If this DHCP server is the official DHCP server for the local
# network, the authoritative directive should be uncommented.
authoritative;
one-lease-per-client true;
deny duplicates;
update-conflict-detection false;

# Use this to send dhcp log messages to a different log file (you also
# have to hack syslog.conf to complete the redirection).
log-facility local7;

# No service will be given on this subnet, but declaring it helps the 
# DHCP server to understand the network topology.

subnet 192.168.5.0 netmask 255.255.255.0 {
}

# This is a very basic subnet declaration.

subnet 192.168.7.0 netmask 255.255.255.0 {
        range 192.168.7.2 192.168.7.250;
        option routers 192.168.7.1;
		option broadcast-address 192.168.7.255;
		option domain-name "unixexplore.com";
		option domain-search "ns1.unixexplore.com";
        option domain-name-servers 1.1.1.1, 1.0.0.1, 9.9.9.9;
}

# This declaration allows BOOTP clients to get dynamic addresses,
# which we don't really recommend.

#subnet 10.254.239.32 netmask 255.255.255.224 {
#  range dynamic-bootp 10.254.239.40 10.254.239.60;
#  option broadcast-address 10.254.239.31;
#  option routers rtr-239-32-1.example.org;
#}

# A slightly different configuration for an internal subnet.
#subnet 10.5.5.0 netmask 255.255.255.224 {
#  range 10.5.5.26 10.5.5.30;
#  option domain-name-servers ns1.internal.example.org;
#  option domain-name "internal.example.org";
#  option routers 10.5.5.1;
#  option broadcast-address 10.5.5.31;
#  default-lease-time 600;
#  max-lease-time 7200;
#}

# Hosts which require special configuration options can be listed in
# host statements.   If no address is specified, the address will be
# allocated dynamically (if possible), but the host-specific information
# will still come from the host declaration.

#host passacaglia {
#  hardware ethernet 0:0:c0:5d:bd:95;
#  filename "vmunix.passacaglia";
#  server-name "toccata.example.com";
#}

# Fixed IP addresses can also be specified for hosts.   These addresses
# should not also be listed as being available for dynamic assignment.
# Hosts for which fixed IP addresses have been specified can boot using
# BOOTP or DHCP.   Hosts for which no fixed address is specified can only
# be booted with DHCP, unless there is an address range on the subnet
# to which a BOOTP client is connected which has the dynamic-bootp flag
# set.
#host fantasia {
#  hardware ethernet 08:00:07:26:c0:a5;
#  fixed-address fantasia.example.com;
#}

# You can declare a class of clients and then do address allocation
# based on that.   The example below shows a case where all clients
# in a certain class get addresses on the 10.17.224/24 subnet, and all
# other clients get addresses on the 10.0.29/24 subnet.

#class "foo" {
#  match if substring (option vendor-class-identifier, 0, 4) = "SUNW";
#}

#shared-network 224-29 {
#  subnet 10.17.224.0 netmask 255.255.255.0 {
#    option routers rtr-224.example.org;
#  }
#  subnet 10.0.29.0 netmask 255.255.255.0 {
#    option routers rtr-29.example.org;
#  }
#  pool {
#    allow members of "foo";
#    range 10.17.224.10 10.17.224.250;
#  }
#  pool {
#    deny members of "foo";
#    range 10.0.29.10 10.0.29.230;
#  }
#}
```
What you need to pay attention to when editing the dhcpd.conf file is the IP address for the LAN or local/private network. In the dhcpd.conf script above the IP for the LAN is in the subnet `192.168.7.0` netmask `255.255.255.0` with the range `192.168.7.2 192.168.7.250`. When the dhcpd.conf file configuration has been completed, it is time to test the DHCP server, whether it is RUNNING or not.

Next, create a log file, this file is useful for controlling DHCP server activity. With a log file, monitoring can be done at any time and when needed. Enter the following script in the `/etc/syslog.conf` and `/etc/newsyslog.conf` files.

```console
root@ns1:~ # ee /etc/syslog.conf
local7.*					/var/log/dhcpd.log
root@ns1:~ # ee /etc/newsyslog.conf
/var/log/dhcpd.log                      600  7     *    @T00  JC
```
Create a log file in the `/var/log` folder.

```console
root@ns1:~ # touch /var/log/dhcpd.log
```
If a log file has been created, provide file ownership rights and permissions.

```console
root@ns1:~ # chown -R dhcpd:dhcpd /var/db/dhcpd/
root@ns1:~ # chown -R dhcpd:dhcpd /var/log/dhcpd.log
```


## 4. Packet File (PF) Firewall configuration

If you haven't missed any steps to configure the ISC-DHCP Server, continue by configuring the Firewall Packet Filter. This firewall is used to regulate incoming and outgoing traffic, which ones must pass through and which ones must be blocked. Before creating Packet Filter rules, first activate the PF Firewall kernel module. In the file `/usr/src/sys/amd64/conf/GENERIC`, type the following script and place it at the bottom of the `GENERIC` file.

```console
root@ns1:~ # ee /usr/src/sys/amd64/conf/GENERIC
options         ALTQ
options         ALTQ_CBQ
options         ALTQ_RED
options         ALTQ_RIO
options         ALTQ_HFSC
options         ALTQ_PRIQ
device	    pf
device	    pflog
device	    pfsync
```
Build and install the file `/usr/src/sys/amd64/conf/GENERIC` which has been included in the kernel Packet Filter module.

```console
root@ns1:~ # cd /usr/src
root@ns1:/usr/src # make buildkernel KERNCONF=GENERIC
root@ns1:/usr/src # make installkernel KERNCONF=GENERIC
```
The process is a bit long, wait until the build and install `GENERIC` kernel process is complete. After that, continue by creating Packet Filter Firewall rules. In the `/etc/rc.conf` file, add the following script to automatically boot PF Firewall.

```console
root@ns1:~ # ee /etc/rc.conf
pf_enable="YES" # Enable PF (load module if required)
pf_rules="/etc/pf.conf"
pf_flags="" # additional flags for pfctl startup
pflog_enable="YES" # start pflogd(8)
pflog_logfile="/var/log/pflog" # where pflogd should store the logfile
pflog_flags="" # additional flags for pflogd startup
pflogd_enable="YES"
pfsync_enable="YES"
```
Create a file `/etc/pf.conf` and enter the script below.

```console
root@ns1:~ # touch /etc/pf.conf
root@ns1:~ # ee /etc/pf.conf
set limit table-entries 400000
set optimization normal
set limit states 198000
set limit src-nodes 198000

#System aliases
loopback = "{ lo0 }"
WANINDIHOME = "{ nfe0 }"
LANWIFI = "{ vr0 }"

#table <bogons> persist file "/etc/bogons"

# Gateways
GWWANINDIHOMEGW = " route-to ( nfe0 192.168.5.1 ) "
GWLANWIFIGW = " route-to ( vr0 192.168.7.1 ) "

set block-policy return
set loginterface vr0
set keepcounters
set skip on pfsync0
set skip on lo0
set skip on $LANWIFI

scrub on $WANINDIHOME inet all fragment reassemble
scrub on $LANWIFI inet all fragment reassemble

#no nat proto carp
#no rdr proto carp
#nat-anchor "natearly/*"
#nat-anchor "natrules/*"

# Outbound NAT rules (manual)
nat on $WANINDIHOME inet from 127.0.0.0/8 to any port 500 -> 192.168.5.2/32 static-port # Auto created rule for ISAKMP - localhost to WAN
nat on $WANINDIHOME inet from 127.0.0.0/8 to any -> 192.168.5.2/32 port 1024:65535 # Auto created rule - localhost to WAN
nat on $WANINDIHOME inet from 192.168.7.0/24 to any port 500 -> 192.168.5.2/32 static-port # Auto created rule for ISAKMP - localhost to LAN
nat on $WANINDIHOME inet from 192.168.7.0/24 to any -> 192.168.5.2/32 port 1024:65535 # Auto created rule - localhost to LAN
nat on $WANINDIHOME inet from 192.168.5.0/24 to any port 500 -> 192.168.5.2/32 static-port # Auto created rule for ISAKMP - localhost to LAN
nat on $WANINDIHOME inet from 192.168.5.0/24 to any -> 192.168.5.2/32 port 1024:65535 # Auto created rule - localhost to LAN

#Redirect this traffic to our internal servers
rdr on $LANWIFI proto tcp from any to any port 53 -> 192.168.7.1 port 53
rdr on $LANWIFI proto udp from any to any port 53 -> 192.168.7.1 port 53
rdr on $LANWIFI proto udp from any to any port 80 -> 192.168.7.1 port 8002

block in log quick from 169.254.0.0/16 to any ridentifier 1000000101 label "Block IPv4 link-local"
block in log quick from any to 169.254.0.0/16 ridentifier 1000000102 label "Block IPv4 link-local"
block in log inet all ridentifier 1000000103 label "Default deny rule IPv4"
block out log inet all ridentifier 1000000104 label "Default deny rule IPv4"
block log quick inet proto { tcp, udp } from any port = 0 to any ridentifier 1000000114 label "Block traffic from port 0"
block log quick inet proto { tcp, udp } from any to any port = 0 ridentifier 1000000115 label "Block traffic to port 0"
block in log quick on $WANINDIHOME from <bogons> to any ridentifier 11001 label "block bogon IPv4 networks from WANINDIHOME"
block in log quick on $WANINDIHOME from 10.0.0.0/8 to any ridentifier 12001 label "Block private networks from WANINDIHOME block 10/8"
block in log quick on $WANINDIHOME from 127.0.0.0/8 to any ridentifier 12002 label "Block private networks from WANINDIHOME block 127/8"
block in log quick on $WANINDIHOME from 172.16.0.0/12 to any ridentifier 12003 label "Block private networks from WANINDIHOME block 172.16/12"
block in log quick on $WANINDIHOME from 192.168.0.0/16 to any ridentifier 12004 label "Block private networks from WANINDIHOME block 192.168/16"
block in log quick on $WANINDIHOME from fc00::/7 to any ridentifier 12005 label "Block ULA networks from WANINDIHOME block fc00::/7"

pass in all
pass out all
antispoof log for $WANINDIHOME ridentifier 1000001570
antispoof log for $LANWIFI ridentifier 1000002620
pass quick on lo0 all

#allow access to DHCP server on LANWIFI
pass in quick on $LANWIFI proto udp from any port = 68 to 255.255.255.255 port = 67 ridentifier 1000002641 label "allow access to DHCP server"
pass in quick on $LANWIFI proto udp from any port = 68 to 192.168.7.1 port = 67 ridentifier 1000002642 label "allow access to DHCP server"
pass out quick on $LANWIFI proto udp from 192.168.7.1 port = 67 to any port = 68 ridentifier 1000002643 label "allow access to DHCP server"

#First rule - allow all traffic from this server
pass in on $loopback inet all ridentifier 1000002661 label "pass IPv4 loopback"
pass out on $loopback inet all ridentifier 1000002662 label "pass IPv4 loopback"
pass in on $loopback inet6 all ridentifier 1000002663 label "pass IPv6 loopback"
pass out inet all keep state allow-opts ridentifier 1000002665 label "let out anything IPv4 from firewall host itself"
pass out route-to ( nfe0 192.168.5.1 ) from 192.168.5.2 to !192.168.5.0/24 ridentifier 1000002761 keep state allow-opts label "let out anything from firewall host itself"
pass out route-to ( vr0 192.168.7.1 ) from 192.168.7.1 to !192.168.7.0/24 ridentifier 1000002762 keep state allow-opts label "let out anything from firewall host itself"

# # # INCOMING TRAFFIC # # #
block in log all

# NAT Reflection rules
pass in inet tagged PFREFLECT ridentifier 1000003081 keep state label "NAT REFLECT: Allow traffic to localhost"
pass in quick on $WANINDIHOME reply-to ( nfe0 192.168.5.1 ) inet from any to any ridentifier 1676950281 keep state label "USER_RULE"

pass in quick on $LANWIFI reply-to ( vr0 192.168.7.1 ) inet proto tcp from 192.168.7.0/24 to any port 22 ridentifier 1676946710 flags S/SA keep state label "SSH"
pass in quick on $LANWIFI reply-to ( vr0 192.168.7.1 ) inet proto tcp from 192.168.7.0/24 to any port 53 ridentifier 1676946713 flags S/SA keep state label "USER_RULE: Default allow LAN to any rule"
pass in quick on $LANWIFI reply-to ( vr0 192.168.7.1 ) inet proto udp from 192.168.7.0/24 to any port 53 ridentifier 1676946729 keep state label "USER_RULE: Default allow LAN to any rule"
pass in quick on $LANWIFI reply-to ( vr0 192.168.7.1 ) inet proto tcp from 192.168.7.0/24 to any port 80 ridentifier 1676947088 flags S/SA keep state label "USER_RULE: Default allow LAN to any rule"
pass in quick on $LANWIFI reply-to ( vr0 192.168.7.1 ) inet proto tcp from 192.168.7.0/24 to any port 443 ridentifier 1676947099 flags S/SA keep state label "USER_RULE: Default allow LAN to any rule"
pass in quick on $LANWIFI reply-to ( vr0 192.168.7.1 ) inet proto tcp from 192.168.7.0/24 to any port 123 ridentifier 1676947120 flags S/SA keep state label "USER_RULE: Default allow LAN to any rule"
pass in quick on $LANWIFI reply-to ( vr0 192.168.7.1 ) inet from 192.168.7.0/24 to any ridentifier 0100000101 keep state label "USER_RULE: Default allow LAN to any rule"
```

After all applications have been configured and nothing has been missed, restart all the applications that we have configured.

```console
root@ns1:~ # service isc-dhcpd restart
root@ns1:~ # service syslogd restart
root@ns1:~ # service pf restart
```
If you didn't miss anything in the above configuration, at this point you should have a FreeBSD Router Gateway with PF Firewall. Now you can enable your Windows clients with Static IP or dynamic IP obtained from DHCP Server.

Even with the above configuration, your FreeBSD Router Gateway is up and running, but it seems incomplete if DNS server is not installed. Please choose the appropriate DNS server, BIND or Unbound, all are equally good according to your network system needs.