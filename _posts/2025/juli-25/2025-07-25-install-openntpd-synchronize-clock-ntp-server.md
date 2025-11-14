---
title: Install OpenBSD OpenNTPD to synchronize the clock with an NTP server.
date: "2025-07-25 08:32:21 +0100"
updated: "2025-07-25 08:32:21 +0100"
id: install-openntpd-synchronize-clock-ntp-server
lang: en
author: Iwan Setiawan
robots: index, follow
categories: openbsd
tags: SysAdmin
background: https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/img/time-synchronization-in-windows.jpg
toc: true
comments: true
published: true
excerpt: However, keep in mind that level isn't always an indicator of accuracy. Typically, third-level servers are used to synchronize user machines. If you don't know the NTP servers in your area, visit pool.ntp.org and select a server in your region.
keywords: openntpd, openbsd, freebsd, ntp, time, server, synchronize, clock, install, configuration
---

The OpenBSD project is renowned for its high security standards and has historically stood the test of time as a highly secure, free UNIX-like operating system. One of OpenBSD's most well-known daemons is OpenNTPD. As part of OpenBSD, OpenNTPD can run on almost any operating system.

OpenNTPD is a daemon that implements the SNTP version 4 and NTP version 3 protocols to synchronize the local system time with a remote NTP server or local time deviation sensor. The OpenNTPD daemon can act as an NTP server for clients compatible with these protocols.

The OpenNTPD application was developed by [Henning Brauer](https://www.henningbrauer.com/) as part of the OpenBSD project. The project's primary goal is to create a time management server that is secure, easy to configure, reasonably accurate, and freely distributable (open source).

## A. Initial Setup
OpenBSD assumes your hardware clock is set to UTC (Universal Coordinated Time), not local time. This can cause problems with [multi-booting](https://openbsd-ru.github.io/faq/faq4.html#Multibooting). Most other operating systems can be configured in the same way as OpenBSD to avoid this problem.

If using UTC causes problems, you can always change the settings in [sysctl.conf](https://man.openbsd.org/sysctl.conf). For example, add the following line to `/etc/sysctl.conf` to configure OpenBSD to use the hardware clock set to local time or another region's time.

```console
kern.utc_offset=-300
```
Harap perhatikan bahwa jam pada server OpenBSD harus berjalan dengan konfigurasi di atas dan offset yang diperlukan sebelum mem-boot OpenBSD, jika tidak, waktu sistem akan ditetapkan secara tidak benar pada saat proses boot dilakukan.

The time zone is typically set during installation. If you need to change the time zone, you can create a new symbolic link to the appropriate time zone file in [/usr/share/zoneinfo](https://man.openbsd.org/date). For example, to configure the machine to use the Western Indonesian time zone as the new local time zone on your OpenBSD server.

```console
ns2# ln -fs /usr/share/zoneinfo/Asia/Jakarta /etc/localtime
```

## B. OpenNTPD Configuration
Because OpenNTP is a daemon created by the OpenBSD developers, you don't need to install it. OpenNTPD is pre-installed on your OpenBSD system. You only need to configure it.

On OpenBSD, the main OpenNTPD configuration file is located at `/etc/ntpd.conf`. The first line in your `/etc/ntpd.conf` file defines the interface connected to the internet. When you talk about interfaces, you inevitably include IP addresses.

Next, you define the servers you want to synchronize with. NTP uses a hierarchical system of `"clock levels"`. Level 1 synchronizes with high-precision clocks, such as GPS, GLONASS, or atomic time standards. Level 2 synchronizes with one of the level 1 machines, and so on.

However, keep in mind that level isn't always an indicator of accuracy. Typically, third-level servers are used to synchronize user machines. If you don't know the NTP servers in your area, visit pool.ntp.org and select a server in your region.

Below is an example of a `/etc/ntpd.conf` script that you can try.

```console
# $OpenBSD: ntpd.conf,v 1.5 2019/11/11 16:44:37 deraadt Exp $
# sample ntpd configuration file, see ntpd.conf(5)

# Addresses to listen on (ntpd does not listen by default)
listen on 192.168.5.3

# sync to a single server
#server ntp.example.org

# use a random selection of NTP Pool Time Servers
# see http://support.ntp.org/bin/view/Servers/NTPPoolServers
servers pool.ntp.org

# time server with excellent global adjacency
server time.cloudflare.com
servers pool.ntp.org
server time.cloudflare.com
server time.windows.com
server time.nist.gov

# use a specific local timedelta sensor (radio clock, etc)
sensor *

# use all detected timedelta sensors
#sensor *

# get the time constraint from a well-known HTTPS site
constraint from "9.9.9.9"		# quad9 v4 without DNS
constraint from "2620:fe::fe"		# quad9 v6 without DNS
constraints from "www.google.com"	# intentionally not 8.8.8.8
```

You can replace the IP address 192.168.5.3 with the IP address of the OpenBSD server currently running.

## C. Enabling OpenNTPD

Although the OpenNTPD daemon is installed by default on OpenBSD systems, it isn't automatically activated. In this section, we'll enable OpenNTPD every time the server reboots.

To enable OpenNTPD, open the `/etc/rc.conf` file and add a script like the example below.

```console
ntpd_flags="-s"
ntpctl_flags="-s"
```

After that you run the command below.

```console
ns2# rcctl restart ntpd
```

Also run the following command, to ensure the OpenNTPD daemon is active.

```console
ns2#  ntpd -dnv
configuration OK
ns2# ntpd -f /etc/ntpd.conf
ntpd: ntpd already running
```

## D. Monitoring OpenNTPD

Once the OpenNTPD daemon is synchronized and running normally, you can monitor time server activity with the following command.

```console
ns2# ntpctl -s all
ns2# ntpctl -s peers
ns2# ntpctl -s Sensors
ns2# ntpctl -s status
```

If your Windows computer is an hour behind when synchronizing, make sure it's taking Daylight Savings Time into account. In Control Panel, double-click `Date and Time`, then click the `Time Zone` tab. Ensure "Automatically adjust clock for daylight savings changes" is checked.

<br/>
<img alt="time synchronization in windows" width="99%" class="lazyload" style="display: block; margin: auto;" src="{{ 'https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/img/time-synchronization-in-windows.jpg' | relative_url }}">
<br/>

To get a fairly accurate current time reading from the US Naval Observatory, **see:** `http://tycho.usno.navy.mil/cgi-bin/timer.pl`.