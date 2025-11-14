---
title: Installing DNSCrypt-proxy on OpenBSD
date: "2025-06-03 10:41:11 +0100"
updated: "2025-06-03 10:41:11 +0100"
id: installing-dnscrypt-proxy-openbsd
lang: en
author: Iwan Setiawan
robots: index, follow
categories: openbsd
tags: DNSServer
background: data:image/png;base64,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
toc: true
comments: true
published: true
excerpt: DNSCrypt proxy is able to block inappropriate content locally, know where your device sends data, speed up applications by storing DNS responses in its cache database. Thus, it can improve security and privacy by communicating with DNS servers over a secure channel. This helps prevent snooping, DNS hijacking, and MITM attacks.
keywords: dns, dnscrypt, proxy, dnscrypt proxy, openbsd, dns server, bind
---

DNSCrypt is a specification implemented in dnsdist, unbound, dnscrypt-wrapper, and dnscrypt-proxy software. DNSCrypt is software designed to serve a very flexible DNS proxy. This service can run on server computers, such as Linux, BSD, Windows, and MaxOS. You can also install DNSCrypt proxy on firewall routers such as PFSense, OpnSense, OpenWRT, and Mikrotik.

DNSCrypt proxy is able to block inappropriate content locally, know where your device sends data, speed up applications by storing DNS responses in its cache database. Thus, it can improve security and privacy by communicating with DNS servers over a secure channel. This helps prevent snooping, DNS hijacking, and MITM attacks.

DNScrypt-proxy is a DNS proxy that supports many modern encrypted DNS protocols such as DNSCrypt v2, DNS-over-HTTPS, and Anonymous DNSCrypt. The software is open source and available as precompiled binaries for most operating systems and architectures.

Here are the characteristics of DNScrypt proxy that you should know:
- Encrypt and authenticate DNS traffic. Supports DNS-over-HTTPS (DoH) using TLS 1.3, DNSCrypt, and anonymous DNS.
- Monitor DNS queries with separate log files for normal and suspicious queries.
- Client IP addresses can be hidden using Tor, SOCKS proxies, or anonymous DNS relays.
- Filter by time with flexible weekly schedules.
- Filtering: Block ads, malware, and other unwanted content. Compatible with all DNS services.
- Local IPv6 blocking to reduce latency on IPv4-only networks.
- DNS caching to reduce latency and increase privacy.
- Transparent redirection of specific domains to specific resolvers.
- Can force outgoing connections to use TCP.
- Includes a local DoH server to support ECHO (ESNI).
- Compatible with DNSSEC.
- Load Balancing: Select a set of resolvers, dnscrypt-proxy will automatically measure and monitor their speed, and balance traffic between the fastest available.
- Automatic updating of the resolver list in the background.
- Obfuscation: Like a more advanced HOSTS file that can return pre-configured addresses for a given name or resolve and return IP addresses for other names. This can be used for local development as well as providing secure search results on Google, Yahoo, DuckDuckGo, and Bing.

## 1. How to Install DNSCrypt Proxy (encrypted DNS server)
On OpenBSD, you no longer need to look for the DNScrypt proxy binary file, in the PKG package repository there is a ready-made and complete file, you can install it directly. In this first part, we will learn how to install an encrypted DNS server (DNSCrypt) using the `OpenBSD PKG package`. In writing this article, we use `OpenBSD 7.5`. The installation process is quite easy, you can follow the following commands.

```console
ns3# pkg_add dnscrypt-proxy
```
Once installed, Encrypted DNS Server (DNSCrypt) has sample configuration files stored in `/usr/local/share/examples/dnscrypt-proxy`. Meanwhile, the main configuration file is stored in the `/var/dnscrypt-proxy` directory.

Once you know the location of the configuration file, we continue with the following steps.


## 2. How to Configure DNSCrypt Proxy (encrypted DNS server)
This part is the most complicated part, because we will set all the functions and work of the DNScrypt proxy. If you write one script wrong, the DNScrypt proxy may not work perfectly. Unlike other applications running on OpenBSD, the main configuration file ends with `*.conf`. The main DNScrypt proxy configuration file is of the Cargo Toml type, which has the `*.toml` extension. The main configuration file is located in `/etc/dnscrypt-proxy.toml`.

Before we run the DNScrypt proxy, you must first change the `/etc/dnscrypt-proxy.toml` file. How to activate the DNScrypt proxy script by removing the **"#"** sign in front of the script. The first thing you must activate is to select the list of servers used. There are many server options that you can use. Don't forget to also activate the interface (listen), on which IP and port DNScrypt will run. See the example script `/etc/dnscrypt-proxy.toml` below.


```console
server_names = ['scaleway-fr', 'google', 'yandex', 'cloudflare']
listen_addresses = ['192.168.5.3:5300']
```
You also set up a remote server, multiple sources can be used simultaneously, but each source requires a dedicated cache file.

Activate some of the scripts below in the `/etc/dnscrypt-proxy.toml` file.

```toml
[sources]

  [sources.public-resolvers]
    urls = ['https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/public-resolvers.md', 'https://download.dnscrypt.info/resolvers-list/v3/public-resolvers.md']
    cache_file = '/var/dnscrypt-proxy/public-resolvers.md'
    minisign_key = 'RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3'
    refresh_delay = 72
    prefix = ''

  [sources.relays]
    urls = ['https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/relays.md', 'https://download.dnscrypt.info/resolvers-list/v3/relays.md']
    cache_file = '/var/dnscrypt-proxy/relays.md'
    minisign_key = 'RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3'
    refresh_delay = 72
    prefix = ''
```
To stabilize your DNS connection, you should create a static IP in your OpenBSD settings, and also add the script below to the **/etc/resolv.conf** file (adjust to your OpenBSD system).

```console
domain kursor.my.id
nameserver 192.168.5.3
```
After setting all the necessary configurations, run the DNScrypt proxy with the command below.

```console
ns3# rcctl enable dnscrypt_proxy
ns3# rcctl restart dnscrypt_proxy
```
To determine whether the DNScrypt proxy is running or not, test whether the DNScrypt proxy port is open and responding to DNS requests from clients.

```console
ns3# dig -p 5300 yahoo.com @192.168.5.3

; <<>> dig 9.10.8-P1 <<>> -p 5300 yahoo.com @192.168.5.3
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 35022
;; flags: qr rd ra; QUERY: 1, ANSWER: 6, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 512
;; QUESTION SECTION:
;yahoo.com.			IN	A

;; ANSWER SECTION:
yahoo.com.		2400	IN	A	74.6.231.20
yahoo.com.		2400	IN	A	74.6.231.21
yahoo.com.		2400	IN	A	74.6.143.25
yahoo.com.		2400	IN	A	98.137.11.164
yahoo.com.		2400	IN	A	98.137.11.163
yahoo.com.		2400	IN	A	74.6.143.26

;; Query time: 18 msec
;; SERVER: 192.168.5.3#5300(192.168.5.3)
;; WHEN: Sat May 11 09:55:34 WIB 2024
;; MSG SIZE  rcvd: 134
```

Note the script `192.168.5.3#5300(192.168.5.3)` above, it means that DNScrypt has successfully answered the client's DNS lookup request. You can change the private IP `192.168.5.3` with your OpenBSD server's private IP, and you can also change the port used (adjust to your OpenBSD system).

To do all that, you change the script `/etc/dnscrypt-proxy.toml`

```console
server_names = ['scaleway-fr', 'google', 'yandex', 'cloudflare']
listen_addresses = ['192.168.5.3:5300']
max_clients = 250
user_name = '_dnscrypt-proxy'
ipv4_servers = true
ipv6_servers = false
dnscrypt_servers = true
doh_servers = true
odoh_servers = false
require_dnssec = true
require_nolog = true
require_nofilter = true
disabled_server_names = []
force_tcp = true
http3 = false
timeout = 5000
keepalive = 30
cert_refresh_delay = 240
bootstrap_resolvers = ['9.9.9.11:53', '8.8.8.8:53']
ignore_system_dns = true
netprobe_timeout = 60
netprobe_address = '9.9.9.9:53'
log_files_max_size = 10
log_files_max_age = 7
log_files_max_backups = 1
block_ipv6 = false
block_unqualified = true
block_undelegated = true
reject_ttl = 10
cache = true
cache_size = 4096
cache_min_ttl = 2400
cache_max_ttl = 86400
cache_neg_min_ttl = 60
cache_neg_max_ttl = 600
dnscrypt_ephemeral_keys = true
tls_disable_session_tickets = true

[query_log]
file = '/var/dnscrypt-proxy/query.log'
format = 'tsv'

[sources]

  [sources.public-resolvers]
    urls = ['https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/public-resolvers.md', 'https://download.dnscrypt.info/resolvers-list/v3/public-resolvers.md']
    cache_file = '/var/dnscrypt-proxy/public-resolvers.md'
    minisign_key = 'RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3'
    refresh_delay = 72
    prefix = ''

  [sources.relays]
    urls = ['https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/relays.md', 'https://download.dnscrypt.info/resolvers-list/v3/relays.md']
    cache_file = '/var/dnscrypt-proxy/relays.md'
    minisign_key = 'RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3'
    refresh_delay = 72
    prefix = ''
```

<br/>
**Congratulations!** You have successfully run DNScrypt proxy on OpenBSD. As a final conclusion of this article, I would like to say that to protect your internet traffic, we recommend using DNScrypt proxy combined with ISC-Bind or Unbound.

To further enhance the security of your DNS server, also use Haproxy as a gateway between DNScrypt proxy and ISC-Bind or Unbound.