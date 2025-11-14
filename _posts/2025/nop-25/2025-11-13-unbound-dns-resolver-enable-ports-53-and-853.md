---
title: OpenBSD Setup and Unbound DNS Resolver - How to Enable Ports 53 and 853
date: "2025-11-13 07:49:21 +0000"
updated: "2025-11-13 07:49:21 +0000"
id: unbound-dns-resolver-enable-ports-53-and-853
lang: en
author: Iwan Setiawan
robots: index, follow
categories: openbsd
tags: DNSServer
background: https://upload.wikimedia.org/wikipedia/commons/thumb/5/5a/Unbound_DNS_resolver_logo.svg/2560px-Unbound_DNS_resolver_logo.svg.png
toc: true
comments: true
published: true
excerpt: Unbound is one of the DNS resolvers that is currently widely used. In fact, Unbound's presence as a DNS server almost beats ISC Bind, which is older than Unbound. We can feel the sophistication of Unbound with the various features it has, such as Python modules, Redis and DNS Over TLS support.
keywords: dns, server, unbound, https, http, tls, port, 53, 853, resolver, cache, caching, openbsd, unix, bsd
---

Did you know that we can improve internet performance and security by choosing a free and reliable alternative DNS resolver? The Domain Name System (DNS) may often come up in conversations among network administrators, but the average user may not know or care what DNS is or how it benefits them.

DNS is the glue that holds domain names and IP addresses together. If you own a server and want others to be able to access it using your domain name, you can pay a fee and register your unique domain name (if available) with an internet registrar. If you have a domain name associated with your server's IP address, people can visit your site using your domain name instead of typing in the IP address. DNS resolvers help with this.

A DNS resolver server allows a computer (or person) to look up a domain name (for example, unixwinbsd.site) and find the IP address of the computer, server, or other device that owns it (for example, 216.239.38.21). Think of a DNS resolver as a phone book for your computer.

When you enter a website's domain name into a web browser, behind the scenes, your computer's DNS resolver server determines the IP address to which the domain name should be entered so your browser can access everything the site offers. DNS is also used to determine which email server to send messages to. It has many other purposes.

Unbound is one of the DNS resolvers that is currently widely used. In fact, Unbound's presence as a DNS server almost beats ISC Bind, which is older than Unbound. We can feel the sophistication of Unbound with the various features it has, such as `Python modules, Redis and DNS Over TLS` support. So it is very natural that Unbound can match ISC Bind in terms of quality and features.

## 1. No need to install Unbound on OpenBSD

You might be wondering why you don't need to install Unbound on OpenBSD. Doesn't OpenBSD support Unbound? The answer is yes. Unbound has almost replaced ISC Bind as the primary DNS server on BSD Unix systems like FreeBSD, OpenBSD, DragonFly BSD, and others. Almost all BSD operating systems include Unbound as their primary DNS server. Jade automatically installs Unbound when you install OpenBSD.

Considering the facts above, it's safe to predict that Unbound will become the leading DNS server, surpassing ISC Bind, Knot resolver, and others. Unbound's developers are continuously improving Unbound's performance and conducting research to ensure it becomes the leading DNS server.

This can be demonstrated by making Unbound the primary DNS server on BSD systems. Like OpenBSD, OpenBSD users don't need to install Unbound, as it's already installed when they first install OpenBSD on their server computer. All they need to do is activate, configure, and run Unbound.

## 2. How to Configure Unbound on Port 53

By default, the DNS port runs on port 53, but you can change it to suit your needs, such as port `54, 8853, 55`, and so on. Since the title of this article is port 53, we will enable Unbound on port 53. Before we configure Unbound, we recommend first uninstalling the Unbound application on OpenBSD, then updating its PKG. We do this correctly to get the latest version of the Unbound application.

For your information, on OpenBSD, the Unbound application is called `"libunbound"` unlike FreeBSD, which uses the name `Unbound`. Now, let's remove the `Unbound library on OpenBSD`.

```yml
ns3# pkg_delete libunbound
ns3# rm -rf /var/unbound
```

Then you run the `Update PKG` command and proceed to reinstall Unbound into the OpenBSD system.

```yml
ns3# pkg_add -uvi
ns3# pkg_add libunbound debug-libunbound
```

Create a directory for Unbound with sub directories db and others, note the commands below.

```yml
ns3# mkdir -p /var/unbound/etc
ns3# mkdir -p /var/unbound/db
```

On OpenBSD, the main configuration file is named `"unbound.conf"` Run the command below to create the unbound.conf file. Then, type the script for the `unbound.conf` file as shown below.

```yml
ns3# touch /var/unbound/etc/unbound.conf
```

**Example script "/var/unbound/etc/unbound.conf"**

```console
server:
	interface: 192.168.5.3
	port: 53	
chroot: /var/unbound
username: "_unbound"
directory: "/var/unbound"
pidfile: "/var/run/unbound.pid"	
	do-ip4: yes
	do-ip6: no
	do-udp: yes
	do-tcp: yes
	do-daemonize: yes
access-control: 192.168.5.0/24 allow
access-control: 127.0.0.0/8 allow
	verbosity: 1
	harden-glue: yes
	hide-identity: yes
	hide-version: yes
	auto-trust-anchor-file: "/var/unbound/db/root.key"
	root-hints: "/var/unbound/db/root.hints"
	val-log-level: 2
	aggressive-nsec: yes
remote-control:
	control-enable: yes
	control-interface: /var/run/unbound.sock
forward-zone:
name: "."
forward-first: no
forward-ssl-upstream: yes
forward-addr: 1.1.1.1@853
forward-addr: 1.0.0.1@853
forward-addr: 8.8.8.8@853
```

Match `"interface: 192.168.5.3"` with your OpenBSD computer's private IP address. In this article, we'll use the private IP address `192.168.5.3 and the domain cursor.my.id`.

Run Unbound on OpenBSD.

```yml
ns3# rcctl enable unbound
ns3# rcctl restart unbound
```

Then you run the two commands below to download the root.hints file and give `ownership` to the unbound file.

```console
ns3# wget ftp://FTP.INTERNIC.NET/domain/named.cache -O /var/unbound/db/root.hints
ns3# chown -R _unbound /var/unbound/db/
```

After that, open the `/etc/resolv.conf` file, and type the script below in the `/etc/resolv.conf` file.

```console
domain kursor.my.id
nameserver 192.168.5.3
```

After that, you reload unbound with the `rcctl` command.

```yml
ns3# rcctl restart unbound
```

The final step is Unbound testing with the dig command.

```console
ns3# dig yahoo.com

; <<>> dig 9.10.8-P1 <<>> yahoo.com
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 29407
;; flags: qr rd ra; QUERY: 1, ANSWER: 6, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 1232
;; QUESTION SECTION:
;yahoo.com.			IN	A

;; ANSWER SECTION:
yahoo.com.		854	IN	A	74.6.143.26
yahoo.com.		854	IN	A	74.6.231.20
yahoo.com.		854	IN	A	98.137.11.163
yahoo.com.		854	IN	A	74.6.143.25
yahoo.com.		854	IN	A	98.137.11.164
yahoo.com.		854	IN	A	74.6.231.21

;; Query time: 0 msec
;; SERVER: 192.168.5.3#53(192.168.5.3)
;; WHEN: Fri May 10 17:29:11 WIB 2024
;; MSG SIZE  rcvd: 134
```

## 3. Setup Unbound on port 853 (DNS Over TLS)

Okay, now let's move on to the next lesson: how to enable port 853 in Unbound. Port 53, or the DNS Over TLS (DOT) port, is the port encrypted by the `SSL certificate`. To create the SSL certificate, we'll use OpenSSL, which is free and available. Before we start creating the SSL certificate, you can reopen the `unbound.conf` file and add the script below.

```console
interface: 192.168.5.3@853
tls-port: 853
tls-cert-bundle: "/etc/ssl/cert.pem"
tls-service-pem: "/etc/ssl/unbound/mydomain.crt"
tls-service-key: "/etc/ssl/unbound/mydomain.key"
server-key-file: "/var/unbound/etc/unbound_server.key"
server-cert-file: "/var/unbound/etc/unbound_server.pem"
control-key-file: "/var/unbound/etc/unbound_control.key"
control-cert-file: "/var/unbound/etc/unbound_control.pem"
```

After that, you create a certificate with a key that can be used to control all Unbound activities.

```console
ns3# unbound-control-setup
setup in directory /var/unbound/etc
Generating RSA private key, 3072 bit long modulus
.................................................
.....................
e is 65537 (0x010001)
Generating RSA private key, 3072 bit long modulus
...................
..............................................................................................................................................................................................................
e is 65537 (0x010001)
Signature ok
subject=/CN=unbound-control
removing artifacts
Setup success. Certificates created. Enable in unbound.conf file to use
```

Create a directory to store all Unbound SSL certificates, then create the SSL certificates using OpenSSL. Follow the instructions below.

```yml
ns3# mkdir -p /etc/ssl/unbound
ns3# cd /etc/ssl/unbound
```
<br/>

```console
ns3# openssl genrsa -out mydomain.key 2048
ns3# openssl req -new -key mydomain.key -out mydomain.csr
ns3# openssl x509 -req -days 365 -in mydomain.csr -signkey mydomain.key -out mydomain.crt
ns3# bash -c 'cat mydomain.key mydomain.crt >> /etc/ssl/unbound/mydomain.pem'
```
<br/>

```yml
ns3# chown -R _unbound /etc/ssl/unbound/
```

The final step is to test Unbound to see if it can open port 853. We use the dig command to test Unbound.

```yml
ns3# dig -p 853 google.com @192.168.5.3
```
<br/>

```yml
ns3# dig -p 53 yahoo.com @192.168.5.3
```

**Below we show the complete script of the unbound.conf file.**

```console
server:
	interface: 192.168.5.3@53
	interface: 192.168.5.3@853
	#port: 53
	tls-port: 853
chroot: /var/unbound
username: "_unbound"
directory: "/var/unbound"
pidfile: "/var/run/unbound.pid"
	do-ip4: yes
	do-ip6: no
	do-udp: yes
	do-tcp: yes
	do-daemonize: yes
tls-cert-bundle: "/etc/ssl/cert.pem"
tls-service-pem: "/etc/ssl/unbound/mydomain.crt"
tls-service-key: "/etc/ssl/unbound/mydomain.key"
	
access-control: 192.168.5.0/24 allow
access-control: 127.0.0.0/8 allow
	verbosity: 1
	harden-glue: yes
	hide-identity: yes
	hide-version: yes
	auto-trust-anchor-file: "/var/unbound/db/root.key"
	root-hints: "/var/unbound/db/root.hints"
	val-log-level: 2
	aggressive-nsec: yes
remote-control:
	control-enable: yes
	control-interface: /var/run/unbound.sock
	server-key-file: "/var/unbound/etc/unbound_server.key"
	server-cert-file: "/var/unbound/etc/unbound_server.pem"
	control-key-file: "/var/unbound/etc/unbound_control.key"
	control-cert-file: "/var/unbound/etc/unbound_control.pem"

forward-zone:
name: "."
forward-first: no
forward-ssl-upstream: yes
forward-addr: 1.1.1.1@853
forward-addr: 1.0.0.1@853
forward-addr: 8.8.8.8@853
```

Okay, that's it for this Unbound tutorial. Unbound has countless benefits. You can continue exploring other features in Unbound, such as Redis, Python, and more. Keep learning and reading so you can experience the benefits of Unbound firsthand.
