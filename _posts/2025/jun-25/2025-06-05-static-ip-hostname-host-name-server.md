---
title: FreeBSD Static IP Implementation with Hostname Host and Name Server
date: "2025-06-05 15:19:25 +0100"
updated: "2025-06-05 15:19:25 +0100"
id: static-ip-hostname-host-name-server
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: UnixShell
background: /img/Logo.png
toc: true
comments: true
published: true
excerpt: Static IP is an IP that is fixed or does not change. On a local or private network, a static IP is created by a system administrator who has access to the root user. Why root?, because the static IP can only be changed at the root level, admins who log in as guests cannot change the static IP
keywords: static, ip, hostname, host, dynamic, name server, static ip, FreeBSD
---

For those who are new to or have just entered the FreeBSD system, setting up static IPs, Hosts, Hostnames and Nameservers is a basic thing that must be understood. Not only that, for professionals and system administrators, setting up the above is the first thing that must be done if you want to build a server, be it a web server, DHCP server, DNS server and other servers.

In this article, we try to dissect how to use and implement static IP, hosts, hostname and nameservers. The FreeBSD system that we will use in this article uses FreeBSD 13.2 stable.

<br/>

## 🚀 1. Setup Static IP Address

Static IP is an IP that is fixed or does not change. On a local or private network, a static IP is created by a system administrator who has access to the root user. Why root?, because the static IP can only be changed at the root level, admins who log in as guests cannot change the static IP. On the FreeBSD system, to create a static IP, an admin must change the rc.conf file. In the rc.conf file the static IP is configured. The following is how to create a static IP on a FreeBSD system.

```console
root@router2:~ # ee /etc/rc.conf
ifconfig_re0="inet 192.168.9.3 netmask 255.255.255.0"
```

The script above is how to create a Static IP in the `/etc/rc.conf` file. `re0` is the interface or LAN Card name of the FreeBSD server, inet is the Static IP address of the FreeBSD server, in this case we set `192.168.9.3` and the netmask we set `255.255.255.0`.

To view the static IP on the FreeBSD server, use the ifconfig script. Below is an example of what the ifconfig command displays.

```console
root@router2:~ # ifconfig
re0: flags=8843<UP,BROADCAST,RUNNING,SIMPLEX,MULTICAST> metric 0 mtu 1500
        options=8209b<RXCSUM,TXCSUM,VLAN_MTU,VLAN_HWTAGGING,VLAN_HWCSUM,WOL_MAGIC,LINKSTATE>
        ether 6c:62:6d:6c:f6:96
        inet 192.168.9.3 netmask 0xffffff00 broadcast 192.168.9.255
        media: Ethernet autoselect (100baseTX <full-duplex>)
        status: active
        nd6 options=29<PERFORMNUD,IFDISABLED,AUTO_LINKLOCAL>
lo0: flags=8049<UP,LOOPBACK,RUNNING,MULTICAST> metric 0 mtu 16384
        options=680003<RXCSUM,TXCSUM,LINKSTATE,RXCSUM_IPV6,TXCSUM_IPV6>
        inet6 ::1 prefixlen 128
        inet6 fe80::1%lo0 prefixlen 64 scopeid 0x2
        inet 127.0.0.1 netmask 0xff000000
        groups: lo
        nd6 options=21<PERFORMNUD,AUTO_LINKLOCAL>
pflog0: flags=0<> metric 0 mtu 33160
        groups: pflog
pfsync0: flags=0<> metric 0 mtu 1500
        syncpeer: 0.0.0.0 maxupd: 128 defer: off
        syncok: 1
        groups: pfsync
ipfw0: flags=8801<UP,SIMPLEX,MULTICAST> metric 0 mtu 65536
        groups: ipfw
```

Different from static IP, dynamic IP is an IP that is always changing. This IP change is usually managed by the DHCP server. If the IP lease time from the DHCP server expires, the client will request another IP lease from the DHCP server and the IP value may not be the same as the previous IP, depending on the provision from the DHCP server.

On the FreeBSD system we can determine a dynamic IP, the method is almost the same as creating a static IP, namely by changing the `/etc/rc.conf` file. Below is an example of creating a dynamic IP on a FreeBSD server.

```console
root@router2:~ # ee /etc/rc.conf
ifconfig_re0="DHCP"
```

<br/>

## 🚀 2. Hosts dan Hostname

The Hostname is usually determined when the FreeBSD server installation is in progress. When installing the FreeBSD server, in the Network Configuration menu, you are instructed to enter the local/private IP address and hostname.

However, you can change the Hostname by editing the `/etc/rc.conf` file. Here's how to create a Hostname on a FreeBSD system.

```console
root@router2:~ # ee /etc/rc.conf
hostname="router2"
```

The script above explains that our FreeBSD server has the hostname `router2`. This Hostname will later be very useful for creating a Hosts file, because creating a Hosts file combines the hostname and hosts itself.

The Hosts file contains information about the names of hosts on the FreeBSD system. Usually the hosts file is used together with the IP address and hostname. The following is how to write the `/etc/hosts` file on a FreeBSD system.

```
::1            localhost localhost.unixexplore.com
127.0.0.1      localhost localhost.unixexplore.com
192.168.9.3    router2 router2.unixexplore.com
```

Take a look at the script from the hosts file above, `127.0.0.1` has the hostname localhost and the hosts name is `unixexplore.com`. Meanwhile, IP `192.168.9.3` has the hostname router2 with the host name `unixexplore.com`. So it is clear that Hostname and Host have a very close relationship.

<br/>

## 🚀 3. Name Server

If our FreeBSD system wants to connect to the internet network, it needs a name server. If this file is not setup, don't expect to be able to open a web browser. You can see this server name in the `/etc/resolv.conf` file. The `/etc/resolv.conf` file contains the name servers of local or public DNS, this DNS is what will connect our FreeBSD system to the public network or global internet network.

In the `/etc/resolv.conf` file, you can enter as many public DNS names as possible, this is done to anticipate if the first DNS experiences problems. Not only that, the resolv.conf file is also used to define the FreeBSD system domain name as you have set in the `/etc/hosts` file. The following is an example of a script that you can enter in the `/etc/resolv.conf` file.


```
domain unixexplore.com
nameserver 192.168.9.3
nameserver 1.1.1.1
nameserver 1.0.0.1
nameserver 9.9.9.9
nameserver 8.8.8.8
nameserver 8.8.4.4
```

Pay attention to the script above, writing the domain unixexplore.com and nameserver `192.168.9.3` applies if your FreeBSD system has a Private/local DNS server such as Bind or Unbound. If your FreeBSD system does not have Bind or Unbound installed, do not write this script, and instead, enter the following script.

```
search ns1.google.com
nameserver 1.1.1.1
nameserver 1.0.0.1
nameserver 9.9.9.9
nameserver 8.8.8.8
nameserver 8.8.4.4
```

The three discussions above are basic material and you must understand them if you want to become a FreeBSD system administrator. An admin will not be separated from the names IP Address, Host, Hostname and Nameserver. Everything is interrelated and cannot be separated on the FreeBSD system.