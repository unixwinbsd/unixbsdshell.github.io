---
title: FreeBSD How to Install Unbound DNS with Redis Cachedb Module
date: "2025-11-14 08:05:25 +0000"
updated: "2025-11-14 08:05:25 +0000"
id: how-to-install-unbound-dns-with-redis-cached-module
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: DNSServer
background: https://raw.githubusercontent.com/unixwinbsd/unixbsdshell.github.io/refs/heads/main/img/nop-25/nop-25-006.jpg
toc: true
comments: true
published: true
excerpt: If you want to improve speed and privacy while browsing the internet, setting up a local Unbound DNS server is an important first step. In this article, we'll configure Unbound DNS as a caching DNS resolver with Redis cacheDB as the backend to cache queries.
keywords: redis, cached, module, mod, dns, server, unbound, https, http, tls, port, 53, 853, resolver, cache, caching, openbsd, unix, bsd, freebsd
---

Unbound is designed as a set of modular DNS components, enabling recursive DNSSEC (secure DNS) validation, caching DNS resolvers, and stub-resolvers. Unbound's DNS cache servers are used to resolve every DNS query they receive. Unbound stores queries in a cacheDB. When a client requests a query, the request is sent from [the Unbound DNS cache](https://serverfault.com/questions/832153/unbound-domains-cached-only-for-short-time), and this request can be processed in milliseconds compared to the initial resolution.

To perform its role as a [caching DNS resolver](https://wiki.archlinux.org/title/Unbound#:~:text=Unbound%20is%20a%20validating%2C%20recursive,more%20secure%20for%20most%20applications.), Unbound can utilize two backends simultaneously:

- The default is an in-memory backend (named 'testframe'),
- and Redis.Unbound can connect to Redis CacheDB using a TCP port.

If you want to improve speed and privacy while browsing the internet, setting up a local Unbound DNS server is an important first step. In this article, we'll configure Unbound DNS as a caching DNS resolver with Redis cacheDB as the backend to cache queries.

## A. System Specifications

- OS: FreeBSD 13.2 Stable
- Hostname and Domain: ns6@datainchi.com
- IP Private: 192.168.5.2
- Unbound version: unbound-1.18.0_1
- Redis version: redis 7.2.3
- Port Redis: 6379
- Password Redis: gunungrinjani
- IP Redis: 127.0.0.1

## B. Redis Installation

As a first step in this tutorial, ensure your FreeBSD computer has a Redis server installed. If not, you can read our previous article, ["How to Install Redis Cached on FreeBSD with PKG and Ports"](https://unixwinbsd.site/freebsd/update-upgrade-pkg-ports-package-binary-freebsd/).

To begin installing Redis as a cacheDB from an Unbound DNS server, follow the step-by-step guide below:

```yml
root@ns6:~ # pkg install tcl86 mastodon openvas gitlab-ce resource-agents
```

The above process installs the Redis CacheDB library for DNS Unbound. Continue with the Redis installation. Use the FreeBSD porting system to ensure all these libraries are installed correctly.

```yml
root@ns6:~ # cd /usr/ports/databases/redis
root@ns6:/usr/ports/databases/redis # make install clean
```

## C. Unbound Configuration

Before proceeding, ensure Redis is fully installed on your FreBSD server. By default, the Redis module is disabled. To enable it for Unbound DNS, use the `make config` command. The following example demonstrates enabling the Redis module during an Unbound DNS installation.

```yml
root@ns6:~ # cd /usr/ports/dns/unbound
root@ns6:/usr/ports/dns/unbound # make deinstall
root@ns6:/usr/ports/dns/unbound # make config
```

You check the option `"Enable hiredis support for the cachedb"`, as shown in the following image.

<img alt="FreeBSD How to Install Unbound DNS with Redis Cachedb Module" width="99%" class="lazyload" style="display: block; margin: auto;" src="{{ 'https://raw.githubusercontent.com/unixwinbsd/unixbsdshell.github.io/refs/heads/main/img/nop-25/nop-25-006.jpg' | relative_url }}">
<br/>

```yml
root@ns6:/usr/ports/dns/unbound # make reinstall
```

## D. Enable the CacheDB module

The cachedb clause provides specific settings for the DB cache module:

- **backend:** Specify the name of the backend database. The default database is the backend named `redis`.
- **redis-server-host:** The IP address (either v6 or v4) or domain name of the Redis server.
- **redis-server-port:** The Redis server TCP port number. This option defaults to 6379.
- **redis-server-password:** Redis password.
- **redis-timeout:** The period until Unbound waits for a response from the Redis server.
- **redis-expire-records:** If Redis record expiration is enabled, If yes, unbound sets a timeout for Redis records so that Redis can automatically evict expired keys.

Once the Redis cachedb module is active, you have to configure the file `/usr/local/etc/unbound/unbound.conf` and type the script below in that file.

```console
module-config: "validator cachedb iterator"

cachedb:
backend: "redis"
redis-server-host: 127.0.0.1
redis-server-port: 6379
redis-server-password: "gunungrinjani"
redis-timeout: 100
redis-expire-records: no
```

The next step is to restart the Unbound and Redis applications.

```console
root@ns6:~ # service redis restart
Stopping redis.
Waiting for PIDS: 876.
Starting redis.
root@ns6:~ # service unbound restart
Stopping unbound.
Waiting for PIDS: 2418.
Obtaining a trust anchor...
Starting unbound.
```

We've proven Redis' effectiveness as a caching DNS resolver. Redis can speed up the process of storing queries and querying them from client computers. Use Redis and Unbound to improve the performance of your Unbound DNS server.
