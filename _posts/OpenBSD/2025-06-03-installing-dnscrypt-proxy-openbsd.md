---
title: Installing DNSCrypt-proxy on OpenBSD
date: "2025-06-03 10:41:11 +0100"
id: installing-dnscrypt-proxy-openbsd
lang: en
layout: single
author_profile: true
categories:
  - FreeBSD
tags: DNSServer
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
**Congratulations!** You have successfully run DNScrypt proxy on OpenBSD. As a final conclusion
of this article, I would like to say that to protect your internet traffic, we recommend using DNScrypt proxy combined with ISC-Bind or Unbound.

To further enhance the security of your DNS server, also use Haproxy as a gateway between DNScrypt proxy and ISC-Bind or Unbound.