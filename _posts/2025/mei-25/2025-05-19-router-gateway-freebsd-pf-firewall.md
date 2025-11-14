---
title: Creating an Internet Router Gateway With FreeBSD and PF Firewall
date: "2025-05-19 08:25:10 +0100"
updated: "2025-10-21 19:41:22 +0100"
id: router-gateway-freebsd-pf-firewall
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: SysAdmin
background: /img/Logo.png
toc: true
comments: true
published: true
excerpt: Packet Filter (PF) is a firewall developed for OpenBSD and later ported to FreeBSD and NetBSD.
keywords: freebsd, router, gateway, internet, pf, packet firewall, filter, nat, firewall, ip, static, filter
---

Packet Filter (PF) is a firewall developed for OpenBSD and later ported to FreeBSD and NetBSD. Compared to the same ipfw, it has a more understandable syntax for reading and writing firewall rules, has built-in NAT, traffic queuing and many more advantages of PF Firewall. This firewall was created by a UNIX hacker, from the beginning it has been embedded in the OpenBSD machine.

In the previous article we discussed Gateway Router with IPFW Firewall, on this occasion we will continue the discussion with the topic of building a Gateway Router with PF Firewall to access the internet. Actually the material is not much different from the article about building a Gateway Router with IPFW Firewall, we only add the PF Firewall kernel and configure the firewall rules a little.

## 1. System Requirements

- OS: FreeBSD 13.2 Stable
- IP Land Card nfe0: 192.168.5.2/24 (Jaringan WAN / My Indihome)
- IP Land Card vr0: 192.168.7.1/24 (Jaringan Private/Local Network)
- Default Router: 192.168.5.1
- CPU: AMD Phenom(tm) II X4 955 Processor

## 2. Kernel Configuration

While you don't need to compile PF support into the FreeBSD kernel, you may want to do so to take advantage of one of PF's advanced features not included in the loadable module, namely pfsync, which is a pseudo-device that exposes certain changes to the state table used by P.F. Can be paired with carp to create a failover firewall using PF Firewall.

In FreeBSD, ALTQ can be used with PF to provide Quality of Service (QOS). Once ALTQ is enabled, queues can be defined in rule sets that determine the processing priority of outgoing packets. Before enabling ALTQ, make sure the driver for the network card/Land Card installed on the FreeBSD system supports it. ALTQ is not available as a loadable kernel module. To activate the PF Firewall kernel on FreeBSD, add the following script to the GENERIC file in the `/usr/src/sys/amd64/conf` folder.

```
root@ns1:~ # ee /usr/src/sys/amd64/conf/GENERIC
options         ALTQ
options         ALTQ_CBQ
options         ALTQ_RED
options         ALTQ_RIO
options         ALTQ_HFSC
options         ALTQ_PRIQ
device		    pf
device		    pflog
device		    pfsync
```

What you need to pay attention to here is the type of FreeBSD machine or motherboard used. In this article, the motherboard and processor used are AMD, so the GENERIC file folder is in amd64 `/usr/src/sys/amd64`. After inserting the PF Firewall kernel module into the GENERIC build file and installing the GENERIC kernel.

```
root@ns1:~ # cd /usr/src
root@ns1:/usr/src # make build kernel && make installkernel && reboot
```

## 3. Create Boot Script rc.d

After the build and install process for the PF Firewall kernel module is complete, create the rc.d script, so that the PF Firewall can be loaded automatically when the computer is rebooted. Type the following script in the `/etc/rc.conf` file.

```
root@ns1:~ # ee /etc/rc.conf
pf_enable="YES"                           # Enable PF (load module if re
pf_rules="/etc/pf1.conf"
#pf_rules="/etc/pf2.conf"
#pf_rules="/etc/pf3.conf"
#pf_rules="/etc/pf4.conf"
#pf_rules="/etc/pf5.conf"
pf_flags=""                               # additional flags for pfctl s
pflog_enable="YES"                        # start pflogd(8)
pflog_logfile="/var/log/pflog"            # where pflogd should store th
pflog_flags=""                            # additional flags for pflogd
pflogd_enable="YES"
pfsync_enable="YES"
```

After that, determine the IP Address of each interface/Lan Card.

```
root@ns1:~ # ee /etc/rc.conf
hostname="ns1"
#ifconfig_nfe0="DHCP"
ifconfig_nfe0="inet 192.168.5.2 netmask 255.255.255.0"
ifconfig_vr0="inet 192.168.7.1 netmask 255.255.255.0"
defaultrouter="192.168.5.1"
gateway_enable="YES"
natd_enable="YES"
natd_interface="nfe0"  #WAN
```

If the IP Address for each interface has been determined, create a file that will be filled with the PF Firewall rule script.

```
root@ns1:~ # touch /etc/pf1.conf
root@ns1:~ # chmod -R +x /etc/pf1.conf
```

Add the following script to the `/boot/loader.conf` file.

```
root@ns1:~ # ee /boot/loader.conf
net.inet.ip.fw.default_to_accept=1
```

After that, in the `/etc/sysctl.conf` file, add the following script.

```
root@ns1:~ # ee /etc/sysctl.conf
net.inet.ip.forwarding=1
```

## 4. PF Firewall configuration

The next step is to create rules for PF Firewall. Enter the following script in the `/etc/pf1.conf` file that we created above.

```
root@ns1:~ # ee /etc/pf1.conf
# /etc/pf.conf
### pf.conf
### macross
## internal and external interfaces
int_if = "vr0"
ext_if = "nfe0"
int_addr = "192.168.7.1"             # Internal IPv4 address (i.e., gateway for private network)
int_network = "192.168.7.0/24"       # Internal IPv4 networkqi

# Ports we want to allow access to from the outside world on our local system (ext_if)
tcp_services = "{ 22, 80,443,53,853 }"

# ping requests
icmp_types = "echoreq"

# Private networks, we are going to block incoming traffic from them
priv_nets = "{ 127.0.0.0/8, 192.168.0.0/16, 172.16.0.0/12, 10.0.0.0/8 }"

### options
set block-policy drop
set loginterface $ext_if
set skip on lo0

### Scrub
scrub in all

# NAT traffic from internal network to external network through external interface
nat on $ext_if from $int_if:network to any -> ($ext_if)

### Filters ###
# Permit keep-state packets for UDP and TCP on external interfaces
pass out quick on $ext_if proto udp all keep state
pass out quick on $ext_if proto tcp all modulate state flags S/SA

# Permit any packets from internal network to this host
pass in quick on $int_if inet from $int_network to $int_addr

# Permit established sessions from internal network to any (incl. the Internet)
pass in quick on $int_if inet from $int_network to any keep state
# If you want to limit the number of sessions per NAT, nodes per NAT (simultaneously), and sessions per source IP
#pass in quick on $int_if inet from $int_network to any keep state (max 30000, source-track rule, max-src-nodes 100, max-src-states 500 )

# Permit and log all packets from clients in private network through NAT
pass in quick log on $int_if all

# Pass any other packets
pass in all
pass out all
```

When writing the script above, don't make a mistake in determining the WAN and LAN interfaces. The WAN interface from Telkom My Indihome is `"nfe0"` and the interface for the local/private network is "vr0". After that, restart the PF Firewall.

```
root@ns1:~ # service pf restart
Disabling pf.
Enabling pf.
```

Below are several examples of PF Firewall rulesets that you can try and put into practice.

```
### Example script 2: (pf_rules="/etc/pf2.conf)

# External interface
ext_if="nfe0"

# Internal interface
int_if="vr0"

# Follow RFC1918 and don't route to non-routable IPs
# http://www.iana.org/assignments/ipv4-address-space
# http://rfc.net/rfc1918.html
nonroute= "{ 0.0.0.0/8, 20.20.20.0/24, 127.0.0.0/8, 169.254.0.0/16,
        172.16.0.0/12, 192.0.2.0/24, 192.168.0.0/16, 224.0.0.0/3,
        255.255.255.255 }"

# Set allowed ICMP types
# Blocking ICMP entirely is bad practice and will break things,
# FreeBSD applies rate limiting by default to mitigate attacks.
icmp_types = "{ 0, 3, 4, 8, 11, 12 }"

####################################
#### Options and optimizations #####
####################################

# Set interface for logging (statistics)
set loginterface $ext_if

# Drop states as fast as possible without having excessively low timeouts
set optimization aggressive

# Block policy, either silently drop packets or tell sender that request is blocked
set block-policy return

# Don't bother to process (filter) following interfaces such as loopback:
set skip on lo0

# Scrub traffic
# Add special exception for game consoles such as PS3 and PS4 (NAT type 2 vs 3)
# scrub from CHANGEME to any no-df random-id fragment reassemble
scrub on $ext_if all no-df fragment reassemble

#######################
#### NAT & Proxies ####
#######################

# Enable NAT and tell pf not to change ports if needed
# Add special exception for game consoles such as PS3 and PS4 (NAT type 2 vs 3)
# ie static-port mapping. Do NOT enable both rules.
# nat on $ext_if from $int_if:network to any -> ($ext_if) static-port
nat on $ext_if from $int_if:network to any -> ($ext_if)

# Redirect ftp connections to ftp-proxy
rdr pass on $int_if inet proto tcp from $int_if:network to any port 21 -> 127.0.0.1 port 8021

# Enable ftp-proxy (active connections)
# nat-anchor "ftp-proxy/*"
# rdr-anchor "ftp-proxy/*"

# Enable UPnP (requires miniupnpd, game consoles needs this)
# rdr-anchor "miniupnpd"

# Anchors needs to be set after nat/rdr-anchor
# Same as above regarding miniupnpd
# anchor "ftp-proxy/*"
# anchor "miniupnpd"

################################
#### Rules inbound (int_if) ####
################################

# Pass on everything incl multicast
pass in quick on $int_if from any to 239.0.0.0/8
pass in quick on $int_if inet all keep state

#################################
#### Rules outbound (int_if) ####
#################################

# Pass on everything incl multicast
pass out quick on $int_if from any to 239.0.0.0/8
pass out quick on $int_if inet all keep state

################################
#### Rules inbound (ext_if) ####
################################

# Drop packets from non-routable addresses immediately
block drop in quick on $ext_if from $nonroute to any

# Allow DHCP
pass in quick on $ext_if inet proto udp to ($ext_if) port { 67, 68 }

# Allow ICMP
pass in quick on $ext_if inet proto icmp all icmp-type $icmp_types

# Allow FTPs to connect to the FTP-proxy
# pass in quick on $ext_if inet proto tcp to ($ext_if) port ftp-data user proxy

# Block everything else
block in on $ext_if all

#################################
#### Rules outbound (ext_if) ####
#################################

# Drop packets to non-routable addresses immediately, allow everything else
block drop out quick on $ext_if from any to $nonroute
pass out on $ext_if all
```
<br/>

```
###Example script 3: (pf_rules="/etc/pf3.conf")
ext_if = "nfe0"
int_if = "vr0"
localnet = "192.168.7.0/24"
set skip on lo0
set loginterface $ext_if
set block-policy return
scrub in all
nat on $ext_if from $localnet to any -> ($ext_if)
block in on $ext_if all
pass on $int_if all
```
<br/>

```
###Example script 4: (pf_rules="/etc/pf4.conf")
set limit table-entries 400000
set optimization normal
set limit states 198000
set limit src-nodes 198000

#System aliases
loopback = "{ lo0 }"
WANINDIHOME = "{ nfe0 }"
LANWIFI = "{ vr0 }"

table <bogons> persist file "/etc/bogons"

# Gateways
GWWANINDIHOMEGW = " route-to ( nfe0 192.168.5.1 ) "
GWLANWIFIGW = " route-to ( vr0 192.168.7.1 ) "

set block-policy return
set loginterface vr0
set keepcounters
set skip on pfsync0
set skip on lo0
set skip on $LANWIFI

scrub on $WANINDIHOME inet all    fragment reassemble
scrub on $LANWIFI inet all    fragment reassemble

#no nat proto carp
#no rdr proto carp
#nat-anchor "natearly/*"
#nat-anchor "natrules/*"

# Outbound NAT rules (manual)
nat on $WANINDIHOME inet from 127.0.0.0/8 to any port 500 -> 192.168.5.2/32  static-port # Auto created rule for ISAKMP - localhost to WAN
nat on $WANINDIHOME inet from 127.0.0.0/8 to any -> 192.168.5.2/32 port 1024:65535  # Auto created rule - localhost to WAN
nat on $WANINDIHOME inet from 192.168.7.0/24 to any port 500 -> 192.168.5.2/32  static-port # Auto created rule for ISAKMP - localhost to LAN
nat on $WANINDIHOME inet from 192.168.7.0/24 to any -> 192.168.5.2/32 port 1024:65535  # Auto created rule - localhost to LAN
nat on $WANINDIHOME inet from 192.168.5.0/24 to any port 500 -> 192.168.5.2/32  static-port # Auto created rule for ISAKMP - localhost to LAN
nat on $WANINDIHOME inet from 192.168.5.0/24 to any -> 192.168.5.2/32 port 1024:65535  # Auto created rule - localhost to LAN

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
pass in  quick on $LANWIFI proto udp from any port = 68 to 255.255.255.255 port = 67 ridentifier 1000002641 label "allow access to DHCP server"
pass in  quick on $LANWIFI proto udp from any port = 68 to 192.168.7.1 port = 67 ridentifier 1000002642 label "allow access to DHCP server"
pass out  quick on $LANWIFI proto udp from 192.168.7.1 port = 67 to any port = 68 ridentifier 1000002643 label "allow access to DHCP server"

#First rule - allow all traffic from this server
pass in  on $loopback inet all ridentifier 1000002661 label "pass IPv4 loopback"
pass out  on $loopback inet all ridentifier 1000002662 label "pass IPv4 loopback"
pass in  on $loopback inet6 all ridentifier 1000002663 label "pass IPv6 loopback"
pass out  inet all keep state allow-opts ridentifier 1000002665 label "let out anything IPv4 from firewall host itself"
pass out  route-to ( nfe0 192.168.5.1 ) from 192.168.5.2 to !192.168.5.0/24 ridentifier 1000002761 keep state allow-opts label "let out anything from firewall host itself"
pass out  route-to ( vr0 192.168.7.1 ) from 192.168.7.1 to !192.168.7.0/24 ridentifier 1000002762 keep state allow-opts label "let out anything from firewall host itself"

# # # INCOMING TRAFFIC # # #
block in log all

# NAT Reflection rules
pass in  inet tagged PFREFLECT ridentifier 1000003081 keep state label "NAT REFLECT: Allow traffic to localhost"
pass  in  quick  on $WANINDIHOME reply-to ( nfe0 192.168.5.1 ) inet from any to any ridentifier 1676950281 keep state  label "USER_RULE"

pass  in  quick  on $LANWIFI reply-to ( vr0 192.168.7.1 ) inet proto tcp  from 192.168.7.0/24 to any port 22 ridentifier 1676946710 flags S/SA keep state  label "SSH"
pass  in  quick  on $LANWIFI reply-to ( vr0 192.168.7.1 ) inet proto tcp  from 192.168.7.0/24 to any port 53 ridentifier 1676946713 flags S/SA keep state  label "USER_RULE: Default allow LAN to any rule"
pass  in  quick  on $LANWIFI reply-to ( vr0 192.168.7.1 ) inet proto udp  from 192.168.7.0/24 to any port 53 ridentifier 1676946729 keep state  label "USER_RULE: Default allow LAN to any rule"
pass  in  quick  on $LANWIFI reply-to ( vr0 192.168.7.1 ) inet proto tcp  from 192.168.7.0/24 to any port 80 ridentifier 1676947088 flags S/SA keep state  label "USER_RULE: Default allow LAN to any rule"
pass  in  quick  on $LANWIFI reply-to ( vr0 192.168.7.1 ) inet proto tcp  from 192.168.7.0/24 to any port 443 ridentifier 1676947099 flags S/SA keep state  label "USER_RULE: Default allow LAN to any rule"
pass  in  quick  on $LANWIFI reply-to ( vr0 192.168.7.1 ) inet proto tcp  from 192.168.7.0/24 to any port 123 ridentifier 1676947120 flags S/SA keep state  label "USER_RULE: Default allow LAN to any rule"
pass  in  quick  on $LANWIFI reply-to ( vr0 192.168.7.1 ) inet from 192.168.7.0/24 to any ridentifier 0100000101 keep state  label "USER_RULE: Default allow LAN to any rule"
```

Please try the PF Firewall script example above, all scripts have been tested and tried on a stable FreeBSD 13.2 machine and the results are all the scripts above run smoothly.

If none of the above configurations are missed, then your PF Firewall is active and can run normally on the FreeBSD machine, but it is not perfect. You must install a DHCP server so that every client connected to your network gets an IP address automatically from the DHCP server. We recommend that you also install DNS such as BIND or Unbound.

If you encounter difficulties or obstacles in the NAT configuration, please send it via E-mail.
