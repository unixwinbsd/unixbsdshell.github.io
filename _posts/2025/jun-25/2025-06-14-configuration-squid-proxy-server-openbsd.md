---
title: How to Configure Squid Proxy Server on OpenBSD
date: "2025-06-14 07:21:23 +0100"
updated: "2025-06-14 07:21:23 +0100"
id: configuration-squid-proxy-server-openbsd
lang: en
author: Iwan Setiawan
robots: index, follow
categories: openbsd
tags: WebServer
background: https://gitflic.ru/project/unixbsdshell/ruby-static-page-jekyll-rb-openbsd/blob/raw?file=assets/images/34Set%20the%20LAN%20Setting%20menu%20in%20Chrome.jpg&commit=8f48f1f35f95dfa6fd30bc43d6a2921252e8e0e2
toc: true
comments: true
published: true
excerpt: Traditionally, proxy servers are optional components, and browsers are configured to use the Squid server's proxy. A transparently configured Squid proxy means forcing all web traffic through the proxy without the client's cooperation (or knowledge)
keywords: squid, proxy, server, client, cache, openbsd
---

Squid is a web caching proxy software, managed between a web browser and a server. Squid proxies fetch documents from the server on behalf of the browser, thereby speeding up web browsing by caching frequently requested pages and serving them from its cache. In addition, Squid proxies can also be used to filter pop-up ads and malware or to enforce access control (which clients can request what pages based on different authentication methods).

Traditionally, proxy servers are optional components, and browsers are configured to use the Squid server's proxy. A transparently configured Squid proxy means forcing all web traffic through the proxy without the client's cooperation (or knowledge). Once all browser connections have passed through the proxy, outgoing connections to external hosts can be restricted to the proxy, and direct connections from local clients can be blocked.

You can experience Squid's capabilities firsthand if you use OpenBSD's packet filter (pf), as OpenBSD PF can be used to redirect connections based on a variety of criteria, including source and destination addresses and ports. For example, one could redirect all TCP connections with destination port 80 (HTTP) coming through an interface connected to a local workstation to a Squid proxy running on a different address and port.

Since the destination address is decoded for the connection, the Squid proxy needs some way to find the original destination address of the web server to fetch the document. If the client sends an HTTP 1.1-compliant Host: header in its HTTP request, then Squid will use the specified host.

Legacy clients do not provide a Host: header, in which case Squid can ask the packet filter for the original destination address of the routed connection. The latter approach requires the proxy to be running on the firewall itself, otherwise the proxy can run on a separate host.

This article will explain how to install and configure the Squid proxy on `OpenBSD 7.5`.
   


## 📓 1. How to Install Squid Proxy
Squid is available in PKG packages and OpenBSD ports. You can choose from the standard version, or the version with Kerberos using Heimdal. To complete the Squid program so that it can run perfectly on OpenBSD, you should also install Squid dependencies, as in the following example.

```console
ns3# pkg_add -uvi
```
After that you install the Squid dependencies.

```console
ns3# pkg_add check_squid debug-squid
```
In this article, we will install the Squid proxy from the standard version or by using the `OpenBSD PKG package`. Run the following command to start installing the `Squid Proxy`.

```console
ns3# pkg_add squid
quirks-7.14 signed on 2024-03-17T12:22:05Z
Ambiguous: choose package for squid
a	0: <None>
	1: squid-6.8v0
	2: squid-6.8v0-krb5
Your choice: 1
squid-6.8v0:gmp-6.3.0: ok
squid-6.8v0:libnettle-3.9.1: ok
squid-6.8v0:libtasn1-4.19.0: ok
squid-6.8v0:libffi-3.4.4p1: ok
squid-6.8v0:p11-kit-0.25.3: ok
squid-6.8v0:brotli-1.0.9p0: ok
squid-6.8v0:gnutls-3.8.3p0: ok
squid-6.8v0:tdb-1.4.9p1: ok
squid-6.8v0: ok
The following new rcscripts were installed: /etc/rc.d/squid
See rcctl(8) for details.
New and changed readme(s):
	/usr/local/share/doc/pkg-readmes/squid
```
After that, you enable the Squid package with the rcctl command.

```console
ns3# rcctl enable squid
```


## 📓 2. Squid Proxy Configuration
After the installation process is complete, all Squid files are stored in the `/etc/squid` directory. Before continuing the Squid proxy configuration, you should run the following command first.

```console
ns3# squid -z -N
```
The main configuration file for Squid is located at `/etc/squid/squid.conf`, you need to make at least the following changes from the default configuration.

```console
acl localnet src 0.0.0.1-0.255.255.255	# RFC 1122 "this" network (LAN)
acl localnet src 10.0.0.0/8		# RFC 1918 local private network (LAN)
acl localnet src 100.64.0.0/10		# RFC 6598 shared address space (CGN)
acl localnet src 169.254.0.0/16 	# RFC 3927 link-local (directly plugged) machines
acl localnet src 172.16.0.0/12		# RFC 1918 local private network (LAN)
acl localnet src 192.168.0.0/16		# RFC 1918 local private network (LAN)
acl localnet src fc00::/7       	# RFC 4193 local private network range
acl localnet src fe80::/10      	# RFC 4291 link-local (directly plugged) machines

acl SSL_ports port 443
acl Safe_ports port 80		# http
acl Safe_ports port 21		# ftp
acl Safe_ports port 443		# https
acl Safe_ports port 70		# gopher
acl Safe_ports port 210		# wais
acl Safe_ports port 1025-65535	# unregistered ports
acl Safe_ports port 280		# http-mgmt
acl Safe_ports port 488		# gss-http
acl Safe_ports port 591		# filemaker
acl Safe_ports port 777		# multiling http

http_access deny !Safe_ports
http_access deny CONNECT !SSL_ports
http_access allow localnet manager
http_access deny manager
http_access allow localnet
http_access deny to_localhost
http_access deny to_linklocal
http_access deny all

http_port 192.168.5.3:3128
access_log /var/squid/logs/access.log
cache_log /var/squid/logs/cache.log
cache_store_log none
cache_dir ufs /var/squid/cache 100 16 256
coredump_dir /var/squid/cache

# Add any of your own refresh_pattern entries above these.
refresh_pattern ^ftp:		1440	20%	10080
refresh_pattern -i (/cgi-bin/|\?) 0	0%	0
refresh_pattern .		0	20%	4320
```

In the script `"http_port 192.168.5.3:3128"`, you can replace the IP `192.168.5.3` with your `OpenBSD server's` private IP.

The next step you have to change the flags in the file **"/etc/rc.conf.local"**. This file is to determine the path of the main configuration file, namely squid.conf.

```console
squid=YES
squid_flags="-f /etc/squid/squid.conf"
```
After that, you run the squid proxy server with the following command.

```console
ns3# rcctl restart squid
squid(ok)
squid(ok)
```
If the words `"squid(ok)"` appear, it means your Squid proxy server is running and you can use it in Google Chrome or other web browsers.

After we are sure that the squid proxy is running, now let's test it by opening Google Chrome or other web browsers such as Microsoft Edge, Opera, Comodo. In this article we will test the OpenBSD proxy server that we have installed above with Google Chrome.

The first step is to set the **"LAN setting"** menu, by clicking on the settings on your Google Chrome. Look at the following picture.

<br/>
![Set the LAN Setting menu in Chrome](https://gitflic.ru/project/unixbsdshell/ruby-static-page-jekyll-rb-openbsd/blob/raw?file=assets/images/34Set%20the%20LAN%20Setting%20menu%20in%20Chrome.jpg&commit=8f48f1f35f95dfa6fd30bc43d6a2921252e8e0e2)
<br/>

<br/>
![manual proxy setup](https://gitflic.ru/project/unixbsdshell/ruby-static-page-jekyll-rb-openbsd/blob/raw?file=assets/images/35manual%20proxy%20setup%20on%20chrome.jpg&commit=db79f6a45331dff1a37f40d00be1816b471a7382)

<br/>


Then in the `"Local Area Network (LAN) setting"` option, you set the IP Proxy server and the port used by the proxy.

The last step is to open any website, such as Youtube or Google Drive. If Youtube can open and play the video you choose, it means that your OpenBSD Proxy server is running normally.