---
title: Configuring FreeBSD and DNS Unbound As DNS Over TLS Client and Server
date: "2025-11-24 11:49:28 +0000"
updated: "2025-11-24 11:49:28 +0000"
id: configuring-dns-unbound-as-dns-over-tls-client-server
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: SysAdmin
background: https://raw.githubusercontent.com/unixwinbsd/unixbsdshell.github.io/refs/heads/main/img/nop-25/nop-25-031.jpg
toc: true
comments: true
published: true
excerpt: In this article, we will try to discuss how to install and configure an Unbound DNS server so that it supports DNS Over TLS which can increase security when you browse the internet.
keywords: freebsd, dns, tls, dns server, doh, dot, dns over tls, client, server
---

DNS over TLS is used to improve user privacy and security. It also prevents eavesdropping and manipulation of DNS traffic by MITM (man-in-the-middle) attacks. Although some browsers like Firefox, Yandex, and Chrome enable DNS over HTTPS by default, DNS over HTTPS only secures the web browser, not your internet connection.

For example, when your system connects to the internet for updates or when you use other desktop web applications like Discord and torrents.

In this article, we'll discuss how to install and configure an Unbound DNS server to support DNS over TLS, which can improve security while browsing the internet.

<img alt="Configuring FreeBSD and DNS Unbound As DNS Over TLS Client and Server" width="99%" class="lazyload" style="display: block; margin: auto;" src="{{ 'https://raw.githubusercontent.com/unixwinbsd/unixbsdshell.github.io/refs/heads/main/img/nop-25/nop-25-031.jpg' | absolute_url }}">

## A. System Specifications:

OS: FreeBSD 13.2-STABLE
CPU: AMD Phenom II X4 965 3400 MHz
LAN IP: 192.168.9.3/24
Domain: unixexplore.com
Unbound IP: 192.168.9.3
Unbound Port: 53
TLS Unbound Port: 853
Unbound Version: 1.17.1
control-interface: 127.0.0.1
control-port: 8951

The Domain Name System (DNS) that modern computers use to find resources on the internet was designed 35 years ago without user privacy in mind. This system is vulnerable to security risks and attacks such as DNS Hijacking. It also allows ISPs to intercept queries.

Fortunately, DNS over TLS and DNSSEC are available. DNS over TLS and DNSSEC allow for the creation of a secure, encrypted end-to-end tunnel from your computer to a configured DNS server. Implementing this technology on FreeBSD is straightforward, and all the necessary tools are readily available.

To install DNS Unbound over TLS on FreeBSD, you can use ports and pkg. Generally, the pkg system is more commonly used, as it is both concise and fast.

To install Unbound, run the `pkg install` command. Wait for the installation process to complete.

```yml
root@router2:~ # pkg install unbound openssl ca_root_nss bind-tools libevent
```

Before configuring `unbound.conf`, Unbound requires a root.hints file that lists the primary DNS servers. Unbound includes a list of root DNS servers in its code, but this ensures a current copy on each server. It's a good practice to update this file every six months. Download the `root.hints` file from [Internic](https://www.internic.net/domain/named.root).

```yml
root@router2:~ # wget ftp://FTP.INTERNIC.NET/domain/named.cache -O /usr/local/etc/unbound/root.hints
```

Additionally, Unbound requires an auto-trust-anchor file. This file contains the keys required for DNSSEC validation. To create the `root.key`, run the following command.

```yml
root@router2:~ # cd /usr/local/etc/unbound
root@router2:~ # unbound-anchor -a "/usr/local/etc/unbound/root.key"
```

Create an `rc.conf` file so Unbound can run automatically. Type the following command.

```console
root@router2:~ # ee /etc/rc.conf
Then enter the script

unbound_enable="YES"
unbound_config="/usr/local/etc/unbound/unbound.conf"
unbound_pidfile="/usr/local/etc/unbound/unbound.pid"
unbound_anchorflags="-a /usr/local/etc/unbound/root.hint"
```

Don't forget to include the following script in the `resolv.conf` file.

```console
root@router2:~ # ee /etc/resolv.conf
Kemudian masukkan script

domain unixexplore.com
nameserver 192.168.9.3
nameserver 127.0.0.1
```

The next step is to create the keys necessary for Unbound to be controlled by `unbound-control`.

```yml
root@router2:~ # cd /usr/local/etc/unbound
root@router2:~ # unbound-control-setup
```

Create Unbound log files and permissions.

```yml
root@router2:~ # cd /usr/local/etc/unbound
root@router2:~ # mkdir log
```

After that you give ownership rights to the unbound directory.

```yml
root@router2:~ # chown -R unbound:unbound /usr/local/etc/unbound
root@router2:~ # chown -R unbound:unbound /usr/local/etc/unbound/
root@router2:~ # chown -R unbound:unbound /usr/local/etc/unbound/*
```

## B. Unbound as a Caching DNS Resolver

By default, the unbound DNS service resolves and caches successful and failed lookups. The service then answers requests to the same records in its cache.

Now we get to the heart of the matter: editing the unbound.conf file. The unbound.conf file below is the original Unbound version 1.17.1 file; you just need to adjust it to your system specifications.

The default Unbound configuration file is located at `"/usr/local/etc/unbound/unbound.conf"`. Open this file with your preferred text editor. In this guide, we will use **"ee"** as the text editor. To edit the `unbound.conf` file, type the command below.

```yml
root@router2:~ # ee /usr/local/etc/unbound/unbound.conf
```

Once you have finished editing the `/usr/local/etc/unbound/unbound.conf` file, the next step is to run unbound with the `"service"` command.

```yml
root@router2:~ # service unbound restart
```

After you run the `restart` command, now we do the testing.

```yml
root@router2:~ # dig google.com
```

The local IP address 192.168.9.3 running on port 53 has responded to Google DNS, indicating the outbound server is running properly.

The method above configures outbound as a DNS server that caches DNS resolvers. Now let's continue discussing the unbound DNS over TLS configuration.

## C. Unbound as a DNS Over-TLS Client

Another, more modern way to protect DNS traffic is the DNS-over-TLS protocol described in the RFC7858 standard, which encapsulates data in standard TLS. We recommend using port `853` for access.

Just like DNSCrypt, it assumes that the DNS client, which is usually the same local caching DNS, is accessing a remote server that supports DNS-over-TLS.

Unbound, as mentioned above, has built-in support for this protocol, so no additional software layer is required to use it, as is the case with DNSCrypt.

To make unbound a DNS Over-TLS client, in the unbound.conf script above, we only need to change the last line:

```console
forward-zone:

name: "."

forward-addr: 1.1.1.1

forward-addr: 1.0.0.1

forward-addr: 8.8.8.8


We change it to,


forward-zone:

name: "."

forward-ssl-upstream: yes

forward-addr: 1.1.1.1@853

forward-addr: 1.0.0.1@853

forward-addr: 8.8.8.8@853
```

## D. Unbound as an Over-TLS DNS Server

To create an unbound server for DNS Over TLS, from an unbound script as a client for DNS Over TLS, we add an SSL script.

Before we go any further, let's create an SSL certificate with OpensSL first.

```yml
root@router2:~ # cd /usr/local/etc/unbound
root@router2:~ # openssl genrsa -des3 -out myCA.key 2048
root@router2:~ # openssl req -x509 -new -nodes -key myCA.key -sha256 -days 1825 -out myCA.pem
root@router2:~ # openssl req -new -newkey rsa:2048 -nodes -keyout mydomain.key -out mydomain.csr
root@router2:~ # openssl x509 -req -in mydomain.csr -CA myCA.pem -CAkey myCA.key -CAcreateserial -out mydomain.pem -days 1825 -sha256
```

After we obtain the SSL certificate, we proceed to edit the unbound.conf file. To edit it, we'll use the unbound.conf file from the discussion (Unbound as a DNS Over TLS client).

From the `unbound.conf` file, we add the interface script, thus becoming.

```console
interface: 192.168.9.3@53

interface: 192.168.9.3@853
```

Then, in the `tls-service-key, tls-cert-bundle and tls-port` scripts REMOVE the **"#"** sign, so that it becomes,

```console
tls-service-key: "/usr/local/etc/unbound/mydomain.key"

tls-service-pem: "/usr/local/etc/unbound/mydomain.pem"

tls-port: 853

tls-cert-bundle: "/etc/ssl/cert.pem"
```

After that, restart the Unbound server.

```yml
root@router2:~ # service unbound restart
```

Now we do tests on ports 53 and 853

```console
root@router2:~ # dig -p 53 google.com @192.168.9.3

; <<>> DiG 9.18.16 <<>> -p 53 google.com @192.168.9.3
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 24919
;; flags: qr rd ra; QUERY: 1, ANSWER: 6, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 1432
;; QUESTION SECTION:
;google.com.			IN	A

;; ANSWER SECTION:
google.com.		240	IN	A	172.253.118.138
google.com.		240	IN	A	172.253.118.113
google.com.		240	IN	A	172.253.118.100
google.com.		240	IN	A	172.253.118.101
google.com.		240	IN	A	172.253.118.139
google.com.		240	IN	A	172.253.118.102

;; Query time: 0 msec
;; SERVER: 192.168.9.3#53(192.168.9.3) (UDP)
;; WHEN: Thu Aug 03 22:30:38 WIB 2023
;; MSG SIZE  rcvd: 135
```

```console
root@router2:~ # dig -p 853 google.com @192.168.9.3

; <<>> DiG 9.18.16 <<>> -p 853 google.com @192.168.9.3
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 65330
;; flags: qr rd ra; QUERY: 1, ANSWER: 6, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 1432
;; QUESTION SECTION:
;google.com.			IN	A

;; ANSWER SECTION:
google.com.		73	IN	A	172.253.118.138
google.com.		73	IN	A	172.253.118.113
google.com.		73	IN	A	172.253.118.100
google.com.		73	IN	A	172.253.118.101
google.com.		73	IN	A	172.253.118.139
google.com.		73	IN	A	172.253.118.102

;; Query time: 0 msec
;; SERVER: 192.168.9.3#853(192.168.9.3) (UDP)
;; WHEN: Thu Aug 03 22:33:25 WIB 2023
;; MSG SIZE  rcvd: 135
```

The local IP address 192.168.9.3 running on port 853 is responding to Google DNS, indicating the unbound server is working properly.

We double-check that ports 53 and 853 are open.

```console
root@router2:~ # sockstat -46 | grep unbound
unbound  unbound    1421  4  udp4   192.168.9.3:53        *:*
unbound  unbound    1421  5  tcp4   192.168.9.3:53        *:*
unbound  unbound    1421  6  udp4   192.168.9.3:853       *:*
unbound  unbound    1421  7  tcp4   192.168.9.3:853       *:*
unbound  unbound    1421  8  tcp4   127.0.0.1:8951        *:*
```

In this case, Unbound has forwarded to the encrypted port 853.

In this tutorial, Unbound by default serves standard DNS requests on the local interface 192.168.9.3, port 53. However, we've also set Unbound as a Domain Over TLS server, so Unbound serves external requests exclusively via the DNS-over-TLS protocol on port 853.
