---
title: OpenBSD DHCP - Configuring IPv6 with dhcpcd
date: "2025-08-19 11:01:32 +0100"
updated: "2025-08-19 11:01:32 +0100"
id: openbsd-dhcp-configuration-ipv6-with-dhcpd
lang: en
author: Iwan Setiawan
robots: index, follow
categories: openbsd
tags: SysAdmin
background: https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/images/19openbsd_dhcp_ip6.jpg
toc: true
comments: true
published: true
excerpt: PFSense and OPNSense seemed like decent software and I've used both successfully in the past, but this time I wanted to - do it the hard way - and learn about the services that make up a typical router.
keywords: openbsd, dhcp, server, client, router, firewall, ipv4, ipv6, dhcpd, pf, ipfw
---

OpenBSD makes great routers. Its simplicity and ease of configuration make it perfect for network infrastructure applications. Everything you need to build a network of any size is already built into the base system, plus the manual pages and examples cover everything you need to know.

I recently built a home router from scratch using `OpenBSD 7` without installing any additional packages, using only what came with the OpenBSD OS installation. Initially, before deciding to "build it from scratch," I had a goal of building a router using open source software to improve my network security. After exploring several popular open source firewall and routing projects (especially pfSense and OPNSense), I ultimately decided to build my own.

PFSense and OPNSense seemed like decent software (and I've used both successfully in the past), but this time I wanted to "do it the hard way" and learn about the services that make up a typical router. Here are some of the cool DHCP server features OpenBSD has:

- Almost completely open source, down to the BIOS and firmware.
- Every DNS query going out of the network can be encrypted.
- Can cache DNS lookups for each network device, which can improve query speed.
- Supports custom local network DNS entries.

<br/>
<img alt="openbsd dhcp ip6" width="99%" class="lazyload" style="display: block; margin: auto;" src="{{ 'https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/images/19openbsd_dhcp_ip6.jpg' | relative_url }}">
<br/>

This task is very easy in OpenBSD, as it comes with dhcpd on the base system. The OpenBSD project provides excellent documentation for this system under dhcpd(8) for the DHCP server itself, [dhcpd.conf(5)](https://man.openbsd.org/dhcpd.conf.5) for configuration files, and [dhcpd.leases(5)](https://man.openbsd.org/dhcpd.leases.5) for rental database format.

The example we'll cover in this post will be very simple, as it's just for a small home network without any advanced options. I encourage you to read the manual if you want to create your own network, as I may not cover everything you need to know here.

## A. Installation & Configuration

The DHCP server is available by default in the OpenBSD repositories. You can install it directly with the `"pkg_add"` command. Here's how to install a DHCP server on OpenBSD.


```console
ns3# pkg_add isc-dhcp-server isc-bind
```

After that you change the following script.


```console
ns3# nano /etc/rc.d/dhcpcd
daemon_flags="-Mq -C resolv.conf -c /etc/dhcpcd_up.sh"
```

This will prevent `resolv.conf` from being touched and calling our own hook ups.

```console
ns3# nano /etc/dhcpcd_up.sh
route sourceaddr -inet4 192.168.0.1
```

Then you create a `pf.conf` file to improve the security of your DHCP server.

```console
ns3# nano  /etc/pf.conf
# interfaces
lo_if = "lo0"
wan_if = "em0"
prod_if = "em1"
dev_if = "em2"

# cidr ranges
prod_range = "192.168.0.0/24"
dev_range = "192.168.2.0/24"

# setup non-routable address list
# note: since this firewall is behind a local network,
#       do not include the default gateway in the table
table <martians> { 0.0.0.0/8 10.0.0.0/8 127.0.0.0/8 169.254.0.0/16     \
                   172.16.0.0/12 192.0.0.0/24 192.0.2.0/24 224.0.0.0/3 \
                   192.168.0.0/16 198.18.0.0/15 198.51.100.0/24        \
                   203.0.113.0/24 !192.168.0.1 }

# drop blocked traffic
set block-policy drop
# set interface for logging
set loginterface $wan_if
# ignore loopback traffic
set skip on $lo_if

# normalize incoming packets
match in all scrub (no-df random-id max-mss 1460)
# perform NAT
match out on $wan_if inet from !($wan_if:network) to any nat-to ($wan_if:0)

# prevent spoofed traffic
antispoof quick for { $wan_if $prod_if $dev_if }

# block non-routable traffic
block in quick on $wan_if from <martians> to any
block return out quick on $wan_if from any to <martians>

# block all traffic
block all
# allow outgoing traffic
pass out inet
# allow traffic from internal networks
pass in on { $prod_if $dev_if } inet
# block traffic from prod <--> dev
block in on $prod_if from $prod_range to $dev_range
block in on $dev_if from $dev_range to $prod_range
# block outgoing unencrypted dns requests
block proto { TCP UDP } from { $prod_range $dev_range } to any port 53
pass proto { TCP UDP } from { $prod_range $dev_range} to self port 53
```

Next, to perform `NAT` (to make this device a true router), run the following:

```console
ns3# echo 'net.inet.ip.forwarding=1' >> /etc/sysctl.conf
```

Proceed by editing the `"dhcpd.conf"` file.

```console
ns3# nano /etc/dhcpd.conf

# Network:          192.168.0.0/255.255.255.0
# Domain name:      home.local
# Name servers:     192.168.0.23 and 8.8.8.8
# Default router:   192.168.0.1
# Addresses:        192.168.0.30 - 192.168.0.200
#
option  domain-name "home.local";
option  domain-name-servers 192.168.0.23, 8.8.8.8, 1.1.1.1;

# prod network
subnet 192.168.0.0 netmask 255.255.255.0 {
        option routers 192.168.0.1;
        option domain-name-servers 192.168.0.1;
        range 192.168.1.100 192.168.1.149;
        host special-device-1 {
                fixed-address 192.168.0.2;
                hardware ethernet 00:08:22:2c:da:fb;
        }
}
# dev network
subnet 192.168.2.0 netmask 255.255.255.0 {
        option routers 192.168.2.1;
        option domain-name-servers 192.168.2.1;
        range 192.168.2.100 192.168.2.199;
        host special-device-2 {
                fixed-address 192.168.2.2;
                hardware ethernet 18:89:5b:73:62:7f;
        }
}
```

Once you're done with the configuration file, it's time to start the DHCP server. To do this, I first enabled it and then started it using rcctl.

```console
ns3# rcctl enable dhcpd
ns3# rcctl start dhcpd
```

With the server running, to see the leases currently held by dhcpd, you can check `/var/db/dhcpd.leases`. Entries are added to this file when clients make DHCP requests.

So, that's it. At this point, the device functions as a router, firewall, DHCP server, and caching DNS server. The software it runs on is completely open source. It maintains several dedicated DNS entries for services running on my local network. Every outgoing DNS request is guaranteed to be encrypted. For the past few months, I've been using this device on my home network and it's working well. It's secure, performant, minimal, and easy to maintain (only three configuration files).