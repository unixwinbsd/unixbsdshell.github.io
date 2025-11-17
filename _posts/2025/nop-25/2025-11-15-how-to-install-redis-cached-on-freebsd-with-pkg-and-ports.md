---
title: How to Install Redis Cached on FreeBSD with PKG and Ports
date: "2025-11-15 10:29:57 +0000"
updated: "2025-11-15 10:29:57 +0000"
id: how-to-install-redis-cached-on-freebsd-with-pkg-and-ports
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: DNSServer
background: https://raw.githubusercontent.com/unixwinbsd/unixbsdshell.github.io/refs/heads/main/img/nop-25/nop-25-010.jpg
toc: true
comments: true
published: true
excerpt: In this article, we'll cover how to install and configure Redis on a FreeBSD 13.2 system. We'll also cover how to test Redis.
keywords: redis, cached, module, mod, dns, server, https, http, tls, port, resolver, cache, caching, openbsd, unix, bsd, freebsd, linux
---

Redis (Remote Dictionary Server) is an in-memory data structure store, used as a key-value database, in-memory distributed cache, and message passing, with optional durability. Redis supports various types of abstract data structures, such as strings, lists, maps, sets, sorted sets, HyperLogLog, bitmaps, streams, and spatial indexes.

The Redis project began when `Salvatore Sanfilippo`, the original developer of Redis, wanted to improve the scalability of his Italian startup. From there, he developed Redis, which is now used as [a database, cache, message broker, and queue](https://meta.stackexchange.com/questions/110320/stack-overflow-db-performance-and-redis-cache). Redis delivers sub-millisecond response times, enabling millions of requests per second for real-time applications in industries like gaming, ad tech, financial services, healthcare, and IoT.

Redis is currently one of the most popular and beloved open-source database engines. [Stack Overflow](https://stackoverflow.com/questions/66979102/redis-database-vs-redis-cache) even named it the "Most Loved" database for five consecutive years. Due to its fast performance, Redis is a popular choice for caching, session management, gaming, leaderboards, real-time analytics, geospatial, ride-hailing, chat/messaging, media streaming, and pub/sub applications.

<img alt="How to Install Redis Cached on FreeBSD with PKG and Ports" width="99%" class="lazyload" style="display: block; margin: auto;" src="{{ 'https://raw.githubusercontent.com/unixwinbsd/unixbsdshell.github.io/refs/heads/main/img/nop-25/nop-25-010.jpg' | relative_url }}">
<br/>

All Redis data is stored in memory, enabling low-latency data access and high throughput. Unlike traditional databases, in-memory data stores do not require disk visits, reducing machine latency to microseconds. Therefore, in-memory data stores can support more operations and faster response times. The result is blazing-fast performance, with read and write operations averaging less than a millisecond and support for millions of operations per second.

In this article, we'll cover how to install and configure Redis on a FreeBSD 13.2 system. We'll also cover how to test Redis.

## A. Redis Installation Process

[To install Redis](https://unixwinbsd.site/freebsd/how-to-install-unbound-dns-with-redis-cached-module/), this article will only explain how to install Redis using the ports system. Before installing Redis, first update the FreeBSD ports system. Here's how to update ports and PKGs on FreeBSD.

```yml
root@ns1:~ # portmaster -af
root@ns1:~ # portupgrade -af
```

If you want to update `PKG`, run the following command.

```yml
root@ns1:~ # pkg update -f
root@ns1:~ # pkg upgrade -f
```

Once the port system has been successfully updated, proceed with the Redis installation. Here's how to install Redis.

```yml
root@ns1:~ # pkg install redis
```

If you want to install Redis with the FreeBSD Ports system, here are the commands.

```console
root@ns1:~ # cd /usr/ports/databases/redis

root@ns1:/usr/ports/databases/redis # make install clean

====> Compressing man pages (compress-man)
===> Staging rc.d startup script(s)
===>  Installing for redis-7.0.12
===>  Checking if redis is already installed
===>   Registering installation for redis-7.0.12

Installing redis-7.0.12...
===> Creating groups.

Using existing group 'redis'.
===> Creating users

Using existing user 'redis'.

      To setup "redis" you need to edit the configuration file:
      /usr/local/etc/redis.conf

      To run redis from startup, add redis_enable="YES"
      in your /etc/rc.conf.

===> SECURITY REPORT: 

      This port has installed the following files which may act as network
      servers and may therefore pose a remote security risk to the system.

```

## B. Redis Configuration

After successfully installing Redis, the next step to ensure it's fully functional is to configure it. The Redis configuration file is located at /usr/local/etc/redis.conf. The redis.conf file is where we'll edit the scripts within it. The following are the scripts you'll need to modify in the /usr/local/etc/redis.conf file.

```console
bind 127.0.0.1
requirepass gunungrinjani
daemonize yes
port 6379
maxmemory-policy volatile-lru
maxmemory 64mb
```

The script above is the one you must activate in the `/usr/local/etc/redis.conf` file by removing the `"#"` symbol in front of the script. This means the IP address used by Redis is 127.0.0.1 on port 6379 with the password "mountainrinjani."

Once the "redis.conf" configuration file is configured, the next step is to create a Startup script in the /etc/rc.conf file. This script is useful for automatically activating Redis, so you don't have to do it manually. To activate Redis, simply type the script below. Redis will automatically activate. The following is the Redis script you must type in the `/etc/rc.conf` file.

```console
root@ns1:~ # ee /etc/rc.conf
redis_enable="YES"
```

Then you run the restart command to run Redis.

```console
root@ns1:~ # service redis restart
Stopping redis.
Waiting for PIDS: 913.
Starting redis.
```

## C. Connecting and Performing Basic Operations in Redis

### c.1. Connecting to the Local Redis Server

```console
root@ns1:~ # redis-cli
127.0.0.1:6379>
```

c.2. Password Authentication

```console
root@ns1:~ # redis-cli
127.0.0.1:6379> auth gunungrinjani
OK
```

### c.3. Viewing Redis Status

```console
127.0.0.1:6379> info

# Server
redis_version:7.0.12
redis_git_sha1:00000000
redis_git_dirty:0
redis_build_id:59718b2dab3b47c2
redis_mode:standalone
os:FreeBSD 13.2-RELEASE amd64
arch_bits:64
monotonic_clock:POSIX clock_gettime
multiplexing_api:kqueue
atomicvar_api:c11-builtin
gcc_version:4.2.1
process_id:50533
process_supervised:no
run_id:aafb54938038bfe082b75a9b719b8229583f5d2c
tcp_port:6379
server_time_usec:1691552810868548
uptime_in_seconds:502
uptime_in_days:0
hz:10
configured_hz:10
lru_clock:13831210
executable:/usr/local/bin/redis-server
config_file:/usr/local/etc/redis.conf
io_threads_active:0

# Clients
connected_clients:1
cluster_connections:0
maxclients:10000
client_recent_max_input_buffer:8
client_recent_max_output_buffer:0
blocked_clients:0
tracking_clients:0
clients_in_timeout_table:0

# Memory
used_memory:1504008
used_memory_human:1.43M
used_memory_rss:8265728
used_memory_rss_human:7.88M
used_memory_peak:1504008
used_memory_peak_human:1.43M
used_memory_peak_perc:100.16%
used_memory_overhead:1405160
```

### c.4. Viewing Redis Server Information

```console
127.0.0.1:6379> info server

# Server
redis_version:7.0.12
redis_git_sha1:00000000
redis_git_dirty:0
redis_build_id:59718b2dab3b47c2
redis_mode:standalone
os:FreeBSD 13.2-RELEASE amd64
arch_bits:64
monotonic_clock:POSIX clock_gettime
multiplexing_api:kqueue
atomicvar_api:c11-builtin
gcc_version:4.2.1
process_id:50533
process_supervised:no
run_id:aafb54938038bfe082b75a9b719b8229583f5d2c
tcp_port:6379
server_time_usec:1691552929519441
uptime_in_seconds:621
uptime_in_days:0
hz:10
configured_hz:10
lru_clock:13831329
executable:/usr/local/bin/redis-server
config_file:/usr/local/etc/redis.conf
io_threads_active:0
```

### c.5. Redis Benchmark Test

```yml
root@ns1:~ # redis-benchmark -h 127.0.0.1 -p 6379 -n 10000 -c 15 -a gunungrinjani
```

The script above is just a small part of the basic Redis script. To learn more about Redis, you can read other articles. The core of this article focuses solely on the Redis installation and configuration process. By implementing this article, you have successfully run Redis on a FreeBSD server.


