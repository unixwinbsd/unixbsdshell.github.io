---
title: How to Configure NSD with dnssec on OpenBSD
date: "2025-11-21 07:21:53 +0000"
updated: "2025-11-21 07:21:53 +0000"
id: configure-nsd-with-dnssec-on-openbsd
lang: en
author: Iwan Setiawan
robots: index, follow
categories: openbsd
tags: DNSServer
background: https://raw.githubusercontent.com/unixwinbsd/unixbsdshell.github.io/refs/heads/main/img/nop-25/nop-25-022.jpg
toc: true
comments: true
published: true
excerpt: To begin configuring DNSSEC on OpenBSD, you must first install NSD. Once you've installed NSD on OpenBSD, you can check the NSD version. This check also allows you to determine whether the NSD server is running.
keywords: configuration, nsd, master, slave, dns, server, openbsd, freebsd, dnssec, key, keygen
---

The Domain Name System, or DNS, is the underlying directory of the global Internet. However, the DNS system provides no guarantee that an online site is who it claims to be, or that the information it provides is valid. Recognizing these shortcomings and weaknesses, the Internet Engineering Task Force (IETF) developed the Domain Name System Security Extensions (DNSSEC). These extensions add authentication and integrity protection to the DNS protocol.

## A. Why Use DNSSEC for DNS?

DNSSEC is a set of security features for authenticating and validating requested DNS data. DNSSEC uses public and private key cryptography to sign DNS data. DNSSEC is responsible for verifying the identity of each zone and the integrity of the records within that zone.

<img alt="How to Configure NSD with dnssec on OpenBSD" width="99%" class="lazyload img-thumbnail" style="display: block; margin: auto;" src="{{ 'https://raw.githubusercontent.com/unixwinbsd/unixbsdshell.github.io/refs/heads/main/img/nop-25/nop-25-022.jpg' | absolute_url }}">


The original DNS did not include strong authentication factors. After all, this protocol originated in the days when the Internet was a relatively small research network with a high level of trust among users. Without security features in the DNS system, attackers could easily trick DNS clients into interacting with unauthorized sites.

When a DNS query is sent to a server, the resolver simply verifies that the response originates from the IP address to which the request is sent. Because IP addresses are easily spoofed, attackers can impersonate an authoritative name server and send fraudulent DNS records.

Spoofed responses can also affect multiple users. Most recursive name servers cache responses. This allows for faster responses to requests than contacting the originating name server for each lookup. However, attackers can cause cache poisoning by placing one or more fraudulent entries in the cache.

<script type="text/javascript">
	atOptions = {
		'key' : '88e2ead0fd62d24dc3871c471a86374c',
		'format' : 'iframe',
		'height' : 250,
		'width' : 300,
		'params' : {}
	};
</script>
<script type="text/javascript" src="//www.highperformanceformat.com/88e2ead0fd62d24dc3871c471a86374c/invoke.js"></script>

## B. NSD Configuration

Unlike unbound, which resolves outbound queries for domain name resolution, nsd is an authoritative name server, which maintains its own DNS records. An NSD server will respond to incoming queries for its own zone names. Therefore, it's highly recommended that you configure both a primary and secondary nameserver so that if one of them becomes unreachable, your zone requests will still be accepted.

To begin configuring DNSSEC on OpenBSD, you must first `install NSD`. Follow the steps below:

```yml
ns1# pkg_add -Uu
ns1# pkg_add nsd
```

Once you've installed NSD on OpenBSD, you can check the NSD version. This check also allows you to see if the NSD server is running.

```yml
ns1# nsd -v
```

Once you are sure that the NSD server is running, you can proceed with enabling NSD in OpennBSD.

```yml
ns1# rcctl enable nsd
ns1# rcctl start nsd
```

First, edit the configuration file at `/var/nsd/etc/nsd.conf` to add the master zone record as shown (replace with your server's details).

```console
server:
        hide-version: yes
        verbosity: 1
        database: "" # disable database
        ip-address: "NSD_SERVER_IP"

remote-control:
        control-enable: yes
        control-interface: /var/run/nsd.sock
        #zonesdir: "/var/nsd/zones/"

key:
        name: "sec_key"
        algorithm: hmac-sha256
        secret: "bWVrbWl0YXNkaWdvYXQ="

zone:
        name: "jessebarton.xyz"
        zonefile: "forward/jessebarton.xyz.forward"
        #notify: DNS_IP@53 sec_key
        #provide-xfr: DNS_IP sec_key

zone:
        name: "0.0.10.in-addr.arpa"
        zonefile: "reverse/jessebarton.xyz.reverse"
        #allow-notify: DNS_IP@53 sec_key
        #provide-xfr: DNS_IP sec_key
```

## C. PF Firewall Settings

We need to adjust the PF Firewall by opening port 53 so it can receive Name Server requests.

<br/>

**Example file `/etc/pf.conf`**

```console
# See pf.conf(5) and /etc/examples/pf.conf
    
set skip on lo
    
block return    # block stateless traffic
pass out                # establish keep-state
    
services = "{ 22, 53, 80, 443, 4443 }"
    
pass in proto tcp to port $services
    
pass in proto udp to port 53
    
# By default, do not permit remote connections to X11
block return in on ! lo0 proto tcp to port 6000:6010
    
# Port build user does not need network
block return out log proto {tcp udp} user _pbuild
```

Your final step is to reload the NSD.

```yml
ns1# nsd-control reconfig
```

DNSSEC corrects a major flaw in the original DNS design: it authenticates that each server truly represents what it claims to be. DNSSEC verifies that no one has tampered with zone data.

DNSSEC provides definitive proof that forged hosts and subdomains are absent. Given DNS's critical role in networking, DNSSEC protects not only your name servers but also virtually every application running on your servers.
