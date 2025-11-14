---
title: Creating and Configuring a DNSSEC Root Zone With Bind DNS Server
date: "2025-07-25 13:32:21 +0100"
updated: "2025-07-25 13:32:21 +0100"
id: create-root-dns-zone-bind-freebsd-server
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: DNSServer
background: https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/images/17dns_structure_comparison_diagram.jpg
toc: true
comments: true
published: true
excerpt: Millions of devices communicate with DNS servers every day. Often, users don't realize that every domain name we retrieve originates from the root zone. The existence of the root zone is crucial, if you remove or delete the root zone, the internet will not function because it will not have access to the DNS server.
keywords: root, root zone, dns, bind, isc, dns server, freebsd, openbsd, zone, dnssec
---

Millions of devices communicate with DNS servers every day. Often, users don't realize that every domain name we retrieve originates from the root zone. The existence of the root zone is crucial, if you remove or delete the root zone, the internet will not function because it will not have access to the DNS server.

As part of your DNS server configuration, it's also possible to create and configure an internal root zone for a specific environment. When we create one manually, DNS forwarding and DNS Root Hints, which resolve external DNS queries, are automatically disabled. This is how we can prevent external name resolution by using the internal root zone.

The root zone is the starting point for all DNS queries. Understanding its role is crucial when troubleshooting and understanding DNS resolution. Once we create the root zone, it acts as the parent zone for all other zones.

This article explains the steps required to create a local, augmented-signed root zone and DNSSEC. This tutorial requires an understanding of DNS concepts and a basic knowledge of DNSSEC. We'll use **FreeBSD 14** to configure the root zone with DNSSEC on the BIND DNS Server.


## A. What is the Root Zone and Why is it Important?

Domain names are read from right to left, with the rightmost segment representing the most general domain level (TLD) and the leftmost segment representing the most specific domain level. DNS queries follow this same logic. When a query is performed, the DNS resolver starts at the Root Zone, then moves to the Top-Level Domain (TLD), and finally reaches a specific subdomain or host.

Consider this analogy: if `"unixwinbsd.site"` represents a property within the broader `".site"` domain, then `"linuxfoundation.org"` is a property within `".org."` Here, the Root Zone functions like Earth—every domain, regardless of its specificity, is ultimately a subdivision of the Root Zone.

![dns structure comparison diagram](https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/images/17dns_structure_comparison_diagram.jpg)

For example, when you search for `"facebook.com,"` the query starts in the Root Zone, continues through the TLD `"com,"` and then reaches the specific subdomain `"facebook."` Technically, the Root Zone maintains a list of all TLDs. As discussed in the previous lesson, DNS zones delegate authority and responsibility for a group of domain names to specific organizations. VeriSign, for example, manages the TLD `".com."` Meanwhile, the Root Zone itself is managed by IANA (Internet Assigned Numbers Authority) under the auspices of ICANN (Internet Corporation for Assigned Names and Numbers). Think of ICANN as the global governing body that ensures the smooth operation of the internet's naming infrastructure.
IANA's job is to maintain accurate and secure data about every top-level domain. This crucial, central role is similar to managing a global address book.


![internet root zone management diagram](https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/images/15internet_root_zone_management_diagram.jpg)


**There are several advantages to running a Root Server locally:**

- The Root zone contains all TLD name servers and their IP addresses. This allows DNS resolvers to bypass the initial query to the Root Servers and directly query the TLD name servers, saving time.
- Because the Root zone runs locally, queries for non-existent top-level domain (TLD) names are resolved locally.
- This also improves resiliency because the Root zone is local and thus does not directly depend on the Root Servers for recursive resolution.

**There are several disadvantages to running a Root Server locally:**

- If there are updates to the Root zone, those changes will take a little longer to sync to your local Root zone. Although there shouldn't be much of a noticeable issue.
- If your local Root zone isn't updated for any reason and isn't detected, it will expire after 7 days (as per the Root SOA Expiration). This can cause some DNS resolvers to fail to resolve any queries when the cache expires. However, Technitium DNS Servers will fall back to root hints in such cases.

Considering the pros and cons, it is a good idea to have a Root zone locally for recursive resolvers.

## B. ISC Bind DNS Server Installation Process on FreeBSD

To use the root zone, you must install a DNS server. You can select one from the available DNS server applications. In this article, we will use the ISC Bind application as the DNS server. To install ISC Bind on `FreeBSD 14`, you can use the ports system or the PKG package. Below is an example of installing ISC Bind and its dependencies using the PKG package.

```yml
root@ns3:~ # pkg install bind-tools pkgconf gmake autoconf automake libtool libnghttp2 libuv libidn2 lmdb libxml2 libedit libxkbcommon libxslt wayland protobuf
```

The version of ISC Bind we are using is version `bind918`, run the command below to install ISC Bind.

```yml
root@ns3:~ # pkg install bind918
```

After you've installed ISC Bind, you'll need to configure it. This article doesn't explain how to configure the Bind DNS Server. You can read our previous article, [Configuring ISC Bind DNS As Frontend and Unbound Backend For Caching and Forwarding](https://unixwinbsd.site/en/freebsd/2025/02/05/bind-dns-frontend-unbound-backend-freebsd/)  and [How to Enable DNSSEC Bind DNS Server On FreeBSD](https://unixwinbsd.site/en/freebsd/2025/06/06/enable-dnssec-bind-dns-server-freebsd/)


## C. Root Zone Setup With DNSSEC

The root zone is available from ICANN DNS servers via zone transfer (AXFR-over-TCP):
- xfr.cjr.dns.icann.org (192.0.47.132, 2620:0:2830:202::132)
- xfr.lax.dns.icann.org (192.0.32.132, 2620: 0: 2d0: 202:: 132)

The following Root Servers also support zone transfers (AXFR-over-TCP):
- b.root-servers.net (199.9.14.201, 2001:500:200::b)
- c.root-servers.net (192.33.4.12, 2001:500:2::c)
- d.root-servers.net (199.7.91.13, 2001: 500: 2d:: d)
- f.root-servers.net (192.5.5.241, 2001: 500: 2f:: f)
- g.root-servers.net (192.112.36.4, 2001:500:12::d0d)
- k.root-servers.net (193.0.14.129, 2001: 7fd:: 1)

### c.1. Download named.root

You can download any of the root zone sources listed above. Below is the command used to download the root zone.

```yml
root@ns3:~ # mkdir -p /usr/local/etc/namedb/root
root@ns3:~ # cd /usr/local/etc/namedb/root
root@ns3:/usr/local/etc/namedb/root #
```

The above command is used to create a directory for the root zone. After that, you can directly download the root zone.

```console
root@ns3:/usr/local/etc/namedb/root # dig @xfr.cjr.dns.icann.org . axfr +onesoa | grep -v DNSKEY > named.root
root@ns3:/usr/local/etc/namedb/root # dig @xfr.lax.dns.icann.org . axfr +onesoa | grep -v DNSKEY > named.root

or

root@ns3:/usr/local/etc/namedb/root # dig @k.root-servers.net . axfr +onesoa | grep -v DNSKEY > named.root
root@ns3:/usr/local/etc/namedb/root # dig @f.root-servers.net . axfr +onesoa | grep -v DNSKEY > named.root
```

You can choose any of the example commands above, but pay attention to the `"dot"` after org and net. This dot represents the **root zone**. From the example command above, we prefer to use the root server **f.root-servers.net**.

You can check the downloaded root zone with the following command.

```yml
root@ns3:/usr/local/etc/namedb/root # named-checkzone . named.root
```

### c.2. Enable DNSSEC for the root zone

We recommend that you enable DNSSEC for the downloaded root zone. Next, we create a new `Zone-Signing-Key (ZSK)` and a `Key-Signing-Key (KSK)` for the **root zone**. The step you have to do is create a `key` directory for the `root zone`.

```yml
root@ns3:/usr/local/etc/namedb/root # mkdir -p /usr/local/etc/namedb/keys/root
root@ns3:/usr/local/etc/namedb/root # cd /usr/local/etc/namedb/keys/root
root@ns3:/usr/local/etc/namedb/keys/root #
```

Then you run the command to create the `ZSK and KSK` keys.

```yml
root@ns3:/usr/local/etc/namedb/keys/root # dnssec-keygen -K /usr/local/etc/namedb/keys/root/ -a RSASHA256 -b 2048 -n ZONE .
root@ns3:/usr/local/etc/namedb/keys/root # dnssec-keygen -K /usr/local/etc/namedb/keys/root/ -a RSASHA256 -b 4096 -f KSK  -n ZONE .
```

Once you have created your `ZSK and KSK` keys, copy them into the `named.root` file.

```yml
root@ns3:/ # cat /usr/local/etc/namedb/keys/root/K.+008+*.key >> /usr/local/etc/namedb/root/named.root
```

Then you run the command below.

```console
root@ns3:~ # dnssec-signzone -o . -t -R -S -K /usr/local/etc/namedb/keys/root/ /usr/local/etc/namedb/root/named.root
dnssec-signzone: warning: /usr/local/etc/namedb/root/named.root:24860: using RFC1035 TTL semantics
Verifying the zone using the following algorithms:
- RSASHA256
Zone fully signed:
Algorithm: RSASHA256: KSKs: 1 active, 0 stand-by, 0 revoked
                      ZSKs: 1 active, 0 stand-by, 0 revoked
/usr/local/etc/namedb/root/named.root.signed
Signatures generated:                     2791
Signatures retained:                         0
Signatures dropped:                       2788
Signatures successfully verified:            0
Signatures unsuccessfully verified:          0
Signing time in seconds:                 4.911
Signatures per second:                 568.249
Runtime in seconds:                      5.701
root@ns3:~ #
```

The above command will produce a new file named `"named.root.signed"` Check the file with the `"named-checkzone"` command.

```yml
root@ns3:/ # named-checkzone . /usr/local/etc/namedb/root/named.root.signed
```

### c.3. Modify the named.conf file

Before you edit the file `/usr/local/etc/namedb/named.conf`, First delete the default FreeBSD root zone file, namely `"named.root"`.

```yml
root@ns3:/ # rm -f /usr/local/etc/namedb/named.root
```

Then you open the file `/usr/local/etc/namedb/named.conf`, search script **zone "." { type hint; file "/usr/local/etc/namedb/named.root"; };**. You must replace this script with the script below.

```console
zone "." {
        type master;
        file "/usr/local/etc/namedb/root/named.root.signed";
	key-directory "/usr/local/etc/namedb/keys/root";
        inline-signing yes;
};
```

To activate the root zone you have to restart the DNS server.

```yml
root@ns3:/ # service named restart
```

This is the time to check the BIND configuration and all zone-files:

```yml
root@ns3:/ # named-checkconf -z
root@ns3:~ # named-checkconf /usr/local/etc/namedb/named.conf
root@ns3:~ # named-checkzone . /usr/local/etc/namedb/root/named.root.signed

```

If `named-checkconf` and `named-checkzone` doesn't report any errors, it means the root zone you configured is active and usable.

## D. Create trust-anchors

A trust anchor is a key that is placed into a validating resolver so that the validator can verify the results for a given request back to a known or trusted public key (the trust anchor). A validating resolver must have at least one trust anchor installed in order to perform DNSSEC validation.

To create trust anchors, you must delete the bind.keys file and recreate it. Before deleting the bind.keys file, check the KSK and DS keys in the root zone. Here's how to view these keys.

`Note:` The KSK key you must use to create trust anchors

```console
root@ns3:/usr/local/etc/namedb/keys/root # ls -la
total 37
drwxr-xr-x  2 root wheel   10 Jul 25 18:35 .
drwxr-xr-x  4 root wheel    4 Jul 25 14:46 ..
-rw-r--r--  1 root wheel  584 Jul 25 14:47 K.+008+50040.key
-rw-------  1 root wheel 1776 Jul 25 14:47 K.+008+50040.private
-rw-r--r--  1 root wheel  929 Jul 25 14:47 K.+008+53054.key
-rw-------  1 root wheel 3316 Jul 25 14:47 K.+008+53054.private
root@ns3:/usr/local/etc/namedb/keys/root #
```

In the `ls` command above, the file `K.+008+53054.key` contains the `KSK key`. Now let's look at the contents of the `K.+008+53054.key` file script.

```console
root@ns3:~ # cat /usr/local/etc/namedb/keys/root/K.+008+53054.key
; This is a key-signing key, keyid 53054, for .
; Created: 20250725074726 (Fri Jul 25 14:47:26 2025)
; Publish: 20250725074726 (Fri Jul 25 14:47:26 2025)
; Activate: 20250725074726 (Fri Jul 25 14:47:26 2025)
. IN DNSKEY 257 3 8 AwEAAfoKpuqhYTiRxbDLkbdXwtS4ipRxMUtS9V+8oOp7EDg9aK+rQboj 4ymgsq+QBC2VyET7jkgY9uE37mKYS/s8Hu5vLx8UgS+Xw9mz01vq9stl EXpv7r8uYc6nWH11IRWJTVHnZf9bM9vtJzQ4xPIYWO04CVz4XCK0AlKv ZzLyKWZ/fFwRZMRDrYNht5/MtAzKIixFMAr1s1f9m7IlM7CUlcclfFOZ wYIuxK/TtepbvZuPgdrwt87WuC1bZqvl4t4eRngEoQM420tSQJuLSWjf P1YxQ2ju3Qu/OFSNvpFJJk6O7Rw6RFrnoBcf3gcXlL7ApjY6b2xZkoDV y+Fw78ZxIKA/2scK/uYyyFST/QV06LbBUiJrG+VSbY4m9KQvn9uimdzc wIYapPes7U6NiXZ7Iyrvs7KxnD8R3KIFz1y5vqItRGdtVbXWhz1NaSf3 fbaBDuLJX27Pa8rajncwleym8sdGgaLHitYemgqy1WDrU/PoIpn0YrrU S2Jz4JTo3d5qUjI/zE8GvfhcpkhsclysOWT9/r5vVTqvmghHwkXSpDsM U85l3pHuwVcIg91DsqWCt0VcEVPZCXby7za4/P9jJM/6Ewkpof8y9mpy 5nKTUmOHtTd6GEHlKCmTVdPICK9pCqNIFEvOJspwCxyfJDroW6mRF8C+ 4F8G7cXIfN5fJYnR
root@ns3:~ #
```

After that we look at the DS key of the root zone.

`Note:` The KSK key you must use to generate the `DS key`.

```console
root@ns3:~ # dnssec-dsfromkey /usr/local/etc/namedb/keys/root/K.+008+53054.key
. IN DS 53054 8 2 9B35E2D6EE36733B5D1506892293A87DE0C28A595D1F3A9A224B9384917A9D5B
```

Now we start entering the `KSK and DS` keys into the `bind.keys` file.

```yml
root@ns3:~ # rm -f /usr/local/etc/namedb/bind.keys
root@ns3:~ # touch /usr/local/etc/namedb/bind.keys
root@ns3:~ # chown -R root:bind /usr/local/etc/namedb/bind.keys
root@ns3:~ # chmod -R 640 /usr/local/etc/namedb/bind.keys
```

After that, in the `/usr/local/etc/namedb/bind.keys` file, enter the `KSK and DS` keys that you generated above. Pay attention to the example of the contents of the script file **/usr/local/etc/namedb/bind.keys** below.

```console
trust-anchors {

. initial-key 257 3 8 "AwEAAfoKpuqhYTiRxbDLkbdXwtS4ipRxMUtS9V+8oOp7EDg9aK+rQboj 4ymgsq+QBC2VyET7jkgY9uE37mKYS/s8Hu5vLx8UgS+Xw9mz01vq9stl EXpv7r8uYc6nWH11IRWJTVHnZf9bM9vtJzQ4xPIYWO04CVz4XCK0AlKv ZzLyKWZ/fFwRZMRDrYNht5/MtAzKIixFMAr1s1f9m7IlM7CUlcclfFOZ wYIuxK/TtepbvZuPgdrwt87WuC1bZqvl4t4eRngEoQM420tSQJuLSWjf P1YxQ2ju3Qu/OFSNvpFJJk6O7Rw6RFrnoBcf3gcXlL7ApjY6b2xZkoDV y+Fw78ZxIKA/2scK/uYyyFST/QV06LbBUiJrG+VSbY4m9KQvn9uimdzc wIYapPes7U6NiXZ7Iyrvs7KxnD8R3KIFz1y5vqItRGdtVbXWhz1NaSf3 fbaBDuLJX27Pa8rajncwleym8sdGgaLHitYemgqy1WDrU/PoIpn0YrrU S2Jz4JTo3d5qUjI/zE8GvfhcpkhsclysOWT9/r5vVTqvmghHwkXSpDsM U85l3pHuwVcIg91DsqWCt0VcEVPZCXby7za4/P9jJM/6Ewkpof8y9mpy 5nKTUmOHtTd6GEHlKCmTVdPICK9pCqNIFEvOJspwCxyfJDroW6mRF8C+ 4F8G7cXIfN5fJYnR";

. initial-ds 53054 8 2 "9B35E2D6EE36733B5D1506892293A87DE0C28A595D1F3A9A224B9384917A9D5B";

};
```

The dot in `. initial-key` and `. initial-ds`, means that the zone used is the `root zone`.

Restart your DNS server, and you're done.

You can choose your root zone server as you like; I prefer using the **OPENNIC** root zone server.

DNS root servers are technically nothing special. Apart from their privileged position, they are no different from other authoritative resolvers. If the root server currently in use goes down, simply configure and "promote" another cluster to replace it.

The configuration and "promotion" process is also straightforward, using existing software to load existing data. Therefore, there's no need to worry about major repercussions from DNS root server outages.