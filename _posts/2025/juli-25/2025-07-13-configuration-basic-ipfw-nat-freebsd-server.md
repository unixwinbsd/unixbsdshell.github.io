---
title: Basic Configuration of IPFW NAT Firewall with FreeBSD Server
date: "2025-07-13 02:52:21 +0100"
updated: "2025-07-13 02:52:21 +0100"
id: configuration-basic-ipfw-nat-freebsd-server
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: SysAdmin
background: https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/images/10ipfw_firewall_configuration_on_freebsd.jpg
toc: true
comments: true
published: true
excerpt: IPFIREWALL (IPFW) is a FreeBSD-sponsored firewall software application written and maintained by volunteer FreeBSD staff members. IPFW uses legacy stateless rules and legacy rule coding techniques to achieve what is called Simple Stateful logic
keywords: firewall, nat, ipfw, router, freebsd, configuration, server
---

Firewalls allow for filtering of traffic entering and leaving a system. Firewalls use one or more sets of "rules" to evaluate network packets as they enter or exit a network connection and allow or disallow the traffic. Firewall rules examine one or more packet attributes, including protocol type, source/destination host addresses, and source/destination ports.

IPFIREWALL (IPFW) is a FreeBSD-sponsored firewall software application written and maintained by volunteer FreeBSD staff members. IPFW uses legacy stateless rules and legacy rule coding techniques to achieve what is called Simple Stateful logic.

IPFW's stateless rule syntax is empowered with technically advanced selection capabilities that far exceed the knowledge level of the average firewall installer. IPFW is intended for professional users or advanced computer hobbyists with advanced packet selection requirements. A high-level, detailed understanding of how different protocols use and construct their unique packet header information is required before the power of IPFW rules can be unleashed. Providing that level of explanation is beyond the scope of this section of the handbook.

IPFW consists of seven components, the primary components being the kernel firewall filter rule processor and integrated packet counting facility, the logging facility, the NAT redirect rule trigger facility, and the advanced special-purpose facility, the dummynet traffic shaping facility, the forward 'fwd rule' facility, the bridge facility, and the ipstealth facility.

In this article, we will discuss NAT configuration using the IPFW Firewall. Before we delve further, let's briefly explain NAT. Network Address Translation (NAT) is the process of mapping one Internet Protocol (IP) address to another by modifying the IP packet header as it passes through a router. This helps improve security and reduce the number of used IP addresses.

Why is NAT essential for internet access? As we know, accessing the internet requires a public IP address; computers with private IP addresses cannot access the internet. So, why can our home computers access the internet, but not computers with private IP addresses? NAT is the answer. With NAT, home computers or computers with private IP addresses can access the internet.

<br/>
<img alt="ipfw firewall configuration on freebsd" width="99%" class="lazyload" style="display: block; margin: auto;" src="{{ 'https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/images/10ipfw_firewall_configuration_on_freebsd.jpg' | relative_url }}">
<br/>


## 1. System Requirements
- OS: FreeBSD 13.2 Stable
- Land Card IP nfe0: 192.168.5.2/24 (WAN Network)
- IP Land Card vr0: 192.168.7.1/24 (LAN Network)
- Default Router: 192.168.5.1
- CPU: AMD Phenom(tm) II X4 955 Processor


## 2. Kernel Configuration
The first step in configuring NAT on a FreeBSD computer is to enable the kernel required for the IPFW Firewall. Add the script below to the `GENERIC` file.

```console
root@ns1:~ # ee /usr/src/sys/amd64/conf/GENERIC
options         IPFIREWALL
options         ROUTETABLES=7
options         DUMMYNET
options         HZ="1000"
options         IPFIREWALL_VERBOSE  # enables logging for rules with log keyword to syslogd(8)
options         IPFIREWALL_VERBOSE_LIMIT=17  # limits number of logged packets per-entry
options         IPFIREWALL_DEFAULT_TO_ACCEPT # sets default policy to pass what is not explicitly denied
options         IPFIREWALL_NAT  # enables basic in-kernel NAT support
options         LIBALIAS  # enables full in-kernel NAT support
options         IPFIREWALL_NAT64  # enables in-kernel NAT64 support
options         IPFIREWALL_NPTV6  # enables in-kernel IPv6 NPT support
options         IPFIREWALL_PMOD  # enables protocols modification module support
options         IPDIVERT  # enables NAT through natd(8)
options         IPSTEALTH
options         DEVICE_POLLING
options         MROUTING
device          coretemp
```

The `"options"` option in the above script enables the kernel required by the IPFW Firewall. You can place this script at the end of the GENERIC file. For a complete discussion of FreeBSD kernel configuration, you can read our previous article. Then, proceed to build and install the kernel. Type the following script.

```console
root@ns1:~ # cd /usr/src
root@ns1:/usr/src # make buildkernel && make installkernel && reboot
```

## 3. Configure the IP Address
After the computer has finished rebooting and restarted, continue configuring the IP address in the `/etc/rc.conf` file. Since we're using two Land Cards in this tutorial, each Land Card must have a designated IP address. Type the following script into the `/etc/rc.conf` file.

```console
root@ns1:~ # ee /etc/rc.conf
ifconfig_nfe0="inet 192.168.5.2 netmask 255.255.255.0"
ifconfig_vr0="inet 192.168.7.1 netmask 255.255.255.0"
defaultrouter="192.168.5.1"
gateway_enable="YES"

firewall_enable="YES"
firewall_type="open"
#firewall_script="/etc/ipfw.rules"
#firewall_script="/etc/ipfw2.rules"
#firewall_script="/etc/ipfw3.rules"
#firewall_script="/etc/ipfw4.rules"
firewall_script="/etc/ipfw5.rules"
firewall_logging="YES"
firewall_logif="YES"

natd_enable="YES"
natd_interface="nfe0"  #Land Card WAN My Indihome
natd_flags="-dynamic -m"
```
In the script, the IP Address nfe0 is taken from the FiberHome My Indihome router `192.168.5.2` and the IP Address vr0 for the Local/Private network is `192.168.7.1`. For the default router, we use the gateway from the Fiber Home My Indihome modem, which is `192.168.5.1`. natd_enable to enable NAT on the router and gateway_enable to enable the gateway on the FreeBSD machine we are setting. Usually for the local/private network gateway on Land Card VR0, the gateway IP is the IP originating from Land Card `VR0`, which is `192.168.7.1`.


## 4. Configure the IPFW Firewall

Once all the above configurations are complete, proceed to configuring the IPFW Firewall. Below are some examples of `/etc/ipfw.rules` files that you can use and apply to your FreeBSD router.

**Sample script 1 /etc/ipfw.rules**

```console
#!/bin/sh
wan="nfe0"
lan="vr0"
wan_int="192.168.5.2"
lan_int="192.168.7.1"
ipfw="/sbin/ipfw -q"

# ?????????? ??? ???????:
${ipfw} -f flush
${ipfw} -f pipe flush
${ipfw} -f queue flush

${ipfw} add allow ip from any to any via lo0
${ipfw} add deny ip from any to 127.0.0.0/8
${ipfw} add deny ip from 127.0.0.0/8 to any

${ipfw} add divert natd ip from any to any via nfe0
${ipfw} add allow ip from any to any
${ipfw} add deny log all from any to any
```
**Sample script 2 /etc/ipfw.rules**

```console
#!/bin/sh
cmd="ipfw -q add"
skip="skipto 500"
pif="nfe0"
ks="keep-state"
good_tcpo="22,25,37,43,53,80,443,110,119"

ipfw -q -f flush

$cmd 002 allow all from any to any via vr0  # exclude LAN traffic
$cmd 003 allow all from any to any via lo0  # exclude loopback traffic

$cmd 100 divert natd ip from any to any in via $pif
$cmd 101 check-state

# Authorized outbound packets
$cmd 120 $skip udp from any to 1.1.1.1 53 out via $pif $ks
$cmd 121 $skip udp from any to 1.1.1.1 53 out via $pif $ks
$cmd 125 $skip tcp from any to any $good_tcpo out via $pif setup $ks
$cmd 130 $skip icmp from any to any out via $pif $ks
$cmd 135 $skip udp from any to any 123 out via $pif $ks


# Deny all inbound traffic from non-routable reserved address spaces
$cmd 300 deny all from 192.168.0.0/16  to any in via $pif  #RFC 1918 private IP
$cmd 301 deny all from 172.16.0.0/12   to any in via $pif  #RFC 1918 private IP
$cmd 302 deny all from 10.0.0.0/8      to any in via $pif  #RFC 1918 private IP
$cmd 303 deny all from 127.0.0.0/8     to any in via $pif  #loopback
$cmd 304 deny all from 0.0.0.0/8       to any in via $pif  #loopback
$cmd 305 deny all from 169.254.0.0/16  to any in via $pif  #DHCP auto-config
$cmd 306 deny all from 192.0.2.0/24    to any in via $pif  #reserved for docs
$cmd 307 deny all from 204.152.64.0/23 to any in via $pif  #Sun cluster
$cmd 308 deny all from 224.0.0.0/3     to any in via $pif  #Class D & E multicast

# Authorized inbound packets
$cmd 400 allow udp from 192.168.5.2 to any 68 in $ks
$cmd 420 allow tcp from any to me 80 in via $pif setup limit src-addr 1


$cmd 450 deny log ip from any to any

# This is skipto location for outbound stateful rules
$cmd 500 divert natd ip from any to any out via $pif
$cmd 510 allow ip from any to any via vr0
```

**Sample script 3 /etc/ipfw.rules**

```console
#!/bin/sh

fw="/sbin/ipfw -q"
#admin="192.168.12.2, 192.168.12.7"
#user="192.168.12.3, 192.168.12.5"
lan="192.168.7.1"

${fw} flush

${fw} add 10 allow all from any to any via lo0
${fw} add 20 deny ip from 127.0.0.0/8 to any
${fw} add 30 deny ip from any to 127.0.0.0/8
${fw} add 40 deny ip from 192.168.12.0/24 to any in recv le0
${fw} add 50 deny ip from any to any frag

#${fw} add 55 fwd 127.0.0.1, 3128 ip from ${admin} to any 80,443 in recv le1
#${fw} add 56 fwd 127.0.0.1, 3128 all from ${user} to any 80,443 in recv le1

${fw} add 60 divert natd all from any to any via nfe0

${fw} add 65 allow tcp from any 3389 to any
${fw} add 66 allow tcp from any to any 3389

${fw} add 67 allow tcp from any 22 to any
${fw} add 68 allow tcp from any to any 22

${fw} add 70 allow tcp from any to any established
${fw} add 80 allow tcp from me to any setup

${fw} add 90 allow udp from me to any 53 via nfe0
${fw} add 100 allow udp from any 53 to me via nfe0

${fw} add 110 allow tcp from me to any 80 via nfe0
${fw} add 111 allow tcp from any 80 to me via nfe0

${fw} add 112 allow tcp from me to any 443 via nfe0
${fw} add 113 allow tcp from any 443 to me via nfe0

#${fw} add 110 allow all from ${admin} to any via vr0
#${fw} add 111 allow all from ${user} to me via vr0
${fw} add 114 allow all from me to any via vr0
#${fw} add 115 deny log all from any to any via vr0
```

**Sample script 4 /etc/ipfw.rules**

```console
### set your outside network connecting to internet
###  (interface network and netmask and ip)
oif="nfe0"
onet="192.168.5.0"
omask="255.255.255.0"
oip="192.168.5.2"
onet6="fe80::"
oprefixlen6="64"
oip6="fe80::202:b3ff:fe0a:c30e"

### set your inside network connecting to user clients
###  (interface network and netmask and ip)
iif="nfe0"
inet="192.168.7.0"
imask="255.255.255.0"
iip="192.168.7.1"
inet6="2001:2f8:22:802::"
iprefixlen6="64"
iip6="2001:2f8:22:802::1"

### set firewall command path
fwcmd="/sbin/ipfw"

### reset firewall rules
$fwcmd -q -f flush

### divert packet to NATD 
$fwcmd add 1 divert natd ip4 from any to any via ${oif}

### Stop spoofing
$fwcmd add deny all from ${inet}:${imask} to any in via ${oif}
$fwcmd add deny all from ${onet}:${omask} to any in via ${iif}

### Allow from / to myself
$fwcmd add pass all from me to any
$fwcmd add pass all from any to me

### Allow DNS queries out in the world
### (if DNS is on localhost, delete passDNS)
$fwcmd add pass udp from any 53 to any
$fwcmd add pass udp from any to any 53
$fwcmd add pass tcp from any to any 53
$fwcmd add pass tcp from any 53 to any

### Allow RA RS NS NA Redirect...
#$fwcmd add pass ipv6-icmp from any to any

# Allow IP fragments to pass through
$fwcmd add pass all from any to any frag

# Allow RIPng
#$fwcmd add pass udp from fe80::/10 521 to ff02::9 521
#$fwcmd add pass udp from fe80::/10 521 to fe80::/10 521

############Taggged rules############################
## Opengate add following rules after authentication (at Layer2 check)
## (Need 'net.link.ether.ipfw=1' in /etc/sysctl.conf to enable L2 check)
##   count tag 123 ip from any to any MAC any <CliMac> keep-state via ..
##   count tag 123 ip from any to any MAC <CliMac> any keep-state via ..
## 123 : Can be set as IpfwTagNumber of opengatesrv.conf
## <CliMac> :MAC address of authenticated client

#$fwcmd add 60000 allow ip from any to any tagged 123

################################################

## At L2 check, throw all packets to L3 check after tagged
#$fwcmd add 60010 pass ip from any to any MAC any any

### Forwarding IPv4 http connection from unauth client 
#$fwcmd add 60100 fwd localhost tcp from ${inet}:${imask} to any 80
#$fwcmd add 60100 fwd localhost tcp from ${inet}:${imask} to any 443

### Allow http reply for forwarded request 
### (it is sent out from localhost but has original source address)
$fwcmd add 60110 pass tcp from any 80 to any out
$fwcmd add 60120 pass tcp from any 443 to any out
$fwcmd add 60120 pass tcp from any 22 to any out

# TCP reset notice message for IPv6 http connection
#$fwcmd add 60130 reset tcp from any to any 80
#$fwcmd add 60140 reset tcp from any to any 443
```

**Sample script 5 /etc/ipfw.rules**

```console
#!/bin/sh

# 1. General settings
# 1.1 Interfaces
# 1.1.1 External interface
eif="nfe0"
eip="192.168.5.2"
# 1.1.2 Internal interface
iif="vr0"
iip="192.168.7.1"
# 1.2 Access lists
# 1.2.1 Local access ACL
laccess="192.168.7.0/24"
# 1.2.2 Remote access ACL
#raccess="xx.xx.xx.188/30,xx.xx.xx.xx/30"
# 1.2.3 Local access to external Mail Servers ACL
#emaccess="192.168.0.77,192.168.0.140"
# 1.2.4 Blocklists ACL
blocklst01="192.168.0.0/16,172.16.0.0/12,10.0.0.0/8,127.0.0.0/8,0.0.0.0/8,169.254.0.0/16,192.0.2.0/24,204.152.64.0/23,224.0.0.0/3"
blocklst02="81,113,137,138,139,445"

        fwcmd="/sbin/ipfw -q"
        fwcmd="/sbin/ipfw"
        ${fwcmd} -f flush

# 2.2 No restrictions on Loopback Interface
${fwcmd} add allow ip from any to any via lo0
# 2.3 Rules based on traffic destanation
# 2.3.1 External interface :: OUT
${fwcmd} add skipto 10000 all from any to any out via ${eif}
# 2.3.2 External interface :: IN
${fwcmd} add skipto 15000 all from any to any in via ${eif}
# 2.3.3 Internal interface :: OUT
${fwcmd} add skipto 20000 all from any to any out via ${iif}
# 2.3.4 Internal interface :: IN
${fwcmd} add skipto 25000 all from any to any in via ${iif}
# 2.6.3 Destanation does not match
${fwcmd} add deny log ip from any to any

# 3. Local Rulesets
# 3.1 Ruleset based on 2.3.1
# NAT :: Outgoing packets
${fwcmd} add 10000 divert natd ip from ${laccess} to any
# Local Network/Local Host :: Internet  (ALL)
#${fwcmd} add 10050 allow ip from me to ${raccess}
${fwcmd} add 10100 allow ip from me to any keep-state
# Default rule
${fwcmd} add 10200 deny ip from any to any
#---------------------------
# 3.2 Ruleset based on 2.3.2
# Block List :: Non routable networks 
${fwcmd} add 15000 deny ip from ${blocklst01} to any
# NAT :: Incoming packets
${fwcmd} add 15100 divert natd ip from any to me
# Dynamic rules
${fwcmd} add 15200 check-state
#${fwcmd} add 15250 allow ip from ${raccess} to me
# Internet :: Local Netwok/Localhost (Framents, ACK W/O SYN, NetBIOS, Ident)
${fwcmd} add 15300 deny all from any to any frag
${fwcmd} add 15400 deny tcp from any to any established
${fwcmd} add 15500 deny tcp from any to any ${blocklst02}
# Internet :: Localhost (SMTP, Restricted ICMP)
#${fwcmd} add 15600 allow tcp from any to me 25 setup keep-state
${fwcmd} add 15700 allow icmp from any to me icmptypes 0,3,8,11
# Internet :: Local Network (Static rule)
${fwcmd} add 15800 allow ip from any to ${laccess}
# Default rule
${fwcmd} add 15900 deny ip from any to any
#---------------------------
# 3.3 Ruleset based on 2.3.3
# ALL :: Local Network
${fwcmd} add 20000 allow ip from any to ${laccess}
# Default rule
${fwcmd} add 20100 deny ip from any to any
#---------------------------
# 3.4 Ruleset based on 2.3.4
# Local Network :: Localhost (FTP, SSH, SMTP, DNS, DHCP, POP3, IMAP, SQUID, ICMP)
${fwcmd} add 25000 allow tcp from ${laccess} to me 53,8952,22,5053,853,67,8953,80,443
${fwcmd} add 25100 allow udp from ${laccess} to me 53,67,8952,5053,8953
${fwcmd} add 25200 allow icmp from ${laccess} to me
# Local Network :: Local Network
${fwcmd} add 25300 allow ip from ${laccess} to ${laccess}
# Local Network :: Internet (Restricted SMTP, FTP, SSH, POP3, IMAP, HTTPS, Jabber, ICMP)
#${fwcmd} add 25400 allow ip from ${emaccess} to any 25 keep-state
${fwcmd} add 25500 allow ip from ${laccess} to any 53,8952,22,5053,853,67,8953,80,443 keep-state
#${fwcmd} add 25550 allow ip from ${laccess} to any 53,67,8952,5053,8953 keep-state
${fwcmd} add 25600 allow icmp from ${laccess} to any
# Default rule
${fwcmd} add 25700 deny ip from any to any
```

Please select one of the five IPFW Firewall script examples above. Don't worry, all scripts have been tested and validated, and all scripts run normally, and the FreeBSD 13.2 router engine is stable. The above scripts can also be used on previous FreeBSD versions, namely FreeBSD 12, 11, 10.9, and 8. If all the configurations above don't miss any NAT and the gateway should be running normally, but it's still not perfect, why?

You need to add the ISC-DHCP application so that each client can automatically obtain an IP address (dynamic) or static (static IP). It would be even more complete if your FreeBSD router also has BIND or Unbound installed as a DNS server. If you encounter any difficulties or problems configuring NAT, please send us an email.