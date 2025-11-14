---
title: Guide to Installing TOR Network on OpenBSD
date: "2025-11-01 08:26:22 +0100"
updated: "2025-11-01 08:26:22 +0100"
id: guide-to-installing-tor-network-on-openbsd
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: DataBase
background: https://raw.githubusercontent.com/unixwinbsd/unixbsdshell.github.io/refs/heads/main/img/nop-25/tor-network.jpg
toc: true
comments: true
published: true
excerpt: OpenBSD offers two default TOR installation methods the PKG package and OpenBSD Ports. These two methods are nearly identical to those found in OpenBSD.
keywords: openbsd, freebsd, tor, onion, network, anonymous, hiden, installing, guide
---

OpenBSD is a Unix-derived operating system focused on security and standards compliance. It is considered one of the most secure systems available. With its default installation, OpenBSD can install a variety of applications very easily and quickly.

Similarly, with the help of the OpenBSD PKG package, the TOR application can be installed in just minutes. In this article, we will attempt to explain in detail the process of [installing TOR on OpenBSD](https://pestilenz.org/~bauerm/tor-openbsd-howto.html).

## A. System Specifications

To create this article, we used a computer that doesn't have high specifications. The computer specifications are as follows:

- OS: OpenBSD 7.6 amd64
- IP Address: 192.168.5.3
- Host: Acer Aspire M1800
- Uptime: 3 mins
- Packages: 95 (pkg_info)
- Shell: ksh v5.2.14 99/07/13.2
- Terminal: /dev/ttyp0
- CPU: Intel Core 2 Duo E8400 (2) @ 3.0
- Memory: 208MiB / 1775MiB

<br/>
<img alt="Diagram Tor Network On OpenBSD" width="99%" class="lazyload" style="display: block; margin: auto;" src="{{ 'https://raw.githubusercontent.com/unixwinbsd/unixbsdshell.github.io/refs/heads/main/img/nop-25/tor-network.jpg' | relative_url }}">
<br/>

## B. About TOR

The Tor Project is an intelligence solution developed by the US Navy to protect US intelligence communications online. However, today, the project continues to function as a non-profit, open-source organization promoting online privacy and open to the public. If you're not sure what the term [open source](https://opensource.com/resources/what-open-source) means, here's what it means.

Open source means that all of the project's source code is publicly shared. Because all of a project's source code is openly shared, the project can be developed more quickly by many volunteers, ensuring no malicious code is present. In short, if a project is open source, it is under everyone's control.

Tor's development began in the mid-1990s when the US Naval Research Laboratory began experimenting with anonymity networks to protect government communications. Researchers `Paul Syverson, Michael G. Reed, and David Goldschlag` developed onion routing, a technique designed to conceal the origin and destination of online communications by wrapping data in multiple layers of encryption.

This technology was originally intended for secure intelligence operations and protecting the identities of government officials online.

In the early 2000s, the US government released onion routing technology to the public to help maintain anonymity not only for government officials but also for journalists, human rights activists, and everyday internet users. In 2002, The Onion Routing Project, or Tor Project, was officially founded to advance and maintain this technology.

Tor is fundamentally based on the principle of obfuscation. To better understand how it works and see what kind of system we're actually relying on, let's start by discussing its general structure. To anonymize users, three of approximately 6,500 volunteer servers are randomly selected.

These selected servers are called nodes. When connected to the Tor network, data packets are encrypted and sent through these three nodes to the target server. The server's response packets are similarly encrypted and sent back to the user, through the three nodes. In this way, all traffic between the website and you is anonymized.

## C. TOR Installation Process on OpenBSD

OpenBSD offers two default TOR installation methods: the PKG package and OpenBSD Ports. These two methods are almost identical to those used in FreeBSD. Both methods serve the same purpose: to install TOR.

### c.1. Install TOR with the PKG Package

In this section, we will explain how to install TOR with the PKG package. This method is very easy and is widely preferred by OpenBSD users.

```yml
ns5# pkg_add -uvi
ns5# pkg_add tor
```

**WARNING:** If you omit the export TORDIR, the following commands will fail or damage your system seriously, because they are executed as root on the root-directory / .

### c.2. Install TOR with OpenBSD Ports

This second method is rarely used by OpenBSD users. It's not only impractical but also very slow to install. However, if you install an application with OpenBSD Ports, all the dependencies required by the application are also installed. Therefore, installing with Ports is generally recommended over the PKG package.

```yml
ns5# cd /usr/ports/net/tor
ns5# make clean=all
ns5# make
ns5# make package
ns5# make install
```

## D. TOR Configuration Process on OpenBSD

After installing TOR, either with the PKG package or Ports, the next step is to configure the TOR application.

### d.1. Edit the /etc/tor/torrc /etc/login.conf and /etc/sysctl.conf files

The /etc/tor/torrc file is TOR's main configuration file. You must customize this file for it to run properly. In this article, we will demonstrate several scripts that you must activate (adjust them to your server and needs).

```console
SOCKSPort 192.168.5.3:9050
SOCKSPolicy accept 192.168.5.0/24
Log debug file /var/log/tor/debug.log
RunAsDaemon 1
DataDirectory /var/tor
User _tor
Log notice syslog
```

After that you also have to change the `/etc/login.conf` file.

```console
tor:\
    :openfiles-max=13500:\
    :tc=daemon:
```

Don't forget to type the following script in the `/etc/sysctl.conf` file.

```yml
kern.maxfiles=16000
```
<br/>
### d.2. Create a Log File

Log files are essential for monitoring TOR activity. The commands below are a guide to creating a TOR log file.

```yml
ns5# mkdir -p /var/log/tor
ns5# touch /var/log/tor/debug.log
ns5# chown -R _tor:_tor /var/log/tor
```
<br/>
### d.3. Activate and Run TOR

Once everything has been configured according to the instructions above, you can immediately activate and run TOR.

```yml
ns5# rcctl enable tor
ns5# rcctl restart tor
```

## E. Check TOR

This step is crucial and the one you've been waiting for the most. It will determine whether the TOR we've installed and configured is running. To check whether TOR is running, you can use the curl command, as shown in the example below.

```console
ns5# curl \
      -x socks5h://192.168.5.3:9050 \
      -s https://check.torproject.org/api/ip
{"IsTor":true,"IP":"45.141.215.88"}
```

In the test results above, the IP address `"45.141.215.88"` is the TOR Project IP address. You can also replace the address `https://check.torproject.org/api/ip` with another address, as in the example below.

```console
ns5# curl \
      -x socks5h://192.168.5.3:9050 \
      -s https://unixwinbsd.site
```

If the results are as shown in the example above, it means your TOR is active on the OpenBSD server. You can use [TOR](https://torbsd.github.io/blog.html) in conjunction with other applications, such as a proxy or other services.