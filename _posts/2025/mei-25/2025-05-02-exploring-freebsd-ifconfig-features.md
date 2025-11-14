---
title: Exploring IFCONFIG Features On FreeBSD Servers
date: "2025-05-02 09:11:35 +0100"
updated: "2025-05-02 09:11:35 +0100"
id: exploring-freebsd-ifconfig-features
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: SysAdmin
background: /img/Logo.png
toc: true
comments: true
published: true
excerpt: On the FreeBSD operating system or other BSD UNIX-based operating systems such as Linux, DragonflyBSD, GhostBSD, OpenBSD, and others, the command to configure or enable a network interface uses ifconfig
keywords: ifconfig, features, freebsd,  command, shell, server, ip, address, network, land, card, interface
---

Have you ever encountered various network devices on a computer? But have you ever wondered how to enable, disable, or configure the network device on the computer. We only need a few lines of commands typed in the command shell menu to enable, disable, or configure the network interface.

On the FreeBSD operating system or other BSD UNIX-based operating systems such as Linux, DragonflyBSD, GhostBSD, OpenBSD, and others, the command to configure or enable a network interface uses ifconfig.

The ifconfig (interface configuration) command is used to configure a network interface or network interface located in the kernel. ifconfig is used at boot time to set the network interface as needed. In addition, ifconfig is usually used when debugging or when setting up the system. Not only that, the ifconfig command is also used to set the IP address and netmask on the network interface or to enable or disable a specific network interface.

ifconfig is a very necessary utility for a network system administrator. With ifconfig, an administrator can set up a network interface to monitor and perform system maintenance.

## 1. Main Features of ifconfig
1. Displays detailed information about the interface.
2. Sets network (OSI Layer 3) and hardware (OSI Layer 2) addresses.
3. Sets the interface to random capture mode (useful during debugging).
4. Binds to one interface from multiple network addresses.

The following is an example of using the ifconfig command to view the network interface on a computer system.

```
root@ns1:~ # ifconfig
nfe0: flags=8843<UP,BROADCAST,RUNNING,SIMPLEX,MULTICAST> metric 0 mtu 1500
	options=82008<VLAN_MTU,WOL_MAGIC,LINKSTATE>
	ether 00:24:21:88:69:24
	inet 192.168.5.2 netmask 0xffffff00 broadcast 192.168.5.255
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
```

The above “ifconfig” command example displays information such as IP address, subnet mask, and default gateway for all network interfaces.

- **nfe0:** It is a Lan Card or network adapter card used. Lan Card has a MAC address of 00:24:21:88:69:24 and an IP address of 192.168.5.2 netmask 255.255.255.0 with a broadcast of 192.168.5.255.
- **lo0:** It is a loopback network with IP address 127.0.0.1.


## 2. Example of using ifconfig on FreeBSD
### 2.1. Displays all active and inactive interfaces

```
root@ns1:~ # ifconfig -a
```

### 2.2. Displays a specific interface

```
root@ns1:~ # ifconfig nfe0
nfe0: flags=8843<UP,BROADCAST,RUNNING,SIMPLEX,MULTICAST> metric 0 mtu 1500
	options=82008<VLAN_MTU,WOL_MAGIC,LINKSTATE>
	ether 00:24:21:88:69:24
	inet 192.168.5.2 netmask 0xffffff00 broadcast 192.168.5.255
	media: Ethernet autoselect (100baseTX <full-duplex>)
	status: active
	nd6 options=29<PERFORMNUD,IFDISABLED,AUTO_LINKLOCAL>
```


### 2.3. Disabling a Specific Network Interface

```
root@ns1:~ # ifconfig nfe0 down
```

The above script will shutdown the fe0 interface.

### 2.4. Restarting Network Interface
```
root@ns1:~ # ifconfig nfe0 up
```

### 2.5. Enter Netmask and Broadcast Static IP Address
```
root@ns1:~ # ifconfig nfe0 192.168.5.2 netmask 255.255.255.0 broadcast 192.168.5.255
```
### 2.6. Change the Maximum Transmission Unit (MTU) value for nfe0 to 1500
```
root@ns1:~ # ifconfig nfe0 mtu 1500
```

### 2.7. Looking for Other Features on the nfe0 Interface
```
root@ns1:~ # ifconfig -m nfe0
nfe0: flags=8843<UP,BROADCAST,RUNNING,SIMPLEX,MULTICAST> metric 0 mtu 1500
	options=82008<VLAN_MTU,WOL_MAGIC,LINKSTATE>
	capabilities=82008<VLAN_MTU,WOL_MAGIC,LINKSTATE>
	ether 00:24:21:88:69:24
	inet 192.168.5.2 netmask 0xffffff00 broadcast 192.168.5.255
	media: Ethernet autoselect (100baseTX <full-duplex>)
	status: active
	supported media:
		media autoselect mediaopt flowcontrol
		media autoselect
		media 1000baseT mediaopt full-duplex,flowcontrol,master
		media 1000baseT mediaopt full-duplex,flowcontrol
		media 1000baseT mediaopt full-duplex,master
		media 1000baseT mediaopt full-duplex
		media 1000baseT mediaopt master
		media 1000baseT
		media 100baseTX mediaopt full-duplex,flowcontrol
		media 100baseTX mediaopt full-duplex
		media 100baseTX
		media 10baseT/UTP mediaopt full-duplex,flowcontrol
		media 10baseT/UTP mediaopt full-duplex
		media 10baseT/UTP
		media none
	nd6 options=29<PERFORMNUD,IFDISABLED,AUTO_LINKLOCAL>
```
All of the examples above can only be used temporarily. If you want to set the network interface permanently, you can do so by typing the "ifconfig" command in the /etc/rc.conf file. Here is an example.

```
root@ns1:~ # ee /etc/rc.conf
ifconfig_nfe0="inet 192.168.5.2 netmask 255.255.255.0"
defaultrouter="192.168.5.1"
```

To get more complete information about using the "ifconfig" command, you can use the "man utilityname" command. An example is the following "man ifconfig". Type this command in the FreeBSD command shell.
