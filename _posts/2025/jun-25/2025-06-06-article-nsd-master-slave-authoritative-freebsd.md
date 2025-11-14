---
title: FreeBSD Article - Creating NSD Authoritative DNS Master and Slave
date: "2025-06-06 10:27:11 +0100"
updated: "2025-06-06 10:27:11 +0100"
id: article-nsd-master-slave-authoritative-freebsd
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: DNSServer
background: /img/Logo.png
toc: true
comments: true
published: true
excerpt: One server is selected to be the master name server, which is the authority for all resource records in the zone file. Another server is selected to be the slave name server, which will reflect the master resource record. The zone master will get its resource records locally, while the zone slaves will get their resource records by copying from the master. Both the master and slave can then serve records to clients requesting name server resolution.
keywords: nsd, isc bind, dns, server, named, master, slave, unbound, freebsd, artcle, authoritative
---

The Internet RFC requires that each DNS zone have at least two name servers (master and slave) to provide redundancy if one server goes offline. These two name servers will serve resource records and need to be synchronized. To do this, we can set the master/slave configuration of our nameservers.

One server is selected to be the master name server, which is the authority for all resource records in the zone file. Another server is selected to be the slave name server, which will reflect the master resource record. The zone master will get its resource records locally, while the zone slaves will get their resource records by copying from the master. Both the master and slave can then serve records to clients requesting name server resolution.

To replicate resource records, the master name server needs to periodically transfer its resource records to the slave name server. Whenever any changes are made to the master server's local records, it can issue a NOTIFY message to the slave servers to immediately propagate the changes.

In this article we will try to explain in full the NSD Authoritative DNS Server configuration. In its implementation we will use 2 server computers, 1 computer for the Master NSD and 1 computer for the Slave NSD.

## A. System Specifications:

**NSD Master Servers:**
- OS: PFSense 2.6.0-RELEASE (amd64)
- CPU: Intel(R) Core(TM)2 Duo CPU E8400 @ 3.00GHz
- Because it uses PFSense, there are 2 Land Cards
    a. WAN IP: 192.168.1.2
    b. LAN IP: 192.168.5.2
- Hostname: ns1
- Domain: unixexplore.com
- Unbound Caching DNS Server: 192.168.5.2@53
- Master NSD DNS Server: 192.168.5.2@5053

**NSD Slave Servers:**
- OS: FreeBSD 13.2 Stable
- Processor: AMD Phenom II X4 965 3400 MHz
- Memory: 2 GB
- Hostname: ns2
- Domain: unixexplore.com
- LAN IP: 192.168.5.3/24
- Unbound Caching DNS Server: 192.168.5.3@53
- Slave NSD DNS Server: 192.168.5.3@5053

Pay attention to the system specifications that we created, on the NSD Master server, I used the PFSense Router, while on the NSD Slave Server I used the FreeBSD 13.2 Stable Server. You need to know, in this tutorial we will not explain how to install and configure the Unbound Server, you can read the previous article about installing Unbound. In this article Unbound is used as a DNS caching server for clients on our LAN. Every DNS request from the client will be served by Unbound.


## B. NSD installation

OK, let's just start installing the NSD application. To install NSD, you can use FreeBSD Ports or the pkg package. We will practice installing NSD using FreeBSD Port.

```console
root@ns1:~ # cd /usr/ports/dns/nsd
root@ns1:/usr/ports/dns/nsd # make install clean
root@ns1:/usr/ports/dns/nsd # cd /usr/ports/converters/base64
root@ns1:/usr/ports/converters/base64 # make install clean
```
After the NSD installation is complete, nsd automatically has user: `"nsd"` and group: `"nsd"`. The next step we create the directory structure required for NSD settings. Create a directory structure in the `/usr/local/etc/nsd` folder. The chown command below will assign the `"nsd"` user and group to the zonefile and tmp db log folders.

```console
root@ns1:/usr/ports/converters/base64 # cd /usr/local/etc/nsd
root@ns1:/usr/local/etc/nsd # mkdir -p log db zonefile tmp
root@ns1:/usr/local/etc/nsd # chown nsd:nsd log db zonefile tmp
root@ns1:/usr/local/etc/nsd # chmod 755 log db zonefile tmp
```
The next step, set NSD to automatically **RUNNING** when the server computer is turned off or restarted, create the following script in the `/etc/rc.conf` file.

```console
root@ns1:/usr/local/etc/nsd # ee ee /etc/rc.conf
nsd_enable="YES"
```


## C. Create a TSIG Key

NSD supports Transaction Signature (TSIG) for zone transfers and to notify sending and receiving, for any request to the server. The Transaction Signature (TSIG) key is used to secure and encrypt zone transfers. This TSIG key generation can only be done on the NSD Master Server.

```console
root@ns1:~ # cd /usr/local/etc/nsd
root@ns1:/usr/local/etc/nsd # dd if=/dev/random of=/dev/stdout count=1 bs=32 | openssl base64
1+0 records in
1+0 records out
32 bytes transferred in 0.000062 secs (517808 bytes/sec)
/9u+zAEFCCcSe15VKuicwGIMuNCEZkWRJp+1tYWjCW8=
root@ns1:/usr/local/etc/nsd #
```
The blue color in the script above is the TSIG key created by NSD. Save the TSIG key so you don't lose it, to anticipate if the NSD server is damaged, we have a backup of the TSIG key. After you save the TSIG key.

Next we run the `nsd-control-setup` script.

```console
root@ns1:/usr/local/etc/nsd # nsd-control-setup
setup in directory /usr/local/etc/nsd
Generating RSA private key, 3072 bit long modulus (2 primes)
.....................................++++
.....++++
e is 65537 (0x010001)
Generating RSA private key, 3072 bit long modulus (2 primes)
................++++
.................................++++
e is 65537 (0x010001)
Signature ok
subject=CN = nsd-control
Getting CA Private Key
removing artifacts
Setup success. Certificates created. Enable in nsd.conf file to use
root@ns1:/usr/local/etc/nsd #
```


## D. Create Zone Files

The next step is to create zone files (forward and reverse) on the NSD Master and NSD Slave servers. On each NSD server (master and slave), we create two zone files, and we place them in the `/usr/local/etc/nsd/zonefile` folder.

For free file zone naming, in this article we name the file zones as follows:
- File unixexplore.com.forward   `(/usr/local/etc/nsd/zonefile/unixexplore.com.forward)`.
- File unixexplore.com.reverse   `(/usr/local/etc/nsd/zonefile/unixexplore.com.reverse)`.

```console
root@ns1:/usr/local/etc/nsd # touch /usr/local/etc/nsd/zonefile/unixexplore.com.forward
root@ns1:/usr/local/etc/nsd # chmod +x /usr/local/etc/nsd/zonefile/unixexplore.com.forward
root@ns1:/usr/local/etc/nsd # touch /usr/local/etc/nsd/zonefile/unixexplore.com.reverse
root@ns1:/usr/local/etc/nsd # chmod +x /usr/local/etc/nsd/zonefile/unixexplore.com.reverse
```
Below is an example of a script file `"unixexplore.com.forward"` For NSD Master dan Slave.

```
$ORIGIN unixexplore.com. ; default zone domain
$TTL 86400               ; default time to live

@ IN SOA ns1.unixexplore.com. admin.unixexplore.com. (
                 2014010203 ; serial number
                 28800      ; Refresh
                 7200       ; Retry
                 864000     ; Expire
                 86400      ; Min TTL
                   )

@		IN NS ns1.unixexplore.com.
@		IN NS ns2.unixexplore.com.

@               IN    A    192.168.5.2
ns1             IN    A    192.168.5.2 
ns2             IN    A    192.168.5.3
```

Below is an example of a script file `"unixexplore.com.reverse"` for  NSD Master dan Slave.

```
$ORIGIN unixexplore.com. ; default zone domain
$TTL 86400       ; default time to live

5.168.192.in-addr.arpa. IN SOA ns1.unixexplore.com. admin.unixexplore.com. (
                            2014010203 ; serial number
                            28800      ; Refresh
                            7200       ; Retry
                            864000     ; Expire
                            86400      ; Min TTL
                             )
; Name Servers

@				IN		NS		ns1
@				IN		NS		ns2

2.5.168.192.in-addr.arpa.	IN		PTR		@
2.5.168.192.in-addr.arpa.	IN		PTR		ns1
3.5.168.192.in-addr.arpa.	IN		PTR		ns2
```



## E. NSD configuration

Because we will run NSD with an Unbound DNS caching server, so, to avoid void conflicts, configure NSD using port `5053`, because port `53` is used by the Unbound DNS caching server. NSD will listen to requests from the LAN server IP. Before we run the NSD application, make sure we have edited the nsd.conf file in the `/usr/local/etc` folder to suit internet needs and the specifications of our server computer.

Below is the `"/usr/local/etc/nsd/nsd.conf"` script to serve NSD Master

```
#
# nsd.conf -- the NSD(8) configuration file, nsd.conf(5).
#
# Copyright (c) 2001-2011, NLnet Labs. All rights reserved.
#
# See LICENSE for the license.
#

# This is a comment.
# Sample configuration file
# include: "file" # include that file's text over here.

# options for the nsd server

server:
 
# Number of NSD servers to fork. Put the number of CPUs to use here.
# server-count: 1

# uncomment to specify specific interfaces to bind (default are the
# wildcard interfaces 0.0.0.0 and ::0).
# ip-address: 1.2.3.4
# ip-address: 1.2.3.4@5678
# ip-address: 12fe::8ef0
ip-address: 192.168.9.1
ip-address: 127.0.0.1

# Allow binding to non local addresses. Default no.
# ip-transparent: no

# enable debug mode, does not fork daemon process into the background.
# debug-mode: no

# listen on IPv4 connections
  do-ip4: yes

# listen on IPv6 connections
# do-ip6: yes

# port to answer queries on. default is 53.
port: 5053

# Verbosity level.
  verbosity: 2

# After binding socket, drop user privileges.
# can be a username, id or id.gid.
username: nsd

# Run NSD in a chroot-jail.
# make sure to have pidfile and database reachable from there.
# by default, no chroot-jail is used.
chroot: "/usr/local/etc/nsd"

# The directory for zonefile: files. The daemon chdirs here.
  zonesdir: "/usr/local/etc/nsd/zonefile"
 
# the list of dynamically added zones.
  zonelistfile: "/usr/local/etc/nsd/db/zone.list"

# the database to use
  database: "/usr/local/etc/nsd/db/nsd.db"

# log messages to file. Default to stderr and syslog (with
# facility LOG_DAEMON). stderr disappears when daemon goes to bg.
  logfile: "/usr/local/etc/nsd/log/nsd.log"

# File to store pid for nsd in.
  pidfile: "/usr/local/etc/nsd/nsd.pid"

# The file where secondary zone refresh and expire timeouts are kept.
# If you delete this file, all secondary zones are forced to be 
# 'refreshing' (as if nsd got a notify).
  xfrdfile: "/usr/local/etc/nsd/db/xfrd.state"

# The directory where zone transfers are stored, in a subdir of it.
  xfrdir: "/usr/local/etc/nsd/tmp"

# don't answer VERSION.BIND and VERSION.SERVER CHAOS class queries
  hide-version: yes

# identify the server (CH TXT ID.SERVER entry).
  identity: "unidentified server"

# NSID identity (hex string, or "ascii_somestring"). default disabled.
# nsid: "aabbccdd"

# Maximum number of concurrent TCP connections per server.
# tcp-count: 100

# Maximum number of queries served on a single TCP connection.
# By default 0, which means no maximum.
# tcp-query-count: 0

# Override the default (120 seconds) TCP timeout.
# tcp-timeout: 120

# Preferred EDNS buffer size for IPv4.
# ipv4-edns-size: 4096

# Preferred EDNS buffer size for IPv6.
# ipv6-edns-size: 4096

# statistics are produced every number of seconds. Prints to log.
# statistics: 3600

# Number of seconds between reloads triggered by xfrd.
# xfrd-reload-timeout: 1

# check mtime of all zone files on start and sighup
# zonefiles-check: yes

# RRLconfig
# Response Rate Limiting, size of the hashtable. Default 1000000.
# rrl-size: 1000000

# Response Rate Limiting, maximum QPS allowed (from one query source).
# Default 200. If set to 0, ratelimiting is disabled. Also set
# rrl-whitelist-ratelimit to 0 to disable ratelimit processing.
# rrl-ratelimit: 200

# Response Rate Limiting, number of packets to discard before
# sending a SLIP response (a truncated one, allowing an honest
# resolver to retry with TCP). Default is 2 (one half of the
# queries will receive a SLIP response, 0 disables SLIP (all
# packets are discarded), 1 means every request will get a
# SLIP response.
# rrl-slip: 2

# Response Rate Limiting, IPv4 prefix length. Addresses are
# grouped by netblock. 
# rrl-ipv4-prefix-length: 24

# Response Rate Limiting, IPv6 prefix length. Addresses are
# grouped by netblock. 
# rrl-ipv6-prefix-length: 64

# Response Rate Limiting, maximum QPS allowed (from one query source)
# for whitelisted types. Default 2000.
# rrl-whitelist-ratelimit: 2000
# RRLend

# Remote control config section. 

remote-control:
 
# Enable remote control with nsd-control(8) here.
# set up the keys and certificates with nsd-control-setup.
  control-enable: yes 

# what interfaces are listened to for control, default is on localhost.
  control-interface: 127.0.0.1
# control-interface: ::1

# port number for remote control operations (uses TLS over TCP).
  control-port: 8952

# nsd server key file for remote control.
  server-key-file: "/usr/local/etc/nsd/nsd_server.key"

# nsd server certificate file for remote control.
  server-cert-file: "/usr/local/etc/nsd/nsd_server.pem"

# nsd-control key file.
  control-key-file: "/usr/local/etc/nsd/nsd_control.key"

# nsd-control certificate file.
  control-cert-file: "/usr/local/etc/nsd/nsd_control.pem"


# Secret keys for TSIGs that secure zone transfers.
# You could include: "secret.keys" and put the 'key:' statements in there,
# and give that file special access control permissions.
#
key:
# The key name is sent to the other party, it must be the same
name: "secure_key"
# algorithm hmac-md5, or hmac-sha1, or hmac-sha256 (if compiled in)
algorithm: hmac-sha256
# secret material, must be the same as the other party uses.
# base64 encoded random number.
# e.g. from dd if=/dev/random of=/dev/stdout count=1 bs=32 | base64
secret: "D4Xurm0OcyfCxMCcXpnPC/F1LpcRtLIQrlcH4ABxy/Y="                              


# Patterns have zone configuration and they are shared by one or more zones.
# 
# pattern:
# name by which the pattern is referred to
# name: "myzones"
# the zonefile for the zones that use this pattern.
# if relative then from the zonesdir (inside the chroot).
# the name is processed: %s - zone name (as appears in zone:name).
# %1 - first character of zone name, %2 second, %3 third.
# %z - topleveldomain label of zone, %y, %x next labels in name.
# if label or character does not exist you get a dot '.'.
# for example "%s.zone" or "zones/%1/%2/%3/%s" or "secondary/%z/%s"
# zonefile: "%s.zone"
 
# If no master and slave access control elements are provided,
# this zone will not be served to/from other servers.

# A master zone needs notify: and provide-xfr: lists. A slave
# may also allow zone transfer (for debug or other secondaries).
# notify these slaves when the master zone changes, address TSIG|NOKEY
# IP can be ipv4 and ipv6, with @port for a nondefault port number.
# notify: 192.0.2.1 NOKEY
# allow these IPs and TSIG to transfer zones, addr TSIG|NOKEY|BLOCKED
# address range 192.0.2.0/24, 1.2.3.4&255.255.0.0, 3.0.2.20-3.0.2.40
# provide-xfr: 192.0.2.0/24 my_tsig_key_name
# set the number of retries for notify.
# notify-retry: 5

# uncomment to provide AXFR to all the world
# provide-xfr: 0.0.0.0/0 NOKEY
# provide-xfr: ::0/0 NOKEY

# A slave zone needs allow-notify: and request-xfr: lists.
# allow-notify: 2001:db8::0/64 my_tsig_key_name
# By default, a slave will request a zone transfer with IXFR/TCP.
# If you want to make use of IXFR/UDP use: UDP addr tsigkey
# for a master that only speaks AXFR (like NSD) use AXFR addr tsigkey
# request-xfr: 192.0.2.2 the_tsig_key_name
# Attention: You cannot use UDP and AXFR together. AXFR is always over 
# TCP. If you use UDP, we higly recommend you to deploy TSIG.
# Allow AXFR fallback if the master does not support IXFR. Default
# is yes.
# allow-axfr-fallback: yes
# set local interface for sending zone transfer requests.
# default is let the OS choose.
# outgoing-interface: 10.0.0.10

# if you give another pattern name here, at this point the settings
# from that pattern are inserted into this one (as if it were a 
# macro). The statement can be given in between other statements,
# because the order of access control elements can make a difference
# (which master to request from first, which slave to notify first).
# include-pattern: "common-masters"


# Fixed zone entries. Here you can config zones that cannot be deleted.
# Zones that are dynamically added and deleted are put in the zonelist file.
#
# zone:
# name: "example.com"
# you can give a pattern here, all the settings from that pattern
# are then inserted at this point
# include-pattern: "master"
# You can also specify (additional) options directly for this zone.
# zonefile: "example.com.zone"
# request-xfr: 192.0.2.1 example.com.key

# RRLconfig
# Response Rate Limiting, whitelist types
# rrl-whitelist: nxdomain
# rrl-whitelist: error
# rrl-whitelist: referral
# rrl-whitelist: any
# rrl-whitelist: rrsig
# rrl-whitelist: wildcard
# rrl-whitelist: nodata
# rrl-whitelist: dnskey
# rrl-whitelist: positive
# rrl-whitelist: all
# RRLend

  zone:
   name: "unixexplore.com"
   zonefile: unixexplore.com.forward
   notify: 192.168.9.3@5053 secure_key
   provide-xfr: 192.168.9.3 secure_key

  zone:
   name: "9.168.192.in-addr.arpa"
   zonefile: unixexplore.com.reverse
   notify: 192.168.9.3@5053 secure_key
   provide-xfr: 192.168.9.3 secure_key
```


Below is the `"/usr/local/etc/nsd/nsd.conf"` script for the NSD Slave server.

```
#
# nsd.conf -- the NSD(8) configuration file, nsd.conf(5).
#
# Copyright (c) 2001-2011, NLnet Labs. All rights reserved.
#
# See LICENSE for the license.
#

# This is a comment.
# Sample configuration file
# include: "file" # include that file's text over here.

# options for the nsd server

server:
 
# Number of NSD servers to fork. Put the number of CPUs to use here.
 server-count: 1

# uncomment to specify specific interfaces to bind (default are the
# wildcard interfaces 0.0.0.0 and ::0).
# ip-address: 1.2.3.4
# ip-address: 1.2.3.4@5678
# ip-address: 12fe::8ef0
  ip-address: 192.168.9.3
  ip-address: 127.0.0.1
 

# Allow binding to non local addresses. Default no.
# ip-transparent: no

# enable debug mode, does not fork daemon process into the background.
# debug-mode: no

# listen on IPv4 connections
  do-ip4: yes

# listen on IPv6 connections
# do-ip6: yes

# port to answer queries on. default is 53.
  port: 5053

# Verbosity level.
  verbosity: 2 

# After binding socket, drop user privileges.
# can be a username, id or id.gid.
  username: nsd

# Run NSD in a chroot-jail.
# make sure to have pidfile and database reachable from there.
# by default, no chroot-jail is used.
  chroot: "/usr/local/etc/nsd"

# The directory for zonefile: files. The daemon chdirs here.
  zonesdir: "/usr/local/etc/nsd/zonefile"
 
# the list of dynamically added zones.
  zonelistfile: "/usr/local/etc/nsd/db/zone.list"

# the database to use
  database: "/usr/local/etc/nsd/db/nsd.db"

# log messages to file. Default to stderr and syslog (with
# facility LOG_DAEMON). stderr disappears when daemon goes to bg.
  logfile: "/usr/local/etc/nsd/log/nsd.log"

# File to store pid for nsd in.
  pidfile: "/usr/local/etc/nsd/nsd.pid"

# The file where secondary zone refresh and expire timeouts are kept.
# If you delete this file, all secondary zones are forced to be 
# 'refreshing' (as if nsd got a notify).
  xfrdfile: "/usr/local/etc/nsd/db/xfrd.state"

# The directory where zone transfers are stored, in a subdir of it.
  xfrdir: "/usr/local/etc/nsd/tmp"

# don't answer VERSION.BIND and VERSION.SERVER CHAOS class queries
  hide-version: yes 

# identify the server (CH TXT ID.SERVER entry).
  identity: "unidentified server"

# NSID identity (hex string, or "ascii_somestring"). default disabled.
# nsid: "aabbccdd"

# Maximum number of concurrent TCP connections per server.
# tcp-count: 100

# Maximum number of queries served on a single TCP connection.
# By default 0, which means no maximum.
# tcp-query-count: 0

# Override the default (120 seconds) TCP timeout.
# tcp-timeout: 120

# Preferred EDNS buffer size for IPv4.
# ipv4-edns-size: 4096

# Preferred EDNS buffer size for IPv6.
# ipv6-edns-size: 4096

# statistics are produced every number of seconds. Prints to log.
# statistics: 3600

# Number of seconds between reloads triggered by xfrd.
# xfrd-reload-timeout: 1

# check mtime of all zone files on start and sighup
# zonefiles-check: yes

# RRLconfig
# Response Rate Limiting, size of the hashtable. Default 1000000.
# rrl-size: 1000000

# Response Rate Limiting, maximum QPS allowed (from one query source).
# Default 200. If set to 0, ratelimiting is disabled. Also set
# rrl-whitelist-ratelimit to 0 to disable ratelimit processing.
# rrl-ratelimit: 200

# Response Rate Limiting, number of packets to discard before
# sending a SLIP response (a truncated one, allowing an honest
# resolver to retry with TCP). Default is 2 (one half of the
# queries will receive a SLIP response, 0 disables SLIP (all
# packets are discarded), 1 means every request will get a
# SLIP response.
# rrl-slip: 2

# Response Rate Limiting, IPv4 prefix length. Addresses are
# grouped by netblock. 
# rrl-ipv4-prefix-length: 24

# Response Rate Limiting, IPv6 prefix length. Addresses are
# grouped by netblock. 
# rrl-ipv6-prefix-length: 64

# Response Rate Limiting, maximum QPS allowed (from one query source)
# for whitelisted types. Default 2000.
# rrl-whitelist-ratelimit: 2000
# RRLend

# Remote control config section. 

remote-control:
 
# Enable remote control with nsd-control(8) here.
# set up the keys and certificates with nsd-control-setup.
  control-enable: yes 

# what interfaces are listened to for control, default is on localhost.
  control-interface: 127.0.0.1
# control-interface: ::1

# port number for remote control operations (uses TLS over TCP).
  control-port: 8952

# nsd server key file for remote control.
  server-key-file: "/usr/local/etc/nsd/nsd_server.key"

# nsd server certificate file for remote control.
  server-cert-file: "/usr/local/etc/nsd/nsd_server.pem"

# nsd-control key file.
  control-key-file: "/usr/local/etc/nsd/nsd_control.key"

# nsd-control certificate file.
  control-cert-file: "/usr/local/etc/nsd/nsd_control.pem"


# Secret keys for TSIGs that secure zone transfers.
# You could include: "secret.keys" and put the 'key:' statements in there,
# and give that file special access control permissions.
#
key:
# The key name is sent to the other party, it must be the same
name: "secure_key"
# algorithm hmac-md5, or hmac-sha1, or hmac-sha256 (if compiled in)
algorithm: hmac-sha256
# secret material, must be the same as the other party uses.
# base64 encoded random number.
# e.g. from dd if=/dev/random of=/dev/stdout count=1 bs=32 | base64
secret: "D4Xurm0OcyfCxMCcXpnPC/F1LpcRtLIQrlcH4ABxy/Y="


# Patterns have zone configuration and they are shared by one or more zones.
# 
# pattern:
# name by which the pattern is referred to
# name: "myzones"
# the zonefile for the zones that use this pattern.
# if relative then from the zonesdir (inside the chroot).
# the name is processed: %s - zone name (as appears in zone:name).
# %1 - first character of zone name, %2 second, %3 third.
# %z - topleveldomain label of zone, %y, %x next labels in name.
# if label or character does not exist you get a dot '.'.
# for example "%s.zone" or "zones/%1/%2/%3/%s" or "secondary/%z/%s"
# zonefile: "%s.zone"
 
# If no master and slave access control elements are provided,
# this zone will not be served to/from other servers.

# A master zone needs notify: and provide-xfr: lists. A slave
# may also allow zone transfer (for debug or other secondaries).
# notify these slaves when the master zone changes, address TSIG|NOKEY
# IP can be ipv4 and ipv6, with @port for a nondefault port number.
# notify: 192.0.2.1 NOKEY
# allow these IPs and TSIG to transfer zones, addr TSIG|NOKEY|BLOCKED
# address range 192.0.2.0/24, 1.2.3.4&255.255.0.0, 3.0.2.20-3.0.2.40
# provide-xfr: 192.0.2.0/24 my_tsig_key_name
# set the number of retries for notify.
# notify-retry: 5

# uncomment to provide AXFR to all the world
# provide-xfr: 0.0.0.0/0 NOKEY
# provide-xfr: ::0/0 NOKEY

# A slave zone needs allow-notify: and request-xfr: lists.
# allow-notify: 2001:db8::0/64 my_tsig_key_name
# By default, a slave will request a zone transfer with IXFR/TCP.
# If you want to make use of IXFR/UDP use: UDP addr tsigkey
# for a master that only speaks AXFR (like NSD) use AXFR addr tsigkey
# request-xfr: 192.0.2.2 the_tsig_key_name
# Attention: You cannot use UDP and AXFR together. AXFR is always over 
# TCP. If you use UDP, we higly recommend you to deploy TSIG.
# Allow AXFR fallback if the master does not support IXFR. Default
# is yes.
# allow-axfr-fallback: yes
# set local interface for sending zone transfer requests.
# default is let the OS choose.
# outgoing-interface: 10.0.0.10

# if you give another pattern name here, at this point the settings
# from that pattern are inserted into this one (as if it were a 
# macro). The statement can be given in between other statements,
# because the order of access control elements can make a difference
# (which master to request from first, which slave to notify first).
# include-pattern: "common-masters"


# Fixed zone entries. Here you can config zones that cannot be deleted.
# Zones that are dynamically added and deleted are put in the zonelist file.
#
# zone:
# name: "example.com"
# you can give a pattern here, all the settings from that pattern
# are then inserted at this point
# include-pattern: "master"
# You can also specify (additional) options directly for this zone.
# zonefile: "example.com.zone"
# request-xfr: 192.0.2.1 example.com.key

# RRLconfig
# Response Rate Limiting, whitelist types
# rrl-whitelist: nxdomain
# rrl-whitelist: error
# rrl-whitelist: referral
# rrl-whitelist: any
# rrl-whitelist: rrsig
# rrl-whitelist: wildcard
# rrl-whitelist: nodata
# rrl-whitelist: dnskey
# rrl-whitelist: positive
# rrl-whitelist: all
# RRLend

  zone:
   name: "unixexplore.com"
   zonefile: unixexplore.com.forward
   allow-notify: 192.168.9.1 secure_key
   allow-notify: 127.0.0.1 NOKEY
   request-xfr: AXFR 192.168.9.1@5053 secure_key
 
  zone:
   name: "9.168.192.in-addr.arpa"
   zonefile: unixexplore.com.reverse
   allow-notify: 192.168.9.1 secure_key
   allow-notify: 127.0.0.1 NOKEY
   request-xfr: AXFR 192.168.9.1@5053 secure_key
```



## F. Create a Rotation Log file

Since NSD will generate a large number of log entries depending on the verbosity level, managing log rotation is critical. The script below is required on both NSD Master and Slave Servers.

Add the script below to the file `/etc/newsyslog.conf`.

```console
root@ns1:~ # cd /usr/local/etc/nsd/log
root@ns1:/usr/local/etc/nsd/log # ee /etc/newsyslog.conf
/usr/local/etc/nsd/log/nsd.log  bind:wheel     640  7     *    @T12  R   /usr/local/etc/nsd/log_reopen
```

Create a `log_reopen` file in the `/usr/local/etc/nsd` folder, enter the script below.


```console
root@ns1:~ # cd /usr/local/etc/nsd
root@ns1:/usr/local/etc/nsd # touch log_reopen
root@ns1:/usr/local/etc/nsd # ee log_reopen

# !/bin/sh
# This script restarts NSD after log rotation by newsyslog(8)
/usr/local/sbin/nsd-control log_reopen
exit 0
```

Create permissions on the `log_reopen` file.


```console
root@ns1:/usr/local/etc/nsd # chown -R nsd:nsd /usr/local/etc/nsd/log_reopen
```

When you update the zone file with new DNS records and increase the domain serial number, NSD will update the NSD Slave Server, at the time the zone file is reloaded using nsd-control reload or if the nsd service is restarted from the NSD Master Server.

Since the NSD database is updated with the changed zone information, the actual zone files, in our case, unixexplore.com.forward and unixexplore.com.reverse are not updated on the Slave NSD Server.

However, NSD provides the nsd-control write utility to perform this task. It is recommended to use a cron job once a day to update the text zone files on the NSD Master and Slave Servers.

```console
root@ns1:/usr/local/etc/nsd # touch /usr/local/etc/nsd/zone_write
root@ns1:/usr/local/etc/nsd # ee /usr/local/etc/nsd/zone_write

#!/bin/sh
#This script writes the zone files to the NSD Slave Server
/usr/local/sbin/nsd-control write
exit 0
```

<br/>

```console
root@ns1:/usr/local/etc/nsd # ee /etc/crontab

00     08     *     *     *     /usr/local/etc/nsd/zone_write
```

<br/>

```console
root@ns1:/usr/local/etc/nsd # chown -R nsd:nsd /usr/local/etc/nsd/zone_write
```

Restart NSD.

```console
root@ns1:/usr/local/etc/nsd # service nsd restart
Stopping nsd.
Waiting for PIDS: 954.
Starting nsd.
root@router1:~ #
```

Up to now, NSD has been running well, but cannot be used yet. The NSD is RUNNING but not working, why? At the beginning of the article we discussed, the NSD Server functions with the Unbound DNS Server. So that the NSD Server can function properly, we must add the following script to the unbound.conf file in the `/usr/local/etc/unbound` folder.

The following script is added to the `unbound.conf` file on both the Master and Slave computers.

<br/>

**Script /usr/local/etc/unbound/unbound.conf on the NSD Master server.**

```
stub-zone:
   name: "unixexplore.com"
   stub-addr: 192.168.5.2@5053

   stub-zone:
   name: "9.168.192.in-addr.arpa."
   stub-addr: 192.168.5.2@5053
```


**Script /usr/local/etc/unbound/unbound.conf on the NSD Slave server.**
```
stub-zone:
   name: "unixexplore.com"
   stub-addr: 192.168.5.3@5053

   stub-zone:
   name: "9.168.192.in-addr.arpa."
   stub-addr: 192.168.5.3@5053
```

You can place the script in unbound.conf above at the end of the `/usr/local/etc/unbound/unbound.conf` file. Now restart the NSD again.

```console
root@ns1:/usr/local/etc/nsd # service nsd restart
Stopping nsd.
Waiting for PIDS: 954.
Starting nsd.
root@router1:~ #
```
Now your server computer has the NSD application installed which is RUNNING and can function properly together with Server Unbound.

In this article, NSD as an Authoritative DNS Server has been configured for internal LAN DNS resolution. Combining unbound together with nsd is an effective combination as a replacement for Bind, to serve DNS servers and authoritative name servers for clients that require DNS.