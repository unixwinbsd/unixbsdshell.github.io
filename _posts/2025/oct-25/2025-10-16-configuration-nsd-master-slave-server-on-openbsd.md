---
title: How to Configure NSD Master and Slave Servers on OpenBSD
date: "2025-10-16 08:25:41 +0100"
updated: "2025-10-16 08:25:41 +0100"
id: configuration-nsd-master-slave-server-on-openbsd
lang: en
author: Iwan Setiawan
robots: index, follow
categories: openbsd
tags: DNSServer
background: /img/oct-25/oct-25-84.jpg
toc: true
comments: true
published: true
excerpt: Despite all its benefits, there are several reasons not to pursue DNSSEC. Configuring and maintaining DNSSEC keys is entirely manual in most major DNS server implementations. In this section, we will configure zones on both nodes and test them, how to transfer them, and how to query the new zones.
keywords: freebsd, dns, dns server, nsd, master, slave, server, key, tsig, rndc
---

The NLnet Labs Name Server Daemon, or NSD, is an authoritative DNS name server. It is designed to operate in environments that prioritize speed, reliability, stability, and security. NSD adheres to a high-performance philosophy, meaning it can handle hundreds of thousands or even millions of queries per second.

As an authoritative DNS name server, NSD does not provide any caching, forwarding, or recursion. NSD only responds to repeated requests for the zones it controls. NSD can also refer resolvers to other name servers for zones it has delegated.

For the purposes of this guide, we will configure two servers with NSD software to act as the primary and secondary servers for the name server zones. In this article, we will use OpenBSD as the operating system for installing the NSD servers.

![NSD master and slave in OpenBSD](/img/oct-25/oct-25-84.jpg)


## 1. How to Configure a Zone Without DNSSec on NSD

Despite all its benefits, there are several reasons not to pursue DNSSEC. Configuring and maintaining DNSSEC keys is entirely manual in most major DNS server implementations.

Setup is quite complicated, and the limited key lifetime has serious connectivity implications. Incorrectly configuring keys, or failing to rotate keys before the old keys expire, can render entire domains unreachable on the public Internet. While workarounds exist, they involve restarting the nameservers and domain registrars. To enable DNSSEC, keys must be rotated before they expire.

In this section, we will configure zones on both nodes and test them, how to transfer them, and how to query the new zones.

### a. Preparing the Master node

You'll need to create a zone file in `/var/nsd/zones/master`. There are several ways to do this. While the configuration we've presented isn't the best, it's worth a try.


```console
ns1# cat kursor.my.id.zone

$ORIGIN             restauradordeleyes.cloud.
$TTL    300
@           3600 IN SOA   ns1.kursor.my.id. kursor.my.id. (
               2021041320  ; serial
               1440        ; refresh
               3600        ; retry
               4800        ; expire
               600 )       ; minimum TTL

@		IN	NS      ns1.kursor.my.id.
@		IN	NS      ns2.kursor.my.id.

ns1		IN	A       192.168.5.3
ns2		IN	A       192.168.5.5
www	IN	A       192.168.5.99
```

After that, you can check the zones you have created above.


```
ns1# nsd-checkzone kursor.my.id restauradordeleyes.cloud.zone
zone kursor.my.id is ok
ns1#
```

Create a tsig key. You need to install the ldns tool and then use the contents of the private key.


```
ns1# ldns-keygen -r /dev/urandom -a hmac-sha512 kursor.my.id
Kkursor.my.id.+165+35358
```

<br/>


After that, we check the TSIG key
```
ns1# ls -ltrh|grep -i kursor.my.id
-rw-------  1 root  wheel   148B Apr 13 22:41 Kkursor.my.id.+165+35358.private
-rw-r--r--  1 root  wheel   123B Apr 13 22:41 Kkursor.my.id.+165+35358.key
```

The tsig key you created above is very useful for configuring the NSD server. The next step is to add the tsig key to the `"nsd.conf"` file.


```
key:
        name: "kursor.my.id"
        algorithm: hmac-sha256
        secret: "xxxxx=="


zone:
        name: "kursor.my.id"
        zonefile: "master/kursor.my.id.zone"
        notify: 192.168.5.5 kursor.my.id
        provide-xfr: 192.168.5.5 kursor.my.id
```

Then check the configuration status of the main nsd.conf file, whether there are any errors or not.


```
ns1# nsd-checkconf /var/nsd/etc/nsd.conf
```

You can also check the log files from the NSD server.

```
ns1# tail -f /var/log/nsd.log
```

If there are any errors, you can check them later, as we haven't configured the second node yet. Now, run a quick internal query to check the status of the NSD server.


```
ns1# dig kursor.my.id @192.168.5.3
ns1# nsd-control zonestatus
```


### b. Preparing the Slave Node

In this section, we will configure the slave node. You will need to define an entry in the nsd.conf file. Use the same tsig key you created on the master node.


```
key:
        name: "kursor.my.id"
        algorithm: hmac-sha256
        secret: "xxxxx=="


zone:
        name: "kursor.my.id"
        zonefile: "master/kursor.my.id.zone"
        allow-notify: 192.168.5.3 kursor.my.id
        request-xfr: 192.168.5.3 kursor.my.id
```


### c. Test

Once all nodes have been created, both on the server and the slave, the final step is to verify the configuration we created above. Run the following command to verify each zone on the master and slave.


```
ns1# nsd-checkconf /var/nsd/etc/nsd.conf
ns1# nsd-control zonestatus
ns1# tail -f /var/log/nsd.log
ns1# dig ANY kursor.my.id. @192.168.5.5 +norec +short
ns1# nsd-control write kursor.my.id
```

<br/>

```
ns1# dig axfr kursor.my.id @ns1.kursor.my.id
ns1# dig axfr kursor.my.id @ns2.kursor.my.id
```

Using this guide, you should now have a primary and secondary NSD server that can be used solely to serve DNS information about your domain. Unlike Bind, NSD is optimized for high-performance authoritative behavior, so you can get better performance tailored specifically to your needs.