---
title: Creating an Internet Router Gateway With FreeBSD and PF Firewall
date: "2025-05-19 08:25:10 +0100"
id: router-gateway-freebsd-pf-firewall
lang: en
layout: single
author_profile: true
categories:
  - FreeBSD
tags: "SysAdmin"
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

In FreeBSD, ALTQ can be used with PF to provide Quality of Service (QOS). Once ALTQ is enabled, queues can be defined in rule sets that determine the processing priority of outgoing packets. Before enabling ALTQ, make sure the driver for the network card/Land Card installed on the FreeBSD system supports it. ALTQ is not available as a loadable kernel module. To activate the PF Firewall kernel on FreeBSD, add the following script to the GENERIC file in the /usr/src/sys/amd64/conf folder.

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

What you need to pay attention to here is the type of FreeBSD machine or motherboard used. In this article, the motherboard and processor used are AMD, so the GENERIC file folder is in amd64 /usr/src/sys/amd64. After inserting the PF Firewall kernel module into the GENERIC build file and installing the GENERIC kernel.

```
root@ns1:~ # cd /usr/src
root@ns1:/usr/src # make build kernel && make installkernel && reboot
```

## 3. Create Boot Script rc.d

After the build and install process for the PF Firewall kernel module is complete, create the rc.d script, so that the PF Firewall can be loaded automatically when the computer is rebooted. Type the following script in the /etc/rc.conf file.

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

Add the following script to the /boot/loader.conf file.

```
root@ns1:~ # ee /boot/loader.conf
net.inet.ip.fw.default_to_accept=1
```

After that, in the /etc/sysctl.conf file, add the following script.

```
root@ns1:~ # ee /etc/sysctl.conf
net.inet.ip.forwarding=1
```

## 4. IPFW Firewall configuration

The next step is to create rules for PF Firewall. Enter the following script in the /etc/pf1.conf file that we created above.

```
root@ns1:~ # ee /etc/pf1.conf
# /etc/pf.conf
### pf.conf
### macross
## internal and external interfaces
int_if = "vr0"
ext_if = "nfe0"
int_addr = "192.168.7.1"             # Internal IPv4 address (i.e., gateway for private network)
int_network = "192.168.7.0/24"         # Internal IPv4 networkqi

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

When writing the script above, don't make a mistake in determining the WAN and LAN interfaces. The WAN interface from Telkom My Indihome is "nfe0" and the interface for the local/private network is "vr0". After that, restart the PF Firewall.

