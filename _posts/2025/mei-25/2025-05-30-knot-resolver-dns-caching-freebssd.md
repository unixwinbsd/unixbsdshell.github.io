---
title: FreeBSD Knot Resolver - DNS Caching Resolver Implementation
date: "2025-05-30 07:29:31 +0100"
updated: "2025-05-30 07:29:31 +0100"
id: knot-resolver-dns-caching-freebssd
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: DNSServer
background: https://gitflic.ru/project/unixbsdshell/ruby-static-page-jekyll-rb-openbsd/blob/raw?file=assets/images/19freebsd%20knot%20resolver.jpg&commit=02c457f98e77bd0533b92fb3d23f70bb5cae513d
toc: true
comments: true
published: true
excerpt: Knot DNS Resolver includes a complete cache resolver implementation application written in LuaJIT and C. In the Knot resolver there are many modules that you can use, such as API modules for extensions and others. In general, there are three built-in modules, namely iterator, cache, validator, and many other external modules.
keywords: knot, resolver, dns, caching, name server, kresd, implementation, freebsd, openbsd
---

Knot Resolver is a caching DNS resolver that can be used on large networks such as ISP providers and is also highly recommended for use on home network routers. Knot Resolver is a modern resolver implementation designed for scalability, resilience, and flexibility. The design of Knot Resolver is different from other resolvers. Its core architecture is small and efficient, and most of its features can be implemented as optional modules, which limits the attack surface and improves the performance of Knot Resolver.

Knot DNS Resolver includes a complete cache resolver implementation application written in LuaJIT and C. In the Knot resolver there are many modules that you can use, such as API modules for extensions and others. In general, there are three built-in modules, namely iterator, cache, validator, and many other external modules.

In Lua modules, Knot resolver cache can be routed and shared, and fast FFI binding makes it great for leveraging the resolution process, or used for your recursive DNS service. This is the OpenResty of DNS.

Knot DNS resolver server adopts a different scaling strategy from other recursive DNS servers, it works without threading, no shared architecture (except MVCC cache which can be shared). You can start and stop additional nodes depending on the contention without any downtime.

In this article, we will learn how to install, configure and use Knot resolver on FreeBSD machine.

<br/>
![FreeBSD Knot Resolver Caching Diagram](https://gitflic.ru/project/unixbsdshell/ruby-static-page-jekyll-rb-openbsd/blob/raw?file=assets/images/19freebsd%20knot%20resolver.jpg&commit=02c457f98e77bd0533b92fb3d23f70bb5cae513d)
<br/>



## 1. Knot Resolver Installation Process
Like most applications running on FreeBSD, this application uses `PKG` and `ports` for the installation process. Likewise with the Knot resolver, you can use PKG or the port system. Although the installation process with the port system takes a long time, the installed libraries are very complete. So, we recommend that you use the port system to start installing the Knot resolver.

Type the following command to start installing the Knot resolver.

```console
root@ns3:~ # cd /usr/ports/dns/knot-resolver
root@ns3:/usr/ports/dns/knot-resolver # make config
root@ns3:/usr/ports/dns/knot-resolver # make install clean
```
In the `make config` command, a menu of options will appear that you must activate. If it is active, just press `OK`.

After you run the `make install clean` command, the FreeBSD ports system will automatically perform the installation process. Wait until the process is complete.

It turns out that installing Knot resolver is quite easy, anyone can do it. It turns out that the process does not stop here. There is still a configuration process and how to use it.

## 2. Knot Resolver Configuration Process
Configuration is the most important stage, you have to change, add, and delete scripts contained in the configuration file. By default, the Knot resolver directory is `/usr/local/etc/knot-resolver`, and the configuration file is named `kresd.conf`.

Open the `kresd.conf` file, edit the script and adjust it to your FreeBSD server specifications. As a guide, you can use the `kresd.conf` script as below.

```
net.listen('192.168.5.2', 53, { kind = 'dns' })


-- Load useful modules
modules = {
	'hints > iterate',  -- Allow loading /etc/hosts or custom root hints
	'stats',            -- Track internal statistics
	'predict',          -- Prefetch expiring/frequent records
}

internal_domains = policy.todnames({
  'datainchi.com.'
})

-- The authoritative server runs on 127.0.0.1, port 2153
policy.add(policy.suffix(policy.STUB({'127.0.0.1@2153'}), internal_domains))

-- Cache size
cache.size = 100 * MB

policy.add(
  policy.all(
    policy.TLS_FORWARD({
      {'8.8.8.8', hostname='dns.google' },
      {'8.8.4.4', hostname='dns.google' },
      {'1.1.1.1', hostname='cloudflare-dns.com' },
      {'1.0.0.1', hostname='cloudflare-dns.com' },
      {'9.9.9.9', hostname='dns.quad9.net' }
    })
))
```

IP `192.168.5.2` is the local IP of the FreeBSD server, while IP `8.8.8.8,8.8.4.4,1.1.1.1,1.0.0.1,9.9.9.9` is the Public DNS IP. So `Knot resolver` will "forward" to the Public DNS IP. The local domain name in the script above is `datainchi.com`.

After you configure the `kresd.conf` file, continue by editing the `/etc/resolv.conf` file. Type the script below in the file.
```
root@ns3:~ # ee /etc/resolv.conf

domain datainchi.com
nameserver 192.168.5.2
```


## 3. How to Use Knot Resolver
Even though you have configured the `kresd.conf` file, the Knot resolver cannot be used yet, it is installed but not running. To make the Knot resolver run automatically, open the `/etc/rc.conf` file and type the script below into the file.

```
kresd_enable="YES"
kresd_config="/usr/local/etc/knot-resolver/kresd.conf"
kresd_user="kresd"
kresd_group="kresd"
kresd_rundir="/var/run/kresd"

krescachegc_enable="YES"
krescachegc_millis="1000"
```

After that, you run the `chown` command to grant ownership of the file.
```console
root@ns3:~ # chown -R kresd:kresd /usr/local/etc/knot-resolver
```
Reload (Restart) Knot resolver.
```console
root@ns3:~ # service kresd restart
root@ns3:~ # service krescachegc restart
```
Now your Knot resolver is active and ready to use. Try testing it with the 1dig1 command.
```console
root@ns3:~ # dig google.com

; <<>> DiG 9.18.20 <<>> google.com
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 52479
;; flags: qr rd ra; QUERY: 1, ANSWER: 6, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 1232
;; QUESTION SECTION:
;google.com.                    IN      A

;; ANSWER SECTION:
google.com.             162     IN      A       142.251.10.113
google.com.             162     IN      A       142.251.10.138
google.com.             162     IN      A       142.251.10.139
google.com.             162     IN      A       142.251.10.100
google.com.             162     IN      A       142.251.10.101
google.com.             162     IN      A       142.251.10.102

;; Query time: 94 msec
;; SERVER: 192.168.5.2#53(192.168.5.2) (UDP)
;; WHEN: Mon Jan 29 16:57:48 WIB 2024
;; MSG SIZE  rcvd: 135
```
Note the blue script, you have successfully run the Knot resolver, because the one that answers the google.com DNS call is your FreeBSD server's local IP. Test again with the command below.
```console
root@ns3:~ # dig oracle.com +trace
root@ns3:~ # dig -x 108.59.161.1
root@ns3:~ # nslookup facebook.com
root@ns3:~ # dig oracle.com +short
root@ns3:~ # dig NS +short unixwinbsd.site
```
In this article you have learned how to install the knot-resolver package, configure it, and run it on a FreeBSD server. You can modify the `kresd.conf` file to get the most out of the Knot resolver application. The content of this article is limited to the basic theory of the Knot resolver, we will continue in the next discussion, so that you can feel the benefits of all the features of the Knot resolver.

