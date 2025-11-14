---
title: How to Install i2pd on OpenBSD - Client For Anonymous I2P Network
date: "2025-02-17 09:11:39 +0100"
updated: "2025-07-29 16:25:12 +0100"
id: install-i2pd-client-anonymous-i2p-network
lang: en
author: Iwan Setiawan
robots: index, follow
categories: openbsd
tags: Anonymous
background: https://www.opencode.net/unixbsdshell/balena-etcher-portable-173/-/raw/main/Dashboard_i2pd.jpg
toc: true
comments: true
published: true
excerpt: I2pd or i2p daemon is a C++ based open source i2p client. It is an anonymous network layer where communication is encrypted and user IP addresses are not disclosed.
keywords: i2p, routing, i2pd, protocol, openbsd, unix, daemon, client, tor, anonymous, freebsd
---

Security is very important in this digital age. Network protocols like Invisible Internet Protocol or I2P, a network layer that allows you to remain anonymous on the Internet. With I2P, your request passes through several network computer nodes. This makes it difficult to track the original user and helps maintain anonymity. Because of I2P sometimes you can also access government censored sites anonymously.

I2pd or i2p daemon is an open source i2p client based on C++. It is an anonymous network layer where communication is encrypted and the user's IP address is not revealed. Started in 2014 by the [PURPRLEI2P](https://github.com/PurpleI2P/i2pd) team and first released in 2015. This technology is designed to be more secure, reliable and perform better than I2P.

In the previous article, we have written about [I2P running on the OpenBSD system](https://unixwinbsd.site/openbsd/how-to-install-i2p-routing-protocol/). You may ask, what is the difference between I2P and I2PD. Well, to clarify the discussion above, we will try to explain between I2P and I2PD.

[I2P](https://github.com/openbsd/ports/blob/master/net/i2p/pkg/DESCR) is an anonymous overlay network, a network within a network. It is intended to protect communications from surveillance and monitoring by third parties such as ISPs. I2P is used by many people who care about their privacy: activists, oppressed people, journalists and whistleblowers, and ordinary people. No network can be “truly anonymous.” The ongoing goal of I2P is to make attacks increasingly difficult. Its anonymity will only get stronger as the network grows in size and with continued academic review.

Meanwhile, [I2PD](https://github.com/openbsd/ports/blob/master/net/i2p/pkg/DESCR) is a full-featured client for the I2P network written in C++. I2P (Invisible Internet Project) is a universal anonymous network layer. All communication over I2P is anonymous and end-to-end encrypted. Participants do not reveal their real IP addresses to each other. Both peer-to-peer (cryptocurrency, file sharing) and client-to-server (websites, instant messengers, chat servers) applications are supported.

## 1. System Specifications
<br/>
> Hostname: ns2
> OS: OpenBSD 7.6 amd64   
> Host: Acer Aspire M1800    
> Shell: ksh v5.2.14 99/07/13.2    
> Terminal: /dev/ttyp0    
> CPU: Intel Core 2 Duo E8400 (2) @ 3.000GHz    
> Memory: 35MiB / 1775MiB   
> IP Address: 192.168.5.3   
> Versi I2PD: i2pd-2.53.1p0   
> Versi I2P: i2p-2.6.1   

## 2. i2pd Installation Process

After you know a little about i2pd and the system used, we will go straight to installing i2pd. Oops.... wait, before you install i2pd, there are some dependencies that you must install first.

### a. I2P Installation Guide

The first dependency you have to install is I2P. In this article we will not explain how to install I2P on OpenBSD. Just read the installation process [in the previous article](https://unixwinbsd.site/openbsd/how-to-install-i2p-routing-protocol/).

### b. Install cmake boost miniupnpc

The next dependency you need to install is cmake boost miniupnpc.

```console
ns2# pkg_add cmake boost miniupnpc
```

<br/>
### c. Install I2PD

After all the above dependencies have been installed, we continue by installing i2pd.

```console
ns2# pkg_add i2pd
```

## 3. i2pd Configuration Process

This part is a very important part, because we will tinker with the i2pd file so that it can run on the OpenBSD server. The main i2pd configuration file is located at **"/etc/i2pd/i2pd.conf"**. Please open the file and change it according to your OpenBSD system needs or specifications. To make it easier, just follow the guide below.

> /etc/i2pd/i2pd.conf

<br/>
```console
## Configuration file for a typical i2pd user
## See https://i2pd.readthedocs.io/en/latest/user-guide/configuration/
## for more options you can use in this file.

## Lines that begin with "## " try to explain what's going on. Lines
## that begin with just "#" are disabled commands: you can enable them
## by removing the "#" symbol.

## Tunnels config file
## Default: ~/.i2pd/tunnels.conf or /var/lib/i2pd/tunnels.conf
# tunconf = /var/lib/i2pd/tunnels.conf

## Tunnels config files path
## Use that path to store separated tunnels in different config files.
## Default: ~/.i2pd/tunnels.d or /var/lib/i2pd/tunnels.d
# tunnelsdir = /var/lib/i2pd/tunnels.d

## Path to certificates used for verifying .su3, families
## Default: ~/.i2pd/certificates or /var/lib/i2pd/certificates
# certsdir = /var/lib/i2pd/certificates

## Where to write pidfile (default: /run/i2pd.pid, not used in Windows)
# pidfile = /run/i2pd.pid

## Logging configuration section
## By default logs go to stdout with level 'info' and higher
## For Windows OS by default logs go to file with level 'warn' and higher
##
## Logs destination (valid values: stdout, file, syslog)
##  * stdout - print log entries to stdout
##  * file - log entries to a file
##  * syslog - use syslog, see man 3 syslog
# log = file
## Path to logfile (default: autodetect)
# logfile = /var/log/i2pd/i2pd.log
## Log messages above this level (debug, info, *warn, error, critical, none)
## If you set it to none, logging will be disabled
# loglevel = warn
## Write full CLF-formatted date and time to log (default: write only time)
# logclftime = true

## Daemon mode. Router will go to background after start. Ignored on Windows
## (default: true)
daemon = true

## Specify a family, router belongs to (default - none)
# family =

## Network interface to bind to
## Updates address4/6 options if they are not set
# ifname =
## You can specify different interfaces for IPv4 and IPv6
# ifname4 =
# ifname6 =

## Local address to bind transport sockets to
## Overrides host option if:
## For ipv4: if ipv4 = true and nat = false
## For ipv6: if 'host' is not set or ipv4 = true
# address4 =
# address6 =

## External IPv4 or IPv6 address to listen for connections
## By default i2pd sets IP automatically
## Sets published NTCP2v4/SSUv4 address to 'host' value if nat = true
## Sets published NTCP2v6/SSUv6 address to 'host' value if ipv4 = false
# host = 1.2.3.4

## Port to listen for connections
## By default i2pd picks random port. You MUST pick a random number too,
## don't just uncomment this
port = 4567

## Enable communication through ipv4 (default: true)
ipv4 = true
## Enable communication through ipv6 (default: false)
ipv6 = false

## Bandwidth configuration
## L limit bandwidth to 32 KB/sec, O - to 256 KB/sec, P - to 2048 KB/sec,
## X - unlimited
## Default is L (regular node) and X if floodfill mode enabled.
## If you want to share more bandwidth without floodfill mode, uncomment
## that line and adjust value to your possibilities. Value can be set to
## integer in kilobytes, it will apply that limit and flag will be used
## from next upper limit (example: if you set 4096 flag will be X, but real
## limit will be 4096 KB/s). Same can be done when floodfill mode is used,
## but keep in mind that low values may be negatively evaluated by Java
## router algorithms.
# bandwidth = L
## Max % of bandwidth limit for transit. 0-100 (default: 100)
# share = 100

## Router will not accept transit tunnels, disabling transit traffic completely
## (default: false)
# notransit = true

## Router will be floodfill (default: false)
## Note: that mode uses much more network connections and CPU!
# floodfill = true

[ntcp2]
## Enable NTCP2 transport (default: true)
# enabled = true
## Publish address in RouterInfo (default: true)
# published = true
## Port for incoming connections (default is global port option value)
# port = 4567

[ssu2]
## Enable SSU2 transport (default: true)
# enabled = true
## Publish address in RouterInfo (default: true)
# published = true
## Port for incoming connections (default is global port option value)
# port = 4567

[http]
## Web Console settings
## Enable the Web Console (default: true)
enabled = true
## Address and port service will listen on (default: 127.0.0.1:7070)
address = 192.168.5.3
port = 7070
## Path to web console (default: /)
# webroot = /
## Enable Web Console authentication (default: false)
## You should not use Web Console via public networks without additional encryption.
## HTTP authentication is not encryption layer!
# auth = true
# user = i2pd
# pass = changeme
## Select webconsole language
## Currently supported english (default), afrikaans, armenian, chinese, czech, french,
## german, italian, polish, portuguese, russian, spanish, turkish, turkmen, ukrainian
## and uzbek languages
# lang = english

[httpproxy]
## Enable the HTTP proxy (default: true)
enabled = true
## Address and port service will listen on (default: 127.0.0.1:4444)
address = 192.168.5.3
port = 4444
## Optional keys file for proxy local destination (default: http-proxy-keys.dat)
# keys = http-proxy-keys.dat
## Enable address helper for adding .i2p domains with "jump URLs" (default: true)
## You should disable this feature if your i2pd HTTP Proxy is public,
## because anyone could spoof the short domain via addresshelper and forward other users to phishing links
# addresshelper = true
## Address of a proxy server inside I2P, which is used to visit regular Internet
outproxy = http://false.i2p
## httpproxy section also accepts I2CP parameters, like "inbound.length" etc.

[socksproxy]
## Enable the SOCKS proxy (default: true)
# enabled = true
## Address and port service will listen on (default: 127.0.0.1:4447)
address = 192.168.5.3
port = 4447
## Optional keys file for proxy local destination (default: socks-proxy-keys.dat)
# keys = socks-proxy-keys.dat
## Socks outproxy. Example below is set to use Tor for all connections except i2p
## Enable using of SOCKS outproxy (works only with SOCKS4, default: false)
# outproxy.enabled = false
## Address and port of outproxy
outproxy = 192.168.5.3
outproxyport = 9050
## socksproxy section also accepts I2CP parameters, like "inbound.length" etc.

[sam]
## Enable the SAM bridge (default: true)
# enabled = false
## Address and ports service will listen on (default: 127.0.0.1:7656, udp: 7655)
# address = 127.0.0.1
# port = 7656
# portudp = 7655

[bob]
## Enable the BOB command channel (default: false)
# enabled = false
## Address and port service will listen on (default: 127.0.0.1:2827)
# address = 127.0.0.1
# port = 2827

[i2cp]
## Enable the I2CP protocol (default: false)
# enabled = false
## Address and port service will listen on (default: 127.0.0.1:7654)
address = 192.168.5.3
port = 7654

[i2pcontrol]
## Enable the I2PControl protocol (default: false)
# enabled = false
## Address and port service will listen on (default: 127.0.0.1:7650)
address = 192.168.5.3
port = 7650
## Authentication password (default: itoopie)
# password = itoopie

[precomputation]
## Enable or disable elgamal precomputation table
## By default, enabled on i386 hosts
# elgamal = true

[upnp]
## Enable or disable UPnP: automatic port forwarding (enabled by default in WINDOWS, ANDROID)
# enabled = false
## Name i2pd appears in UPnP forwardings list (default: I2Pd)
# name = I2Pd

[meshnets]
## Enable connectivity over the Yggdrasil network  (default: false)
# yggdrasil = false
## You can bind address from your Yggdrasil subnet 300::/64
## The address must first be added to the network interface
# yggaddress =

[reseed]
## Options for bootstrapping into I2P network, aka reseeding
## Enable reseed data verification (default: true)
verify = true
## URLs to request reseed data from, separated by comma
## Default: "mainline" I2P Network reseeds
# urls = https://reseed.i2p-projekt.de/,https://i2p.mooo.com/netDb/,https://netdb.i2p2.no/
## Reseed URLs through the Yggdrasil, separated by comma
# yggurls = http://[324:71e:281a:9ed3::ace]:7070/
## Path to local reseed data file (.su3) for manual reseeding
# file = /path/to/i2pseeds.su3
## or HTTPS URL to reseed from
# file = https://legit-website.com/i2pseeds.su3
## Path to local ZIP file or HTTPS URL to reseed from
# zipfile = /path/to/netDb.zip
## If you run i2pd behind a proxy server, set proxy server for reseeding here
## Should be http://address:port or socks://address:port
# proxy = http://127.0.0.1:8118
## Minimum number of known routers, below which i2pd triggers reseeding (default: 25)
# threshold = 25

[addressbook]
## AddressBook subscription URL for initial setup
## Default: reg.i2p at "mainline" I2P Network
# defaulturl = http://shx5vqsw7usdaunyzr2qmes2fq37oumybpudrd4jjj4e4vk4uusa.b32.i2p/hosts.txt
## Optional subscriptions URLs, separated by comma
# subscriptions = http://reg.i2p/hosts.txt,http://identiguy.i2p/hosts.txt,http://stats.i2p/cgi-bin/newhosts.txt,http://rus.i2p/hosts.txt

[limits]
## Maximum active transit sessions (default: 5000)
## This value is doubled if floodfill mode is enabled!
# transittunnels = 5000
## Limit number of open file descriptors (0 - use system limit)
# openfiles = 0
## Maximum size of corefile in Kb (0 - use system limit)
# coresize = 0

[trust]
## Enable explicit trust options. (default: false)
# enabled = true
## Make direct I2P connections only to routers in specified Family.
# family = MyFamily
## Make direct I2P connections only to routers specified here. Comma separated list of base64 identities.
# routers =
## Should we hide our router from other routers? (default: false)
# hidden = true

[exploratory]
## Exploratory tunnels settings with default values
# inbound.length = 2
# inbound.quantity = 3
# outbound.length = 2
# outbound.quantity = 3

[persist]
## Save peer profiles on disk (default: true)
# profiles = true
## Save full addresses on disk (default: true)
# addressbook = true

[cpuext]
## Use CPU AES-NI instructions set when work with cryptography when available (default: true)
# aesni = true
## Force usage of CPU instructions set, even if they not found (default: false)
## DO NOT TOUCH that option if you really don't know what are you doing!
# force = false
```
<br/>
### a. Enable I2PD
Then we continue by enabling i2pd.

```console
ns2# rcctl enable i2pd
ns2# rcctl restart i2pd
```
<br/>
### b. Creating I2PD Boot

In this section, you can manually start I2Pd, but it will not start automatically
when the system boots. This section explains how to do this. The first thing to do is create a new login class to increase the number of files that I2Pd can open simultaneously.

By default, OpenBSD limits this number to a value that is too low for I2Pd to work properly. Symptoms of too low a number include difficulty connecting to websites and high CPU usage. If you are using OpenBSD 7.5 or later or a newer OpenBSD, simply add the following line to the /etc/login.conf.d/i2pd file to create the login class.

> /etc/login.conf.d/i2pd

<br/>
```yml
i2pd:\
    :openfiles-cur=102400:\
    :openfiles-max=102400:\
    :tc=daemon:
```

<br/>
### c. Running I2PD

After you activate i2pd, we continue by running i2pd. To run i2pd we use the Google Chrome web browser or others. In the address bar menu you type "http://192.168.5.3:7070/".

If you don't miss any of the configurations above, an image like the one below will appear on your monitor screen.

![dashboard i2pd](https://www.opencode.net/unixbsdshell/balena-etcher-portable-173/-/raw/main/Dashboard_i2pd.jpg)

I2PD can be a very useful tool if you want to stay anonymous on the internet and increase your security while browsing. This tool has all the features of I2P and improves on them. It is more secure, cryptographically encrypted, and more performant since it is built in C++. If you have some sites that are censored in your country, I2PD can help you access them anonymously as well.

Therefore, this tool is useful for people like journalists, news agencies, or general users who want privacy. This tool is very flexible and can be used in various applications. We recommend visiting its official website and analyzing the pros and cons of using it. This tool can certainly increase privacy and anonymity, but you should not rely on it. I2PD is still under development and is constantly being updated to improve.


