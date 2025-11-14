---
title: Packet Filter PF Firewall For FreeBSD With One Network Card
date: "2025-04-17 08:21:11 +0100"
updated: "2025-04-17 08:21:11 +0100"
id: packet-filter-firewall-freebsd-network-card
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: SysAdmin
background: /img/Logo.png
toc: true
comments: true
published: true
excerpt: With PF Firewall it is possible to filter traffic in and out of the FreeBSD system. Firewalls use one or more sets of rules to evaluate network packets as they enter or leave a network connection and allow or disallow traffic. Firewall rules examine one or more packet attributes, including the protocol type, source/destination host address, and source destination port and interface used to transfer the traffic
keywords: ipfw, pf firewall, packet filter, freebsd, network card, interface, firewall
---

In July 2003, OpenBSD firewall software known as PF was embedded into FreeBSD systems and became available from the FreeBSD port pool. The first release in which PF was integrated into the main system was FreeBSD 5.3 in November 2004. PF is a full-featured firewall, which has optional support for ALTQ (Alternate Queuing). ALTQ provides Quality of Service (QoS) bandwidth management, which allows you to guarantee bandwidth for various services based on filtering rules.

With PF Firewall it is possible to filter traffic in and out of the FreeBSD system. Firewalls use one or more sets of "rules" to evaluate network packets as they enter or leave a network connection and allow or disallow traffic. Firewall rules examine one or more packet attributes, including the protocol type, source/destination host address, and source/destination port and interface used to transfer the traffic.

Firewalls improve the security of a network or host by protecting and isolating applications, services, and internal network devices from unwanted Internet traffic. PF Firewall can be used to limit or disable host access on an internal network to Internet services. Additionally, PF Firewall supports network address translation (NAT), which allows internal networks to use private IP addresses and share a single connection to the public Internet using a single IP address or a set of automatically allocated public addresses.

Packet Filter, also known as PF or pf, is a BSD-licensed stateful packet filter used to filter TCP/IP traffic and perform Network Address Translation (NAT.) PF was created by Daniel Hartmeier for OpenBSD and is currently maintained and developed by the OpenBSD team . PF has been ported to several other operating systems, such as FreeBSD and DragonflyBSD, today. Since OpenBSD 3.0, PF has been a component of the GENERIC kernel.

PF functions mostly in kernel space, within the network code. Based on the source or destination of the packet, as well as the protocol, connection, and destination port, PF can identify where the packet should be directed or whether it should be allowed to pass through.

One of PF's most important features is that it can detect and block traffic that you don't want to let into your local network or out to the outside world. In addition to TCP/IP traffic normalization and conditioning, PF offers bandwidth management and packet prioritization. Packet filters are a very flexible and valuable instrument for controlling network activity.

Key features of Packet Filter Firewall:
- Filtering based on address, port, protocol and interface.
- NAT, which consists of source, destination, spoofing and packet forwarding addresses.
- Scrub - normalization of network traffic.
- SYN-proxy - Protection against SYN-flood attacks.
- Connection balancer.
- Failover - pfcync allows you to synchronize the firewall state on multiple hosts, in combination with the CARP protocol.
- Transparent firewall (Without its own IP address, including layer 2 filters).
- Macros are analogous to variables.
- The table, dynamically changes the list of IP addresses without reloading the configuration.
- Label, allows you to label packages if simple filtering is not enough.
- Anchors are collections of rules, similar to IPTables tables in Linux.
- Collecting statistics and displaying graphs using the pfstat utility.
- Automatic optimization of rules on load.

In this article we will try to setup a Packet Filter Firewall on a FreeBSD machine. The PF Firewall that we will setup runs on only one interface, namely "re0". The FreeBSD system used in this article has the following specifications:
- OS: FreeBSD 13.2 Stable.
- Server IP: 192.168.9.3
- Interface: re0

<br/>

## 🗺️ 1. Enable Packet Filter Firewall

To use PF Firewall on FreeBSD we must first activate this feature. How to activate it is very easy, open the /etc/rc.conf file and enter the following script in the rc.conf file.

```console
root@router2:~ # ee /etc/rc.conf
pf_enable="YES"                 # Enable PF (load module if required)
pf_rules="/etc/pf.conf"         # rules definition file for pf
pf_flags=""                     # additional flags for pfctl startup
pflog_enable="YES"              # start pflogd(8)
pflog_logfile="/var/log/pflog"  # where pflogd should store the logfile
pflog_flags="-s"         
```

With the script above, PF Firewall will automatically filter all internet traffic. When finished, create a log file with the name pflog and place it in the `/var/log` folder.


```console
root@router2:~ touch /var/log/pflog
```

<br/>

## 🗺️ 2. Create PF Rulesets

After activating PF Firewall, the next step is to create rulesets. These rules are used to load the PF Firewall, because PF receives its configuration rules from pf.conf, as loaded by the rc.conf script above. Note that although pf.conf is the default configuration file and is imported by the system rc script, it is just a text file that is loaded and processed by pfctl and placed into pf.

Some applications may load additional rule sets from other files at startup. OK, now let's just create the `/etc/pf.conf` file.

```console
root@router2:~ touch /etc/pf.conf
root@router2:~ chmod +x /etc/pf.conf
```

If the pf.conf file is successfully created, enter the script below in the `/etc/pf.conf` file. This script applies to one interface or one landcard only.

```console
## interface Sever FreeBSD##
ext_if="re0"

## IP Server FreeBSDs ##
ext_if_ip="192.168.9.3"

## Set and drop these IP ranges on public interface ##
private  =  "{ 127.0.0.0/8, 192.168.0.0/16, 172.16.0.0/12, 10.0.0.0/8, 169.254.0.0/16, 192.0.2.0/24, 0.0.0.0/8, 240.0.0.0/4 }"

## Set http(80)/https (443) port here ##
webports  =  "{http, https}"

## enable these services ##
int_tcp_services  =  "{53, 853, 123, 22}"
int_udp_services  =  "{53, 123}"

## Skip loop back interface - Skip all PF processing on interface ##
set skip on lo0
set optimization normal
set block-policy drop

## Sets the interface for which PF should gather statistics such as bytes in/out and packets passed/blocked ##
set loginterface $ext_if

# Deal with attacks based on incorrect handling of packet fragments
scrub in all
scrub on $ext_if all reassemble tcp

block return in log all
block out all

#set skip on lo0
set skip on $ext_if

#rdr pass on lo0 proto { tcp udp } from any to port 53 -> 192.168.9.3 port 9053
#rdr pass on $ext_if proto { tcp } from any to port 80 -> 192.168.9.3 port 818

## Blocking spoofed packets
antispoof quick for $ext_if

#### Drop all Non-Routable Addresses
block drop in quick on $ext_if from $private to any
block drop out quick on $ext_if from any to $private

# Allow Ping
pass inet proto icmp icmp-type echoreq

# All access to our Nginx/Apache/Lighttpd Webserver ports
pass proto tcp from any to $ext_if port $webports

# Allow essential outgoing traffic
pass out quick on $ext_if proto tcp to any port $int_tcp_services
pass out quick on $ext_if proto udp to any port $int_udp_services

# Add custom rules below
```
Now we continue by restarting the Packet Filter Firewall.

```console
root@router2:~ service pf restart
root@router2:~ service pflog restart
```

Well, up to this point we have successfully configured PF Firewall on the FreeBSD system, meaning now our FreeBSD server has been protected or guarded with a Packet Filter Firewall.

<br/>

## 🗺️ 3. Using the pfctl Script

Even though currently our internet traffic is being guarded by the PF Firewall, there's no harm in studying the scripts used to monitor the PF firewall.

pfctl is a utility that communicates with packet filter devices using the ioctl interface to control packet filter (PF) devices. This allows configuration of rules and parameters and retrieval of packet filter status information. To view pfctl options, run the following command:

```console
root@router2:~ # pfctl -e
pfctl: pf already enabled
root@router2:~ # pfctl -h
usage: pfctl [-AdeghMmNnOPqRrvz] [-a anchor] [-D macro=value] [-F modifier]
        [-f file] [-i interface] [-K host | network]
        [-k host | network | gateway | label | id] [-o level] [-p device]
        [-s modifier] [-t table -T command [address ...]] [-x level]
root@router2:~ # pfctl -e
pfctl: pf already enabled
root@router2:~ # pfctl -d
pf disabled
root@router2:~ # pfctl -F all -f /etc/pf2.conf
rules cleared
nat cleared
0 tables deleted.
altq cleared
0 states cleared
source tracking entries cleared
pf: statistics cleared
pf: interface flags reset
root@router2:~ #
```

If we want to check the firewall ruleset `/etc/pf.conf` as a whole, use the following script.


```console
root@router2:~ # pfctl -vnf /etc/pf.conf
set limit table-entries 400000
set optimization normal
set limit states 172000
set limit src-nodes 172000
ext_if = "re0"
tcp_port = "22 123 853 53 54 55 56 9050 9001 8008 8118 1080 3128 57 7092 8181 8443 9000 4444 4445 4447 9001 7652 7657 9053 5000 3074 6800"
udp_port = "22 123 853 53 54 55 56 9050 9001 8008 8118 1080 3128 57 7092 4444 7657 9053 5000 3074 6800"
inbound_tcp_services = "{auth, http, https,  22 123 853 53 54 55 56 9050 9001 8008 8118 1080 3128 57 7092 8181 8443 9000 4444 4445 4447 9001 7652 7657 9053 5000 3074 6800  }"
inbound_udp_services = "{dhcpv6-client,openvpn,  22 123 853 53 54 55 56 9050 9001 8008 8118 1080 3128 57 7092 4444 7657 9053 5000 3074 6800  }"
set loginterface re0
set skip on { pfsync0 }
set skip on { lo0 }
set skip on { re0 }
scrub in all fragment reassemble
rdr pass on lo0 inet proto tcp from any to any port = domain -> 192.168.9.3 port 9053
rdr pass on lo0 inet proto udp from any to any port = domain -> 192.168.9.3 port 9053
block drop in on ! re0 inet from 192.168.9.0/24 to any
block drop all
pass in quick on re0 proto tcp from any to any port = auth flags S/SA keep state
pass in quick on re0 proto tcp from any to any port = http flags S/SA keep state
pass in quick on re0 proto tcp from any to any port = https flags S/SA keep state
pass in quick on re0 proto tcp from any to any port = ssh flags S/SA keep state
pass in quick on re0 proto tcp from any to any port = ntp flags S/SA keep state
pass in quick on re0 proto tcp from any to any port = domain-s flags S/SA keep state
pass in quick on re0 proto tcp from any to any port = domain flags S/SA keep state
pass in quick on re0 proto tcp from any to any port = xns-ch flags S/SA keep state
pass in quick on re0 proto tcp from any to any port = isi-gl flags S/SA keep state
pass in quick on re0 proto tcp from any to any port = xns-auth flags S/SA keep state
pass in quick on re0 proto tcp from any to any port = 9050 flags S/SA keep state
pass in quick on re0 proto tcp from any to any port = 9001 flags S/SA keep state
pass in quick on re0 proto tcp from any to any port = 8008 flags S/SA keep state
pass in quick on re0 proto tcp from any to any port = privoxy flags S/SA keep state
pass in quick on re0 proto tcp from any to any port = socks flags S/SA keep state
pass in quick on re0 proto tcp from any to any port = 3128 flags S/SA keep state
pass in quick on re0 proto tcp from any to any port = 57 flags S/SA keep state
pass in quick on re0 proto tcp from any to any port = 7092 flags S/SA keep state
pass in quick on re0 proto tcp from any to any port = 8181 flags S/SA keep state
pass in quick on re0 proto tcp from any to any port = 8443 flags S/SA keep state
pass in quick on re0 proto tcp from any to any port = 9000 flags S/SA keep state
pass in quick on re0 proto tcp from any to any port = krb524 flags S/SA keep state
pass in quick on re0 proto tcp from any to any port = 4445 flags S/SA keep state
pass in quick on re0 proto tcp from any to any port = 4447 flags S/SA keep state
pass in quick on re0 proto tcp from any to any port = 7652 flags S/SA keep state
pass in quick on re0 proto tcp from any to any port = 7657 flags S/SA keep state
pass in quick on re0 proto tcp from any to any port = 9053 flags S/SA keep state
pass in quick on re0 proto tcp from any to any port = 5000 flags S/SA keep state
pass in quick on re0 proto tcp from any to any port = 3074 flags S/SA keep state
pass in quick on re0 proto tcp from any to any port = 6800 flags S/SA keep state
pass in quick on re0 proto udp from any to any port = dhcpv6-client keep state
pass in quick on re0 proto udp from any to any port = openvpn keep state
pass in quick on re0 proto udp from any to any port = ssh keep state
pass in quick on re0 proto udp from any to any port = ntp keep state
pass in quick on re0 proto udp from any to any port = domain-s keep state
pass in quick on re0 proto udp from any to any port = domain keep state
pass in quick on re0 proto udp from any to any port = xns-ch keep state
pass in quick on re0 proto udp from any to any port = isi-gl keep state
pass in quick on re0 proto udp from any to any port = xns-auth keep state
pass in quick on re0 proto udp from any to any port = 9050 keep state
pass in quick on re0 proto udp from any to any port = 9001 keep state
pass in quick on re0 proto udp from any to any port = 8008 keep state
pass in quick on re0 proto udp from any to any port = privoxy keep state
pass in quick on re0 proto udp from any to any port = socks keep state
pass in quick on re0 proto udp from any to any port = 3128 keep state
pass in quick on re0 proto udp from any to any port = 57 keep state
pass in quick on re0 proto udp from any to any port = 7092 keep state
pass in quick on re0 proto udp from any to any port = krb524 keep state
pass in quick on re0 proto udp from any to any port = 7657 keep state
pass in quick on re0 proto udp from any to any port = 9053 keep state
pass in quick on re0 proto udp from any to any port = 5000 keep state
pass in quick on re0 proto udp from any to any port = 3074 keep state
pass in quick on re0 proto udp from any to any port = 6800 keep state
pass quick on re0 proto icmp all keep state
pass quick on re0 proto ipv6-icmp all keep state
pass out quick on re0 all flags S/SA keep state
root@router2:~ #
```

With the PF Firewall on our FreeBSD server, all attacks coming from outside the network will be blocked by the PF Firewall. With the ruleset rules that we create accurately and precisely, PF Firewall becomes a frightening figure for network intruders.