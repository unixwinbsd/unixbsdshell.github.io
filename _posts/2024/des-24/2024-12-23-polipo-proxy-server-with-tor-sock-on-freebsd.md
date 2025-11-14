---
title: POLIPO As A Proxy Server With TOR SOCKS On FreeBSD
date: "2024-12-23 09:55:41 +0100"
updated: "2024-12-23 09:55:41 +0100"
id: polipo-proxy-server-with-tor-sock-on-freebsd
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: Anonymous
background: https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/img/Polipo-proxy-server.jpg
toc: true
comments: true
published: true
excerpt: Proxy servers using Polipo on the FreeBSD operating system can block websites deemed inappropriate. By caching on disk, the Polipo proxy server is fast, lightweight, and small, making it particularly useful for networks that lack a large proxy server.
keywords: polipo, proxy, server, tor, sock, sock5, port, freebsd, http
---

Polipo is a lightweight caching and forwarding web proxy server. Polipo has a variety of uses, from enhancing security by filtering traffic to web browser caching and other computer network browsing. Polipo is a single-threaded web proxy with very powerful web caching capabilities. Polipo is designed for groups of people sharing internet resources, accelerating web server speed by caching repeated requests.

Proxy servers using Polipo on the FreeBSD operating system can block websites deemed inappropriate. By caching on disk, the Polipo proxy server is fast, lightweight, and small, making it particularly useful for networks that lack a large proxy server.

<br/>
<img alt="polipo proxy server" width="99%" class="lazyload" style="display: block; margin: auto;" src="{{ 'https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/img/Polipo-proxy-server.jpg' | relative_url }}">
<br/>


To install Polipo on FreeBSD, you'll need a FreeBSD server that hosts the Polipo repository. In this tutorial, the system specifications used are:

## A. System Specifications

- OS: FreeBSD 13.2-STABLE
- CPU: AMD Phenom II X4 965 3400 MHz
- Memory: 2 gb
- Hard Disk: 40 gb
- IP LAN: 192.168.9.3/24
- IP TOR: 192.168.9.3
- Port TOR: 9050
- IP Polipo: 192.168.9.3
- Hostname: router2
- Domain: unixexplore.com
- Port Polipo: 8118


## B. Install Polipo

In this tutorial, we'll use Polipo as a proxy gateway for Tor. This means we'll use TOR as the backend and Polipo as the frontend. Therefore, every client accessing a web browser will be served by Polipo.

To install TOR, you can read the previous article that covers the TOR installation process on FreeBSD. Let's jump straight into installing and configuring the Polipo application.

The first step is to install the Polipo application via ports or pkg on the FreeBSD server.


```yml
root@router2:~ # cd /usr/ports/www/polipo
root@router2:~ # make install clean
```

If you are using pkg package, you can install polipo by typing the script below.


```yml
root@router2:~ # pkg update -f
root@router2:~ # pkg upgrade -f
```

The above script is used to update and upgrade pkg packages. Once the update process is complete, proceed with the Polipo installation.


```yml
root@router2:~ # pkg install polipo
```

Wait a few minutes for the Polipo installation to complete. Then, we'll continue by enabling Polipo in the rc.conf file, as well as the polipo group and polipo user. Activating Polipo in the rc.conf file will ensure Polipo runs automatically when the server is restarted/booted or shut down.


```yml
root@router2:~ # ee /etc/rc.conf
polipo_enable="YES"
```

Once we've finished running `rc.d`, the next step is to create the Polipo log file. Use the script below to create the Polipo log file.


```yml
root@router2:~ # touch /var/log/polipo
```

In the `/etc/newsyslog.conf` folder, enter the following script.

```yml
root@router2:~ # ee /etc/newsyslog.conf
/var/log/polipo polipo: 640 3 100 * J /var/run/polipo/polipo.pid 30
```

<br/>

```yml
root@router2:~ # chown -R polipo:polipo /usr/local/etc/polipo
root@router2:~ # chown -R polipo:polipo /usr/local/etc/polipo/
root@router2:~ # chown -R polipo:polipo /var/log/polipo
```

After that, create ownership permissions for the configuration file.

```yml
root@router2:~ # cd /usr/local/etc/polipo
root@router2:~ # chmod +w config
```

The next step is to edit the configuration file in the `/usr/local/etc/polipo` folder. This can be done using Putty or Winscp. Editing the configuration file is easier remotely using Winscp.

```yml
root@router2:/usr/local/etc/polipo # cd /usr/local/etc/polipo
root@router2:~ # ee config
```

Edit the `"config"` file as needed. To enable a script line, remove the **"#"** sign. If there is a **"#"** sign at the beginning of a script line, it means the script is disabled.

What you need to enable in the configuration file is:

```yml
proxyAddress = "192.168.9.3"

allowedClients = 192.168.9.0/24, 127.0.0.1

proxyName = "router2.unixexplore.com"

socksParentProxy = "192.168.9.3:9050"

socksProxyType = socks5

cacheIsShared = false

diskCacheRoot = ""
```


After that you restart Polipo.

```yml
root@router2:~ # service polipo restart
Stopping polipo.
Starting polipo.
root@router2:~ #
```

When editing the configuration file, pay attention to the socksParentProxy and socksProxyType scripts. IP 127.0.01 and Port 9050 are the IP and Port values ​​in the TOR program's torrc file in /usr/local/etc/tor. This means Polipo forwards the IP and port to TOR. Meanwhile, socksProxyType = socks5 is the socket value from the TOR program's torrc file. This means Polipo's socket is forwarded to TOR's socket, making TOR the backend for Polipo.

Now let's test it in a web browser, for example, Google Chrome. In the settings menu, select network settings. See the image below.

<br/>
<img alt="Polipo IP settings on Windows" width="99%" class="lazyload" style="display: block; margin: auto;" src="{{ 'https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/img/PolipoIPsettingsonWindows.jpg' | relative_url }}">
<br/>


Let's see if Polipo's port 8118 is open.

```yml
root@router2:~ # sockstat -4 | grep polipo
polipo   polipo     651   4  tcp4   192.168.9.3:8118      *:*
root@router2:~ #
```

The command above clearly shows that port 8118 is open on the IP address 192.168.9.3. This indicates that the Polipo program is running.

Below is the complete script for the Polipo program configuration file.

```console
# Sample configuration file for Polipo. -*-sh-*-

# You should not need to use a configuration file; all configuration
# variables have reasonable defaults.  If you want to use one, you
# can copy this to /etc/polipo/config or to ~/.polipo and modify.

# This file only contains some of the configuration variables; see the
# list given by ``polipo -v'' and the manual for more.


### Basic configuration
### *******************

# Uncomment one of these if you want to allow remote clients to
# connect:

# proxyAddress = "::0"        # both IPv4 and IPv6
proxyAddress = "192.168.9.3"    # IPv4 only
proxyPort = 8118

# If you do that, you'll want to restrict the set of hosts allowed to
# connect:

# allowedClients = 127.0.0.1, 134.157.168.57
 allowedClients = 192.168.9.0/24, 127.0.0.1

# Uncomment this if you want your Polipo to identify itself by
# something else than the host name:

proxyName = "router2.unixexplore.com"

# Uncomment this if there's only one user using this instance of Polipo:

cacheIsShared = false

# Uncomment this if you want to use a parent proxy:

# parentProxy = "squid.example.org:3128"

# Uncomment this if you want to use a parent SOCKS proxy:

socksParentProxy = "192.168.9.3:9050"
socksProxyType = socks5

# Uncomment this if you want to scrub private information from the log:

# scrubLogs = true


### Memory
### ******

# Uncomment this if you want Polipo to use a ridiculously small amount
# of memory (a hundred C-64 worth or so):

chunkHighMark = 819200
objectHighMark = 128

# Uncomment this if you've got plenty of memory:

# chunkHighMark = 50331648
# objectHighMark = 16384

# Access rights for new cache files.
diskCacheFilePermissions=0640
# Access rights for new directories.
diskCacheDirectoryPermissions=0750


### On-disk data
### ************

# Uncomment this if you want to disable the on-disk cache:

diskCacheRoot = ""

# Uncomment this if you want to put the on-disk cache in a
# non-standard location:

# diskCacheRoot = "~/.polipo-cache/"

# Uncomment this if you want to disable the local web server:

localDocumentRoot = ""

# Uncomment this if you want to enable the pages under /polipo/index?
# and /polipo/servers?.  This is a serious privacy leak if your proxy
# is shared.

# disableIndexing = false
# disableServersList = false


### Domain Name System
### ******************

# Uncomment this if you want to contact IPv4 hosts only (and make DNS
# queries somewhat faster):

# dnsQueryIPv6 = no

# Uncomment this if you want Polipo to prefer IPv4 to IPv6 for
# double-stack hosts:

# dnsQueryIPv6 = reluctantly

# Uncomment this to disable Polipo's DNS resolver and use the system's
# default resolver instead.  If you do that, Polipo will freeze during
# every DNS query:

# dnsUseGethostbyname = yes


### HTTP
### ****

# Uncomment this if you want to enable detection of proxy loops.
# This will cause your hostname (or whatever you put into proxyName
# above) to be included in every request:

# disableVia=false

# Uncomment this if you want to slightly reduce the amount of
# information that you leak about yourself:

# censoredHeaders = from, accept-language
censorReferer = maybe

# Uncomment this if you're paranoid.  This will break a lot of sites,
# though:

# censoredHeaders = set-cookie, cookie, cookie2, from, accept-language
# censorReferer = true

# Uncomment this if you want to use Poor Man's Multiplexing; increase
# the sizes if you're on a fast line.  They should each amount to a few
# seconds' worth of transfer; if pmmSize is small, you'll want
# pmmFirstSize to be larger.

# Note that PMM is somewhat unreliable.

# pmmFirstSize = 16384
# pmmSize = 8192

# Uncomment this if your user-agent does something reasonable with
# Warning headers (most don't):

# relaxTransparency = maybe

# Uncomment this if you never want to revalidate instances for which
# data is available (this is not a good idea):

# relaxTransparency = yes

# Uncomment this if you have no network:

# proxyOffline = yes

# Uncomment this if you want to avoid revalidating instances with a
# Vary header (this is not a good idea):

# mindlesslyCacheVary = true

# Uncomment this if you want to add a no-transform directive to all
# outgoing requests.

# alwaysAddNoTransform = true
```

By following this tutorial you will improve your computer's security system, especially security on port 80.