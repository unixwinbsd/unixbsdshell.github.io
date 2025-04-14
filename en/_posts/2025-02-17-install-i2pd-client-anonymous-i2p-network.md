---
title: How to Install i2pd on OpenBSD - Client For Anonymous I2P Network
date: "2025-02-17 09:11:39 +0100"
id: install-i2pd-client-anonymous-i2p-network
lang: en
layout: single
author_profile: true
categories:
  - OpenBSD
tags: "Anonymous"
excerpt: I2pd or i2p daemon is a C++ based open source i2p client. It is an anonymous network layer where communication is encrypted and user IP addresses are not disclosed.
keywords: i2p, routing, i2pd, protocol, openbsd, unix, daemon, client, tor, anonymous, freebsd
---
Security is very important in this digital age. Network protocols like Invisible Internet Protocol or I2P, a network layer that allows you to remain anonymous on the Internet. With I2P, your request passes through several network computer nodes. This makes it difficult to track the original user and helps maintain anonymity. Because of I2P sometimes you can also access government censored sites anonymously.

I2pd or i2p daemon is an open source i2p client based on C++. It is an anonymous network layer where communication is encrypted and the user's IP address is not revealed. Started in 2014 by the [PURPRLEI2P](https://github.com/PurpleI2P/i2pd) team and first released in 2015. This technology is designed to be more secure, reliable and perform better than I2P.

In the previous article, we have written about [I2P running on the OpenBSD system](https://penaadventure.com/en/openbsd/2025/02/16/how-to-install-i2p-routing-protocol/). You may ask, what is the difference between I2P and I2PD. Well, to clarify the discussion above, we will try to explain between I2P and I2PD.

[I2P](https://github.com/openbsd/ports/blob/master/net/i2p/pkg/DESCR) is an anonymous overlay network, a network within a network. It is intended to protect communications from surveillance and monitoring by third parties such as ISPs. I2P is used by many people who care about their privacy: activists, oppressed people, journalists and whistleblowers, and ordinary people. No network can be “truly anonymous.” The ongoing goal of I2P is to make attacks increasingly difficult. Its anonymity will only get stronger as the network grows in size and with continued academic review.

Meanwhile, [I2PD](https://github.com/openbsd/ports/blob/master/net/i2p/pkg/DESCR) is a full-featured client for the I2P network written in C++. I2P (Invisible Internet Project) is a universal anonymous network layer. All communication over I2P is anonymous and end-to-end encrypted. Participants do not reveal their real IP addresses to each other. Both peer-to-peer (cryptocurrency, file sharing) and client-to-server (websites, instant messengers, chat servers) applications are supported.

## System Specifications
root@ns2.datainchi.com
OS: OpenBSD 7.6 amd64
Host: Acer Aspire M1800
Uptime: 8 mins
Packages: 42 (pkg_info)
Shell: ksh v5.2.14 99/07/13.2
Terminal: /dev/ttyp0
CPU: Intel Core 2 Duo E8400 (2) @ 3.000GHz
Memory: 35MiB / 1775MiB
IP Address: 192.168.5.3
Versi I2PD: i2pd-2.53.1p0
Versi I2P: i2p-2.6.1

## 2. i2pd Installation Process
After you know a little about i2pd and the system used, we will go straight to installing i2pd. Oops.... wait, before you install i2pd, there are some dependencies that you must install first.

### a. I2P Installation Guide
The first dependency you have to install is I2P. In this article we will not explain how to install I2P on OpenBSD. Just read the installation process [in the previous article](https://penaadventure.com/en/openbsd/2025/02/16/how-to-install-i2p-routing-protocol/).

### b. Install cmake boost miniupnpc
The next dependency you need to install is cmake boost miniupnpc.

```
ns2# pkg_add cmake boost miniupnpc
```

### c. Install I2PD
After all the above dependencies have been installed, we continue by installing i2pd.

```
ns2# pkg_add i2pd
```


