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



