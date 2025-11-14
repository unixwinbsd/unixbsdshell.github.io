---
title: Static and Dynamic IP Configuration in OpenBSD - Static Dynamic IP Private Public
date: "2025-05-16 07:45:13 +0100"
updated: "2025-05-16 07:45:13 +0100"
id: static-dynamic-ip-address-openbsd
lang: en
author: Iwan Setiawan
robots: index, follow
categories: openbsd
tags: SysAdmin
background: /img/oct-25/static-dynamic-ip-address.jpeg
toc: true
comments: true
published: true
excerpt: Understanding IP addresses is basic material if you want to deepen OpenBSD. Understanding IP addresses in OpenBSD includes the process of configuring static and dynamic IPs.
keywords: ip, static, dynamic, address, ip address, openbsd, netstat, hostname, resolv, hosts
---

Understanding IP addresses is basic material if you want to deepen OpenBSD. Understanding IP addresses in OpenBSD includes the process of configuring static and dynamic IPs. Understanding these two IPs is very important, because you will definitely be faced with problems with these two IPs.

In every server operation, both Linux and BSD, setting static and dynamic IPs is basic and the first thing you do when you want to install a server.

As we know, in a router network there are two IP addresses that are distributed to client computers, namely static and dynamic IPs. These two IPs will be received by the client computer as static or dynamic IPs, depending on the settings made by the admin. You can set static or dynamic IPs on your computer or server, depending on the needs of using the computer or server at that time.

<br/>
{% lazyload data-src="/img/oct-25/static-dynamic-ip-address.jpeg" src="/img/oct-25/static-dynamic-ip-address.jpeg" alt="Static Dynamic IP Private Public" %}
<br/>

## A. System Specifications
- OS OpenBSD: 7.6
- Hostname: ns5
- Domain: kursor.my.id
- IP Address: 192.168.5.3


## B. About Static and Dynamic IP
Both static and dynamic IPs are the same in their use, namely to connect a computer or server to a router network or the internet. However, both have slight differences in use, especially if you are running a server that is used to serve many client computers.

When the internet was first created, its architects did not anticipate the need for an unlimited number of IP addresses. As a result, there were not enough IP numbers for everyone, at least until the advent of IPv6.

To solve this problem, many ISPs limit the number of static IP addresses they allocate and conserve the remaining number of IP addresses by assigning temporary IP addresses to Dynamic Host Configuration Protocol (DHCP) computers that request from the IP address pool. These temporary IP addresses are dynamic IP addresses.

Computers requesting DHCP receive a dynamic IP address, which is similar to a temporary telephone number. For the duration of that internet session or for a specific period of time.

Once the user disconnects from the internet, their dynamic IP address goes back into the IP address pool so it can be assigned to another user. Even if the user reconnects immediately, it is unlikely that they will be assigned the same IP address from the pool.

### b.1. Static IP Address
A static IP address is an IP address that is always the same (does not change). If you have a web server, FTP server, or other Internet resource that must have an address that cannot be changed, you can get a static IP address from your ISP. Static IP addresses are usually more expensive than dynamic IP addresses, and some ISPs do not provide static IP addresses. You must configure a static IP address manually.

### b.2. Dynamic IP Address

The public IP address assigned to most home and business users routers by their ISP is a `dynamic IP address`. On a local network like your home or business, where you use a private IP address, most devices are probably configured for DHCP, meaning they use dynamic IP addresses.

If DHCP is not enabled, each device on your home network will need to manually set up its network information. Dynamic IP address is an IP address that can be used temporarily by the ISP.

If the dynamic address is not used, it can be automatically assigned to another device. Dynamic IP addresses are assigned using DHCP or PPPoE. So the nature of Dynamic IP is always changing its IP address.

## C. How to Configure Dynamic IP on OpenBSD

Before you configure the IP on the OpenBSD server, we recommend that you first check the current IP address. To check the IP address of your OpenBSD server, run the following command.

```yml
ns5# ifconfig
lo0: flags=2008049<UP,LOOPBACK,RUNNING,MULTICAST,LRO> mtu 32768
        index 4 priority 0 llprio 3
        groups: lo
        inet6 ::1 prefixlen 128
        inet6 fe80::1%lo0 prefixlen 64 scopeid 0x4
        inet 127.0.0.1 netmask 0xff000000
rl0: flags=808843<UP,BROADCAST,RUNNING,SIMPLEX,MULTICAST,AUTOCONF4> mtu 1500
        lladdr 00:e0:4c:fb:b2:e8
        index 1 priority 0 llprio 3
        groups: egress
        media: Ethernet autoselect (100baseTX full-duplex)
        status: active
        inet 192.168.5.101 netmask 0xffffff00 broadcast 192.168.5.255
nfe0: flags=8802<BROADCAST,SIMPLEX,MULTICAST> mtu 1500
        lladdr 00:24:21:88:69:24
        index 2 priority 0 llprio 3
        media: Ethernet autoselect (10baseT half-duplex)
        status: no carrier
enc0: flags=0<>
        index 3 priority 0 llprio 3
        groups: enc
        status: active
pflog0: flags=141<UP,RUNNING,PROMISC> mtu 33136
        index 5 priority 0 llprio 3
        groups: pflog
```

From the ifconfig command above, you can read that the OpenBSD server uses 2 ethernet cards, namely `rl0 and nfe0`. However, of the two interfaces, only the `rl0` interface is active with `IP=192.168.5.101`.

After you know the IP address of your OpenBSD server, now we continue by setting a dynamic IP for the OpenBSD server. The method is very easy, you only need to set a few files, including:
- /etc/hostname.namainterface
- /etc/myname

To check the active hostname and interface, use the following command.

```yml
ns5# ls -l /etc/hostname.*
-rw-r-----  1 root  wheel  14 Jan 25 18:38 /etc/hostname.rl0
```

From the command above, only the rl0 interface is active. After we know the active interface, change the script from the **"/etc/hostname.rl0"** file to get a dynamic IP with the script below. (use the text editor "nano").

```yml
ns5# nano /etc/hostname.rl0
inet autoconf
```

The second file you need to change is **"/etc/myname"**. Open the file and type in your server hostname and domain name, as shown in the example below.

```console
ns5# nano /etc/myname
ns5.kursor.my.id
```
To make it more complete, because we will set a dynamic IP, we must also set the **"/etc/resolv.conf"** file and in that file you type the script below.

```console
ns5# nano /etc/resolv.conf
nameserver 1.1.1.1 # resolvd: rl0
nameserver 8.8.8.8 # resolvd: rl0
nameserver 9.9.9.9 # resolvd: rl0
nameserver 8.8.4.4 # resolvd: rl0
lookup file bind
```

Now your OpenBSD server has used dynamic IP obtained from your home internet network router or provider. You can also change the nameserver name as needed.


## D. How to Configure Static IP in OpenBSD
Once you understand how to configure dynamic IP, we continue by configuring static IP in OpenBSD. The method is almost the same, but there is an additional file that you must configure along with the name of the file that you must configure.
- /etc/hostname.namainterface
- /etc/myname
- /etc/mygate

There is an additional file **/etc/mygate**, this file contains a gateway script that connects the OpenBSD server to the router's internet network (Indihome or others).

Configure `/etc/hostname.interfacename` As you know, the name of your OpenBSD server interface is `"rl0"`. Now we change the script file **/etc/hostname.rl0**, as in the example below.

```console
ns5# nano /etc/hostname.rl0
inet 192.168.5.3 0xffffff00
```

Proceed by editing the **/etc/myname** file.

```console
ns5# nano /etc/myname
ns5.kursor.my.id
```

After that we continue by changing the script from the **/etc/mygate** file. If the file does not exist you must create the file first.

```console
ns5# touch /etc/mygate
```

In the `/etc/mygate` file, type the script below.

```console
ns5# nano /etc/mygate
192.168.5.1
```

IP `192.168.5.1` is the gateway IP, which is the IP address of your internet network router. This IP address does not have to be the same, each router is different, depending on the settings.

In the example of this article, our router uses the gateway IP `192.168.5.1`. So you have to adjust it to your router gateway.

As usual, to make the discussion more complete, you have to set the domain name and IP of the OpenBSD server in the **/etc/hosts** file. Pay attention to the example.

```console
ns5# nano /etc/hosts
127.0.0.1	localhost
::1		localhost
192.168.5.3     ns5.kursor.my.id ns5
```

The next step is to configure the **/etc/resolv.conf** file.

```yml
ns5# nano /etc/resolv.conf
nameserver 1.1.1.1 # resolvd: rl0
nameserver 8.8.8.8 # resolvd: rl0
nameserver 9.9.9.9 # resolvd: rl0
nameserver 8.8.4.4 # resolvd: rl0
lookup file bind
```

The last step is to activate all the configurations above, meaning that your OpenBSD server will immediately get the static IP address that you just configured. Run the command below to activate the static IP.

```console
ns5# sh /etc/netstart
```

But to make everything run normally, we recommend that you restart the OpenBSD server with the following command.

```console
ns5# reboot
```

Discussion about dynamic and static IP, we think it is clear enough. Now you can directly try and apply it on your OpenBSD server.

If successful, do not forget all the steps above, because this lesson is very important for an OpenBSD administrator.
