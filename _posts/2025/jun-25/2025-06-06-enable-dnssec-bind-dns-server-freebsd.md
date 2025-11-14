---
title: How to Enable DNSSEC Bind DNS Server On FreeBSD
date: "2025-06-06 08:25:05 +0100"
updated: "2025-06-06 08:25:05 +0100"
id: enable-dnssec-bind-dns-server-freebsd
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: DNSServer
background: https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/img/DNSSEC_validating_process.jpg
toc: true
comments: true
published: true
excerpt: DNSSEC is certainly different from DNS. This can be seen from the function of DNS and DNSSEC itself. Regarding DNSSEC itself, it has an important role to prevent DNS Spoofing from happening. It is a hacking method which will prevent the original information from returning to the accessor who uses it
keywords: dnssec, isc-bind, dns, server, named, zsk, ksk, freebsd, master, slave, key, dnssec keygen, root
---

Many companies or personal computers are protected with various security methods, such as the use of anti-virus or the implementation of firewall routers that limit access to data. This is done to protect your business or computer from cybersecurity threats through your website.

However, what companies generally do to secure their computer networks is to implement a domain security system with DNSSEC. Because many intruders try to enter your system through port 53 or DNS server. This port is believed to have many weaknesses and its security system must be improved.

DNSSEC is certainly different from DNS. This can be seen from the function of DNS and DNSSEC itself. Regarding DNSSEC itself, it has an important role in preventing DNS Spoofing from occurring. It is a hacking method which will prevent the original information from returning to the user who uses it. While the DNS server is used to change the domain name to a public IP like you are accessing a website. Basically you are opening a public IP, open a website domain name.

This tutorial will help you configure DNSSEC on a FreeBSD server with ISC Bind Named. The contents of this article contain reference guides and information needed for system administrators or for those of you who want to implement DSSSEC on a FreeBSD server with DNS Bind.

If your FreeBSD server does not have Bind DNS server installed, you can start installing it or read the Bind DNS server installation guide on the FreeBSD system.

## A. System Specifications
- OS: FreeBSD 14.3 Stable
- Hostname: ns3
- IP Address: 192.168.5.3
- Bind Version: BIND 9.18.37
- Zone: unixwinbsd.cloud and 5.168.192.in-addr.arpa

## B. About DNSSEC
At the beginning of the publication of the Domain Name System (DNS) it was designed without an accompanying security system. Because at that time there were still very few people who used the internet network. But now, the internet is a necessity and part of human life.

DNS Security Extensions (DNSSEC) addresses the need for DNS security, namely, by adding a digital signature to DNS data, so that each DNS response can be verified for its integrity (the message has not changed during transit) and its authenticity (the data comes from the real source, not a fraudster).

DNSSEC (Domain Name System Security Extensions) adds resource records and message header bits that can be used to verify that the requested data matches what the zone administrator entered into the zone and has not been changed during transit.

The DNSSEC resource record types are:
**RRSIG (for digital signature)**
`RRSIG` With DNSSEC enabled, almost every DNS response (A, PTR, MX, SOA, DNSKEY, etc.) will be accompanied by at least one RRSIG, or resource record signature. This signature is used by recursive name servers, also known as validating resolvers, to verify the response received.

**DNSKEY (public key)**
`DNSKEY` DNSSEC relies on public key cryptography for authenticity and integrity of data. There are multiple keys used in DNSSEC, some private, some public. The public key is published worldwide as part of the zone data, and is stored in a DNSKEY record type. In general, there are two categories of keys used in DNSSEC, namely the Zone Signing Key (ZSK) which is used to protect all zone data, and the Key Signing Key (KSK) which is used to protect other keys.

**DS Delegation Signer**
`DS` One of the key components of DNSSEC is that a parent zone can "vouch" for its child zones. A DS record is verifiable information (generated from one of the child's public keys) that a parent zone publishes about its child as part of the chain of trust.

**NSEC (Pointer to next secure record)**
The `NSEC` record is used to prove that something really doesn't exist, by giving the name before and after it.

While the message header bits used by DNSSEC are:
- **AD:** For authenticated data, and
- **CD:** Checking is disabled.

### b.1. DNSSEC Infrastructure
DNSSEC is implemented in three main components of the DNS infrastructure, namely:
1. **Recursive Server:** People use recursive servers to look up external domain names like www.example.com. Recursive server operators need to enable DNSSEC validation. By enabling validation, recursive servers will perform additional tasks on every DNS response they receive to ensure its authenticity.
2. **Authoritative Server:** People who publish DNS data on their name servers need to sign that data. This requires creating additional resource records, and publishing them to parent domains if necessary. With DNSSEC enabled, authoritative servers will respond to requests with additional DNS data, such as signatures and digital keys, in addition to the standard response.
3. **Application:** This component is present on every client machine, from web servers to smartphones. This includes resolver libraries on various Operating Systems, and applications such as web browsers.

### b.2. How DNSSEC Works

Each DNSSEC-enabled zone has a zone signing key (ZSK) with a public and private component. The private part of the ZSK signs the contents of the zone. The public part validates the signature to the querying resolver.

When DNSSEC validation is enabled, the resolver requests an additional resource record in its query. It asks the authoritative DNS to provide a response with some evidence associated with the answer.

When a DNSSEC-enabled resolver queries for some resource (say an A record), the name server returns three items: the RRset for that record, its RRSIG, and the zone's DNSKEY record (which contains the public ZSK). The resolver uses these three items to validate the record.

When the response is received, the resolver performs several cryptographic checks to verify the authenticity and integrity of the answer. This process is repeated by `get-key`, validate, ask-parent, and its parent until a key is reached and trusted. Only one key is trusted by DNSSEC, the root key.

The figure below can be used to show how DNSSEC works.

<br/>
![DNSSEC validating process](https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/img/DNSSEC_validating_process.jpg)
<br/>

## C. Enable DNSSEC on BIND DNS Server
In this article we do not discuss the ISC Bind DNS server installation process, you can read the previous article that discusses the process.

[Configuring ISC Bind DNS As Frontend and Unbound Backend For Caching and Forwarding](https://unixwinbsd.site/en/freebsd/2025/02/05/bind-dns-frontend-unbound-backend-freebsd/)

[Bind DNS Server with TLS using Stunnel on OpenBSD](https://unixwinbsd.site/en/openbsd/2025/06/03/installing-dns-bind-stunnel-openbsd/)

[Complete Guide to BIND DNS Server Settings for PFSense](https://unixwinbsd.site/en/freebsd/2025/02/06/complete-guide-bind-dns-server-for-pfsense/)

We assume you have installed ISC Bind and it is running normally on the FreeBSD server. To make sure the Bind Dns server is running normally, check the Bind version with the following command.

```console
root@ns3:~ # named -v
root@ns3:~ # dig -t txt -c chaos VERSION.BIND
```

To enable DNSSEC on the ISC Bind DNS server that you have installed on your FreeBSD system, open the file `/usr/local/etc/namedb/named.conf`.

Find the script **options { .......................};**, in the script you type.

```
dnssec-validation yes;
```

You can see how it is written and how it is laid out in the script below.

```
options {
	// All file and path names are relative to the chroot directory,
	// if any, and should be fully qualified.
	directory	"/usr/local/etc/namedb/working";
	pid-file	"/var/run/named/pid";
	dump-file	"/var/dump/named_dump.db";
	statistics-file	"/var/stats/named.stats";
	listen-on port 53 { 192.168.5.3; };
	forwarders { 82.146.59.250; };
	auth-nxdomain no;
	dnssec-validation yes;
	managed-keys-directory "/usr/local/etc/namedb/working/";
	allow-new-zones yes;
	minimal-responses yes;
	recursion yes;
	allow-transfer { trusted; };               
	allow-query { any; };                     
	allow-recursion { any; };
};

zone "." { type hint; file "/usr/local/etc/namedb/named.root"; };
```

## D. Creating DNSSEC KEY
DNSSEC requires a key to verify each incoming and outgoing domain. You can create a DNSSEC key and place it in a special directory. In this example, we will create a DNSSEC key that we will place in the `/usr/local/etc/namedb` directory. See the example of creating a DNSSEC key below.

```console
root@ns3:~ # mkdir -p /usr/local/etc/namedb/keys/unixwinbsd.cloud
root@ns3:~ # cd /usr/local/etc/namedb/keys/unixwinbsd.cloud
root@ns3:/usr/local/etc/namedb/keys/unixwinbsd.cloud #
```

The above command is used to create a directory where the DNSSEC keys are stored. Once you have created the directory, proceed to create the DNSSEC keys. In the example below we will create two pairs of keys:
- A Zone Signing Key (ZSK) pair, and
- A Key Signing Key (KSK) pair.

### d.1. Create `KSK` key

The `KSK` key is used only for signing DNSKEYs. Use the following command to create a `KSK` key.

```console
root@ns3:/usr/local/etc/namedb/keys/unixwinbsd.cloud # dnssec-keygen -f KSK -a ECDSAP256SHA256 -b 4096 -n ZONE unixwinbsd.cloud
Generating key pair.
Kexample.com.+013+49587
root@ns3:/usr/local/etc/namedb/keys/unixwinbsd.cloud #
```

The option description of the above command is:

1. `-f KSK` opsi `-f` indicates that the `KSK` key is being created.

2. `-a ECDSAP256SHA256` encryption algorithm used. The algorithms that can be used by the `-a` option are:

- RSASHA1
- NSEC3RSASHA1 
- RSASHA256 
- RSASHA512 
- ECDSAP256SHA256 
- ECDSAP384SHA384
- ED25519 
- ED448

3. **-b 4096** key size in bits.

- **RSASHA1:** [1024..4096]
- **NSEC3RSASHA1:** [1024..4096]
- **RSASHA256:** [1024..4096]
- **RSASHA512:** [1024..4096]
- **ECDSAP256SHA256:** ignored
- **ECDSAP384SHA384:** ignored
- **ED25519:** ignored
- **ED448:** ignored
(key size defaults are set according to algorithm and usage (ZSK or KSK)

4. **-n ZONE** Zone Name used in Bind configuration **(named.conf)**.


### d.2. Create a ZSK key

A ZSK key is used to sign most zones. This makes changing the ZSK easier (since you can do it without updating the parent). Run the command below to create a ZSK key.

```console
root@ns3:/usr/local/etc/namedb/keys/unixwinbsd.cloud # dnssec-keygen -a ECDSAP256SHA256 -b 2048 -n ZONE unixwinbsd.cloud
```

To see the files produced by the two commands above, you can run the `ls` command.

```console
root@ns3:/usr/local/etc/namedb/keys/unixwinbsd.cloud # ls -lf
total 27
drwxr-xr-x  2 bind bind   6 Jun  6 15:52 .
drwxr-xr-x  3 root bind   3 Jun  6 14:05 ..
-rw-r-----  1 bind bind 187 Jun  6 15:52 Kunixwinbsd.cloud.+013+41408.private
-rw-r-----  1 bind bind 187 Jun  6 15:52 Kunixwinbsd.cloud.+013+23333.private
-rw-r--r--  1 bind bind 352 Jun  6 15:52 Kunixwinbsd.cloud.+013+41408.key
-rw-r--r--  1 bind bind 351 Jun  6 15:52 Kunixwinbsd.cloud.+013+23333.key
```

The two files ending with .private need to be kept secret. These are your private keys, so guard them carefully. You should at least protect them through file permission settings.

The two files ending with .key are your public keys. One is the zone signing key (ZSK), and the other is the Key signing key (KSK).

Pay attention to the table below which explains the comparison and frequency of ZSK and KSK keys.

**Table:** Comparison of ZSK KSK


| Key       | Usage          | Frequency of Use        | 
| ----------- | -----------   | ----------- |
| ZSK Private          | Used by authoritative server to create RRSIG for zone data          | Used somewhat frequently depending on the zone, whenever authoritative zone data changes or re-signing is needed          |
| ZSK Public          | Used by recursive server to validate zone data RRset      | Used very frequently, whenever recursive server validates a response          |
| KSK Private          | Used by authoritative server to create RRSIG for ZSK and KSK Public (DNSKEY)     | Very infrequently, whenever ZSK's or KSK's change (every year or every five years in our examples)          |
| KSK Public          | Used by recursive server to validate DNSKEY RRset          | Used very frequently, whenever recursive server validates a DNSKEY RRset          |

The next step, you run the `chmod` and `chown` commands to provide file access and ownership rights.

```console
root@ns3:/usr/local/etc/namedb/keys/unixwinbsd.cloud # chmod -R g+r /usr/local/etc/namedb/keys/unixwinbsd.cloud/*
root@ns3:/usr/local/etc/namedb/keys/unixwinbsd.cloud # chown -R bind:bind /usr/local/etc/namedb/keys/unixwinbsd.cloud
```

## E. Configuring Zone DNSSEC

After you have created the KSK and ZSK keys, you must create a zone that will be authenticated with DNSSEC. Buka file `/usr/local/etc/namedb/named.conf`. Setelah itu, pada akhir skrip anda buat zona sebagai berikut.

```
zone "unixwinbsd.cloud" {
        type master;
        file "/usr/local/etc/namedb/primary/unixwinbsd.cloud-forward.db";
	allow-transfer { trusted; };
	key-directory "/usr/local/etc/namedb/keys/unixwinbsd.cloud";
	inline-signing yes;
	//dnssec-policy "default";
	update-policy local;
	sig-validity-interval 20 10;
};
```

### e.1. Creating a Zone File
In the third script of the example above, you must create a zone **unixwinbsd.cloud-forward.db**. Run the touch command to create the zone.

```console
root@ns3:~ # touch /usr/local/etc/namedb/primary/unixwinbsd.cloud-forward.db
```

In the file `/usr/local/etc/namedb/primary/unixwinbsd.cloud-forward.db` you type the following script.

```
$ORIGIN .
$TTL    86400 
unixwinbsd.cloud.    IN SOA  ns3.unixwinbsd.cloud. root.ns3.unixwinbsd.cloud. (
                        2010022201 ; Serial
                        86400           ; Refresh (24 hours)
                        3600             ; Retry (1 hour)
                        172800         ; Expire (48 hours)
                        3600             ; Minimum (1 hour)
                )
unixwinbsd.cloud.		IN	NS      ns3.unixwinbsd.cloud.


$ORIGIN unixwinbsd.cloud.
ns3.unixwinbsd.cloud.	IN	A       192.168.5.3
www.unixwinbsd.cloud	IN	CNAME	unixwinbsd.cloud


$INCLUDE	/usr/local/etc/namedb/keys/unixwinbsd.cloud/Kunixwinbsd.cloud.+013+00250.key
$INCLUDE 	/usr/local/etc/namedb/keys/unixwinbsd.cloud/Kunixwinbsd.cloud.+013+09678.key
```

After that, run the restart command, so that all the changes can be applied immediately.

```
root@ns3:~ # service named restart
```

### e.2. Signing Zone Key

At the top you have created the `KSK and ZSK` keys, so that the keys can be used immediately you must sign both keys. Before you sign both keys, first see the contents of the files in the `/usr/local/etc/namedb/primary` directory with the `ls` command.

```console
root@ns3:~ # cd /usr/local/etc/namedb/primary
root@ns3:/usr/local/etc/namedb/primary # ls -l
total 23
-rw-r--r--  1 root wheel 148 Jun  3 15:15 empty.db
-rw-r--r--  1 root wheel 158 Jun  3 15:15 localhost-forward.db
-rw-r--r--  1 root wheel 226 Jun  3 15:15 localhost-reverse.db
-rw-r--r--  1 root bind  752 Jun  6 20:44 unixwinbsd.cloud-forward.db
-rw-r--r--  1 root bind  593 Jun  6 20:27 unixwinbsd.cloud.org-rev.db
root@ns3:/usr/local/etc/namedb/primary #
```

You note and remember the contents of the directory.

After that, run the following command to sign the `KSK and ZSK` keys.

```console
root@ns3:~ # dnssec-signzone -o unixwinbsd.cloud -e +6mo -N INCREMENT -K /usr/local/etc/namedb/keys/unixwinbsd.cloud /usr/local/etc/namedb/primary/unixwinbsd.cloud-forward.db
Verifying the zone using the following algorithms:
- ECDSAP256SHA256
Zone fully signed:
Algorithm: ECDSAP256SHA256: KSKs: 1 active, 0 stand-by, 0 revoked
                            ZSKs: 1 active, 0 stand-by, 0 revoked
/usr/local/etc/namedb/primary/unixwinbsd.cloud-forward.db.signed
root@ns3:~ #
```

After that, look again at the contents of the `/usr/local/etc/namedb/primary` directory.

```console
root@ns3:/usr/local/etc/namedb/primary # ls -l
total 32
-rw-r--r--  1 root bind   100 Jun  6 20:38 dsset-unixwinbsd.cloud.
-rw-r--r--  1 root wheel  148 Jun  3 15:15 empty.db
-rw-r--r--  1 root wheel  158 Jun  3 15:15 localhost-forward.db
-rw-r--r--  1 root wheel  226 Jun  3 15:15 localhost-reverse.db
-rw-r--r--  1 root bind   752 Jun  6 20:44 unixwinbsd.cloud-forward.db
-rw-r--r--  1 root bind  2812 Jun  6 20:38 unixwinbsd.cloud-forward.db.signed
-rw-r--r--  1 root bind   593 Jun  6 20:27 unixwinbsd.cloud.org-rev.db
```

Try, you pay attention to the contents of the directory, there is an additional file. The file `unixwinbsd.cloud-forward.db.signed` we will use or apply in the file `/usr/local/etc/namedb/named.conf`. Its function is to activate the zone key.

### e.3. Activating Zones (KSK and ZSK Keys)

Although you have signed the zone key, it cannot be used yet. To activate both keys so that they can be used immediately, edit the file `/usr/local/etc/namedb/primary/unixwinbsd.cloud-forward.db`, ​​and change it in the zone script, as in the following example.

```
zone "unixwinbsd.cloud" {
        type master;
//        file "/usr/local/etc/namedb/primary/unixwinbsd.cloud-forward.db";
        file "/usr/local/etc/namedb/primary/unixwinbsd.cloud-forward.db.signed";
	allow-transfer { trusted; };
	key-directory "/usr/local/etc/namedb/keys/unixwinbsd.cloud";
	inline-signing yes;
	//dnssec-policy "default";
	update-policy local;
	sig-validity-interval 20 10;
};
```

Run the restart command to update the changes.

```
root@ns3:~ # service named restart
```

## F. Configuring Zone Reverse - zone "5.168.192.in-addr.arpa"

To configure DNSSEC on the zone `"5.168.192.in-addr.arpa"`, the method is almost **the same as above**. So, we will not explain step by step, you just follow the method above to configure DNSSEC on the `zone "5.168.192.in-addr.arpa"`.

## G. Test Zone

After you have followed all the steps above, in this section we will check the zones above. This is to ensure whether DNSSEC has been applied to each zone or not.

The easiest way to check the zone is to run the `dig` command as in the example below.

```console
root@ns3:~ # dig DNSKEY unixwinbsd.cloud. @192.168.5.3 +multiline

; <<>> DiG 9.20.9 <<>> DNSKEY unixwinbsd.cloud. @192.168.5.3 +multiline
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 14398
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 0, AUTHORITY: 1, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 1232
; COOKIE: eff34e4029b03246010000006842f88cd3f76447c6d54f14 (good)
;; QUESTION SECTION:
;unixwinbsd.cloud.      IN DNSKEY

;; AUTHORITY SECTION:
unixwinbsd.cloud.       3600 IN SOA ns3.unixwinbsd.cloud. root.ns3.unixwinbsd.cloud. (
                                2010022202 ; serial
                                86400      ; refresh (1 day)
                                3600       ; retry (1 hour)
                                172800     ; expire (2 days)
                                3600       ; minimum (1 hour)
                                )

;; Query time: 0 msec
;; SERVER: 192.168.5.3#53(192.168.5.3) (UDP)
;; WHEN: Fri Jun 06 21:17:48 WIB 2025
;; MSG SIZE  rcvd: 118

root@ns3:~ #
```
<br/>

```console
root@ns3:~ # dig A unixwinbsd.cloud. @192.168.5.3 +noadditional +dnssec +multiline

; <<>> DiG 9.20.9 <<>> A unixwinbsd.cloud. @192.168.5.3 +noadditional +dnssec +multiline
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 998
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 0, AUTHORITY: 1, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags: do; udp: 1232
; COOKIE: ac97b028ac60fde1010000006842f8a8b39b05964d536e4c (good)
;; QUESTION SECTION:
;unixwinbsd.cloud.      IN A

;; AUTHORITY SECTION:
unixwinbsd.cloud.       3600 IN SOA ns3.unixwinbsd.cloud. root.ns3.unixwinbsd.cloud. (
                                2010022202 ; serial
                                86400      ; refresh (1 day)
                                3600       ; retry (1 hour)
                                172800     ; expire (2 days)
                                3600       ; minimum (1 hour)
                                )

;; Query time: 0 msec
;; SERVER: 192.168.5.3#53(192.168.5.3) (UDP)
;; WHEN: Fri Jun 06 21:18:16 WIB 2025
;; MSG SIZE  rcvd: 118

root@ns3:~ #
```

After we have added DS entries to the registry, after some time you can check whether everything is in order.
**Website:** https://dnssec-analyzer.verisignlabs.com.

In this detailed guide, we have covered how to install, configure, and setup Bind 918 as a local DNS server for a private network. You can apply all the above techniques to a public network.

Done! You have now enabled Bind DNS Server with DNSSEC. Enjoy safer internet browsing with DNSSEC.