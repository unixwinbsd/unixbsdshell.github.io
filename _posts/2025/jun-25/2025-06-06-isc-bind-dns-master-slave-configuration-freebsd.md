---
title: FreeBSD ISC Bind - Master and Slave DNS Configuration
date: "2025-06-06 19:41:21 +0100"
updated: "2025-06-06 19:41:21 +0100"
id: isc-bind-dns-master-slave-configuration-freebsd
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: DNSServer
background: https://gitflic.ru/project/unixbsdshell/ruby-static-page-jekyll-rb-openbsd/blob/raw?file=assets%2Fimages%2F26dns%20isc%20bind%20master%20dan%20slave.jpg&commit=3e890ce2a103ac5ef565096fb18d2a1fb938e13a
toc: true
comments: true
published: true
excerpt: DNS or Domain Name System servers are one of the most important components in the modern IT and internet world. With DNS, you can use easy-to-remember domain names instead of IP addresses. Especially as IPv6 becomes more popular, DNS remains a very important part of your network.
keywords: nsd, isc bind, dns, server, named, master, slave, unbound, freebsd, artcle, authoritative, configuration
---

DNS or Domain Name System servers are one of the most important components in the modern IT and internet world. With DNS, you can use easy-to-remember domain names instead of IP addresses. Especially as IPv6 becomes more popular, DNS remains a very important part of your network.

This article will explain how to set up a Master DNS server and a Slave DNS server that will replicate data from the parent server.

Before we go any further, you should see the topology image of the master and slave DNS servers that we will discuss in this article.

<br/>
![dns isc bind master dan slave](https://gitflic.ru/project/unixbsdshell/ruby-static-page-jekyll-rb-openbsd/blob/raw?file=assets%2Fimages%2F26dns%20isc%20bind%20master%20dan%20slave.jpg&commit=3e890ce2a103ac5ef565096fb18d2a1fb938e13a)
<br/>


## A. Why You Should Use Master and Slave DNS Servers
No system or installation has 100% perfect uptime and since DNS can be a critical component of our internet network, it is a good idea to have two DNS servers. A secondary DNS server to provide a backup in case the primary DNS fails. You can simply set up two identical DNS servers with the same configuration and data. While this will work fine, you will need to make all changes twice. Once on the primary server and once on the secondary server.

By setting up DNS servers, one as a master and the other as a slave, the slave will replicate zone data from the master to itself. This way, when changes are made to some zone on the master, the slave will be notified and take over the changes almost instantly without any configuration on the slave side.

With 2 DNS servers, a secondary and a primary, when the secondary DNS server is “down”, the primary DNS server is running full time. Likewise, when the primary DNS server is “down”, the DNS needs will be handled by the secondary DNS server.

## B. DNS Master Configuration
In this article, we will not explain the Bind installation process. We assume that you have installed Bind on a FreeBSD server and the Bind application is running normally. So, let's go straight to the DNS Master configuration.

The first step is to create the `"rndc.key"` key, (Remote Name Daemon Control). This key is used to manage a daemon called DNS Bind. Okay, now let's create the `rndc.key` key (do this only on the master server).

```console
root@router1:~ # rndc-confgen -a
wrote key file "/usr/local/etc/namedb/rndc.key"
root@router1:~ # chown -R bind:bind /usr/local/etc/namedb/rndc.key
root@router1:~ # chmod 440 /usr/local/etc/namedb/rndc.key
```
To configure DNS Master, please open the main Bind configuration file, namely `"/usr/local/etc/namedb/named.conf"`.

```console
root@router1:~ # ee /usr/local/etc/namedb/named.conf

key "rndc-key" {
	algorithm hmac-sha256;
	secret "sLhSyJAo609lksFnU2Z0y5MbiSnoVJfTMz21foPVv3g=";
};

 controls {
        inet 192.168.5.9 port 953 allow { 192.168.5.5; } keys { "rndc-key"; };
        inet 127.0.0.1 port 953 allow { 127.0.0.1; } keys { "rndc-key"; };
};

acl clients {
	192.168.5.0/24;
	127.0.0.1;
};
acl IP_LAN { 192.168.5.5; };

options {
	directory "/tmp";
	version "dns foo.kursor.my.id";
	listen-on port 53 { IP_LAN; };
	#listen-on-v6 { any; };
	allow-recursion { clients; };
	allow-query { clients; };
	allow-query-cache { clients; };
	allow-transfer { localhost; 192.168.5.9; };
	notify yes;
	empty-zones-enable yes;
	recursion yes;
	auth-nxdomain no;
	dnssec-validation yes;
};




zone "localhost" {
        type master;
        file "standard/localhost";
        allow-transfer { 127.0.0.1; };
};

zone "127.in-addr.arpa" {
        type master;
        file "standard/loopback";
        allow-transfer { 127.0.0.1; };
};

zone "." {
  type forward;
  forward first;
  forwarders { 1.1.1.1; 8.8.8.8; };
};

zone "kursor.my.id" in {
        type master;
        file "master/internal.lan";
};

zone "5.168.192.in-addr.arpa" in {
        type master;
        file "master/insternal.rev";
};
```

### a. Adding Zone files
After you have finished configuring the named.conf file, we continue by creating a zone. We divide the creation of this zone into 2. First we create a zone for the domain and second we create a zone for the reverse (IP address).

```console
root@router1:~ # ee /usr/local/etc/namedb/master/internal.lan

$ORIGIN .
$TTL    86400   ; 24 hours
kursor.my.id    IN SOA  router1.kursor.my.id. root.router1.kursor.my.id. (
                        2010022201 ; Serial
                        86400           ; Refresh (24 hours)
                        3600             ; Retry (1 hour)
                        172800         ; Expire (48 hours)
                        3600             ; Minimum (1 hour)
                )
kursor.my.id.		IN	NS      router1.kursor.my.id.
kursor.my.id.		IN	NS      router2.kursor.my.id.

$ORIGIN kursor.my.id.
router1.kursor.my.id.	IN	A       192.168.5.5
router2.kursor.my.id.	IN	A       192.168.5.9
```

<br/>

```console
root@router1:~ # ee /usr/local/etc/namedb/master/insternal.rev

$ORIGIN .
$TTL    86400   ; 24 hours
5.168.192.in-addr.arpa	IN	SOA	router1.kursor.my.id. root.router1.kursor.my.id. (
                                2010022201   ; Serial
                                86400             ; Refresh (24 hours)
                                3600               ; Retry (1 hour)
                                172800           ; Expire (48 hours)
                                3600               ; Minimum (1 hour)
                                )
	IN	NS      router1.kursor.my.id.
	IN	NS      router2.kursor.my.id.

$ORIGIN 5.168.192.in-addr.arpa.
100	IN     PTR     router1.kursor.my.id.
200	IN     PTR     router2.kursor.my.id.
```
After that you restart the Bind DNS server, with the following command.

```console
root@router1:~ # service named restart
```

## C. Setup DNS Slave
Once our master DNS server is working properly, it's time to add a slave DNS server to the master DNS server. In this article, the slave DNS server is run on another computer, but still using FreeBSD as its operating system.

The configuration method is not much different from the master DNS, there are only a few changes. Okay, let's edit the main slave DNS configuration file, namely `"/usr/local/etc/namedb/named.conf"`.

```console
root@router2:~ # ee /usr/local/etc/namedb/named.conf

key "rndc-key" {
	algorithm hmac-sha256;
	secret "sLhSyJAo609lksFnU2Z0y5MbiSnoVJfTMz21foPVv3g=";
};

 controls {
        inet 192.168.5.5 port 953 allow { 192.168.5.9; } keys { "rndc-key"; };
        inet 127.0.0.1 port 953 allow { 127.0.0.1; } keys { "rndc-key"; };
};

acl clients {
	192.168.5.0/24;
	127.0.0.1;
};
acl IP_LAN { 192.168.5.9; };

options {
	directory "/tmp";
	version "dns foo.kursor.my.id";
	listen-on port 53 { IP_LAN; };
	#listen-on-v6 { any; };
	allow-recursion { clients; };
	allow-query { clients; };
	allow-query-cache { clients; };
	allow-transfer { localhost; 192.168.5.5; };
	notify yes;
	empty-zones-enable yes;
	recursion yes;
	auth-nxdomain no;
	dnssec-validation yes;
};




zone "localhost" {
        type slave;
        file "standard/localhost";
        allow-transfer { 127.0.0.1; };
};

zone "127.in-addr.arpa" {
        type slave;
        file "standard/loopback";
        allow-transfer { 127.0.0.1; };
};

zone "." {
  type forward;
  forward first;
  forwarders { 1.1.1.1; 8.8.8.8; };
};

zone "kursor.my.id" in {
        type slave;
        masters { 192.168.5.5; };
        file "master/internal.lan";
};

zone "5.168.192.in-addr.arpa" in {
        type slave;
        masters { 192.168.5.5; };
        file "master/insternal.rev";
};
```

### a. Adding Zone file (slave)
Creating a zone file for DNS slave is almost the same as DNS master. Here is the zone file for DNS slave.

```console
root@router2:~ # ee /usr/local/etc/namedb/master/internal.lan

$ORIGIN .
$TTL    86400   ; 24 hours
kursor.my.id    IN SOA  router2.kursor.my.id. root.router2.kursor.my.id. (
                        2010022201 ; Serial
                        86400           ; Refresh (24 hours)
                        3600             ; Retry (1 hour)
                        172800         ; Expire (48 hours)
                        3600             ; Minimum (1 hour)
                )
kursor.my.id.		IN	NS      router2.kursor.my.id.
kursor.my.id.		IN	NS      router1.kursor.my.id.

$ORIGIN kursor.my.id.
router2.kursor.my.id.	IN	A       192.168.5.9
router1.kursor.my.id.	IN	A       192.168.5.5
```
<br/>

```console
root@router2:~ # ee /usr/local/etc/namedb/master/insternal.rev

$ORIGIN .
$TTL    86400   ; 24 hours
5.168.192.in-addr.arpa	IN	SOA	router2.kursor.my.id. root.router2.kursor.my.id. (
                                2010022201   ; Serial
                                86400             ; Refresh (24 hours)
                                3600               ; Retry (1 hour)
                                172800           ; Expire (48 hours)
                                3600               ; Minimum (1 hour)
                                )
	IN	NS      router2.kursor.my.id.
	IN	NS      router1.kursor.my.id.

$ORIGIN 5.168.192.in-addr.arpa.
100	IN     PTR     router2.kursor.my.id.
200	IN     PTR     router1.kursor.my.id.
```
After that you restart the Bind DNS server, with the following command.

```console
root@router1:~ # service named restart
```
If you followed all the instructions above, and there is nothing wrong in the scripting, you can now enjoy two DNS servers for your internet network needs. Enjoy the internet speed with private DNS on your FreeBSD server.