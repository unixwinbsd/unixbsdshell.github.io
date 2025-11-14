---
title: How to Create an IPFW Firewall on FreeBSD with One Network Card
date: "2025-08-13 10:15:47 +0100"
updated: "2025-08-13 10:15:47 +0100"
id: create-ipfw-firewall-with-single-card-on-freebsd
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: Anonymous
background: /img/Logo.png
toc: true
comments: true
published: true
excerpt: Ipfirewall is an open source module ported to many operating systems. This list includes FreeBSD, NetBSD, OpenBSD, SunOS, HP/UX and Solaris, Mac OS and even Windows. It is also frequently used for various embedded systems. It first appeared in FreeBSD version 2.0.
keywords: firewall, rules, freebsd, network ipfw, filter, pf firewall, single card, card, network card, router
---

IPFW is an IPv4 and IPv6 compatible stateful firewall designed for FreeBSD. It consists of a kernel firewall filter rules processor with integrated packet accounting facilities, logging facilities, NAT, dummynet traffic shaping, forward facilities, bridge facilities, and ipstealth facilities.

FreeBSD includes example rule sets in `/etc/rc.firewall` that define many types of firewalls for specific circumstances to assist inexperienced users in developing appropriate rules. IPFW offers a powerful syntax that allows expert users to create customized rule sets that meet the security needs of specific environments.

In the previous series of articles, we studied PF firewalls. After we configure it and explore its capabilities for various traffic functions. In the new loop, we will do the same for the IPFW firewall. As with the PF firewall, let's start with a brief overview and create a simple configuration to protect our FreeBSD server. In the next section, we'll dive in and configure step by step, introducing new rule types and adding some firewall rules.

Ipfirewall is an open source module ported to many operating systems. This list includes FreeBSD, NetBSD, OpenBSD, SunOS, HP/UX and Solaris, Mac OS and even Windows. It is also frequently used for various embedded systems. It first appeared in FreeBSD version 2.0.

In ipfw, configuration consists of numbered rules. Packets follow a rule, going from smaller numbers to larger numbers, until the first action (for example, allow or deny), after which processing stops. Somewhat similar to iptables on Linux.


## 1. Create a Start Up Script rc.d

Even though the IPFW Firewall is built into the FreeBSD system, this firewall is not automatically activated. To activate the IPFW Firewall we have to add several scripts to the /etc/rc.conf file. The following is an example of an IPFW Firewall script for automatic start up. Enter the script below into the `rc.conf` file.

```yml
firewall_enable="YES"
firewall type="open"
firewall_script="/etc/ipfw.rules"
firewall_logging="YES"
firewall_logif="YES"
```

Only rules with the log option enabled will be logged. this option is not included in the default rules. Therefore, it is recommended to change the default rule set for logging. Additionally, if logs are stored in separate files, log rotation may be necessary. To set the logging limit we have to set it in the `/etc/sysctl.conf` file. Enter the following script in the `/etc/sysctl.conf` file.

```yml
root@router2:~ # echo "net.inet.ip.fw.verbose_limit=5" >> /etc/sysctl.conf
```

To display logging file information, use the following script.

```yml
root@router2:~ # tcpdump -t -n -i ipfw0
```

And to determine the number of logging limits, enter the following script into the `/etc/sysctl.conf` file.

```yml
net.inet.ip.fw.verbose_limit=5
```


## 2. Create IPFW Firewall Rules

After the Start Up rc.d is created and the logging rules are set, it is time to create the IPFW Firewall Rules script. Before we write IPFW Firewall rules, add the following script to the `/etc/sysctl.conf` file.

```console
net.inet.ip.fw.default_to_accept="1"
```

If the script above has been added to the `/etc/sysctl.conf` file, then we can start writing IPFW Firewall rules. To write these Rules, we look at the script in the `rc.conf` file above. In the `rc.conf` file the rules are defined with the file name `ipfw.rules`. Create the file with the following command.

```yml
root@router2:~ # touch /etc/ipfw.rules
root@router2:~ # chmod -R +x /etc/ipfw.rules
```


Next, in the `/etc/ipfw.rules` file, enter the following script.

```console
ipfw -q -f flush

eif="re0"
edns="8.8.8.8"
cmd="ipfw -q add"
ks="keep-state"

$cmd 00010 allow all from any to any via lo0
$cmd 00005 allow all from any to any via re0

$cmd 00020 check-state 
$cmd 00030 deny all from any to any frag 
$cmd 00040 deny tcp from any to any established in via $eif


$cmd 000100 allow tcp from any to me 80 in via $eif $ks
$cmd 000110 allow tcp from any to me 443 in via $eif $ks
#$cmd 000120 allow tcp from any to me 22 in via $eif $ks
$cmd 000900 allow all from me to any out via $eif $ks
$cmd 001000 deny log all from any to any
```

Then we continue by restarting the IPFW Firewall.

```yml
root@router2:~ # service ipfw restart
```

The method above is the simplest way to create an IPFW Firewall. This method can only be applied to Single Host or FreeBSD servers with one interface.