---
title: BIND DNSSEC Configuration And Implementation On Linux System
date: "2025-07-08 08:45:23 +0100"
updated: "2025-07-08 08:45:23 +0100"
id: bind-dnssec-implementation-configuration-linux
lang: en
author: Iwan Setiawan
robots: index, follow
categories: Linux
tags: DNSServer
background: https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/images/9_DNSSEC_Usage_Diagram.jpg
toc: true
comments: true
published: true
excerpt: DNSSEC is part of internet engineering that is needed to keep you free from risks that threaten your privacy when surfing the internet. The process of installing DNSSEC on Linux is very easy and very fun
keywords: bind, dnssec, bind9, isc, dns, server, linux, dns-keygen, zone, arpa
---

Domain Name System Security Extensions or more commonly known as DNSSEC or DNS Security Extensions) is a set of Internet Engineering Task Force (IETF) specifications for securing certain types of information provided by the Domain Name System (DNS) as used on the Internet.

DNSSEC provides authentication of the origin of DNS resolvers for DNS data, denial of existence and integrity of authenticated data, but not availability or confidentiality. DNSSEC authenticates DNS using digital signatures based on public key cryptography. With DNSSEC, it is not the DNS query or response that is signed, but the DNS data itself that is signed by the data owner.

With the presence of digital signatures, DNSSEC is able to protect domains from cyber threats, ensure the authenticity of data, and strengthen the security of your website with cryptographic validation.

DNSSEC is designed to guarantee the validity of data sources, maintain data accuracy, and confirm the absence of certain entries in the DNS structure. The DNSSEC protocol can improve the security and reliability of DNS by using digital signatures and cryptographic methods, although it does not encrypt DNS traffic, providing authentication without changing the core DNS framework.

While implementing and monitoring DNSSEC can be difficult due to its complex nature, the substantial security benefits it provides make it an essential tool for protecting network resources and maintaining the accuracy of domain data against widespread threats such as DNS cache corruption and DNS impersonation.

<br/>

![DNSSEC Usage Diagram](https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/images/9_DNSSEC_Usage_Diagram.jpg){:loading='eager'}

<br/>

## A. DNSSEC Installation Process On Linux
In this article we will explain how to install DNSSEC with BIND DNS Server on a Linux system. The explanation in this article can be applied to almost all Linux families such as Ubuntu, Debian and others.

### a.1. Install Bind

You can apply DNSSEC to various DNS server applications such as PowerDNS, Unbound, Knot Resolver and others. However, in this article we only focus on implementing DNSSEC together with ISC BIND Named.

DNSSEC cannot stand alone, because DNSSEC is only an extension, so before you apply DNSSEC you must first install BIND as a place to apply DNSSEC.

You can run the command below to start installing `bind9` on Ubuntu or Debian.

```console
root@ns2:~# apt update -y
root@ns2:~# apt list --upgradable
root@ns2:~# apt upgrade -y
```

After the above process is complete, you continue by installing the dependencies required by `bind`.

```console
root@ns2:~# apt install bind9-utils dnsutils bind9-doc bind9-libs libatomic1 libc6 libjemalloc2 libxml2 -y
```

The final step of the installation process is to install `bind9`.

```console
root@ns2:~# apt install bind9 -y
```

### a.2. Enable Bind9

Before `bind9` is activated, you should first check which version of `bind9` you are using.

```console
root@ns2:~# named -v
BIND 9.18.30 (Extended Support Version) <id:cdc8d69>
```

To enable `bind9`, you can run the command below.

```console
systemctl enable named
systemctl restart named
```

After you have successfully activated `bind9`, check the status of `bind9`, whether it is running normally or not.

```console
systemctl status named
```
### a.3. Enabling Bind9 Options

By default on Linux operating systems Options for `bind9` are located in `/etc/default/named`. Open that file and apply some bind9 options that you need. In this article we set the bind9 options as follows.

```
## /etc/default/named ##
# run resolvconf?
RESOLVCONF=no

# startup options for the server
OPTIONS="-c /etc/bind/named.conf -p 53 -g -u bind"
```

## B. DNSSEC Configuration Process With Bind9

In this section, we will configure the bind9 server according to your network needs and the specifications of the computer system you are using. The first step you must do is activate the `/etc/resolv.conf` file. Because on almost all Linux systems such as Ubuntu and Debian the file is a symlink. You must delete the symlink.

```console
root@ns2:~# unlink /etc/resolv.conf
root@ns2:~# touch /etc/resolv.conf
```

In the `/etc/resolv.conf` file, type the following script.

```
## /etc/resolv.conf ##
domain unixwinbsd.site
nameserver 192.168.5.2
nameserver 127.0.0.1
# nameserver 8.8.8.8
# nameserver 1.1.1.1
```

Match the domain name with the domain name you are using.

### b.1. Creating `hostname` and `hosts`

On the Linux system, there are many symlinks that are created automatically. To create a `hostname` name, open the `/etc/hostname` file, and type the `hostname` name that you will use. In this article we use the hostname `ns2`.

While for the `hosts` name there is a symlink. To create a `hosts` name, you must open the `/etc/cloud/templates/hosts.debian.tmpl` file. In that file, type the script below.


```
## /etc/cloud/templates/hosts.debian.tmpl ##
## template:jinja
manage_etc_hosts: True
192.168.5.2 unixwinbsd.site ns2
127.0.0.1 localhost

# The following lines are desirable for IPv6 capable hosts
::1 localhost ip6-localhost ip6-loopback
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
```

Then you type the script in the `/etc/systemd/resolved.conf` file.

```console
##  /etc/systemd/resolved.conf ##
# See resolved.conf(5) for details

[Resolve]
DNS=192.168.5.2 8.8.8.8 9.9.9.9
FallbackDNS=192.168.5.2 8.8.8.8 9.9.9.9
Domains=unixwinbsd.site
#LLMNR=no
#MulticastDNS=no
DNSSEC=yes
DNSOverTLS=yes
#Cache=no-negative
DNSStubListener=yes
ReadEtcHosts=yes
```

### b.2. Creating Zone File

In this section, we'll set up our DNS server to be authoritative for domain unixwinbsd.site. We'll create a forward lookup zone and a reverse lookup zone.

The forward lookup zone will typically contain A, AAAA, CNAME, MX, NS, and SOA records. The reverse lookup zone will contain PTR and SOA records. A few zone files are already included in the default installation, a.o. the zone file for the root zone.

```console
root@ns2:~# mkdir -p /etc/bind/zones
root@ns2:~# touch /etc/bind/zones/db.5.168.192
root@ns2:~# touch /etc/bind/zones/db.unixwinbsd.site
```

After that, in each zone you created above, type the script as in the example below.

<br/>

**For Zone /etc/bind/zones/db.unixwinbsd.site**

```console
$TTL    604800
unixwinbsd.site.    IN    SOA    ns2.unixwinbsd.site. admin.unixwinbsd.site. (
             2019061308    ; Serial
             604800        ; Refresh
              86400        ; Retry
            2419200        ; Expire
             604800 )    ; Negative Cache TTL
;
; name servers - NS records
unixwinbsd.site.	300	IN	NS	ns2.unixwinbsd.site.

; name servers - A records
ns2.unixwinbsd.site.	300	IN	A	192.168.5.2
unixwinbsd.site.	300	IN	A	192.168.5.2

; www			300	IN	A	185.238.3.236
www.unixwinbsd.site.	300	IN	CNAME	unixwinbsd.site.
```
<br/>

**For Zone /etc/bind/zones/db.5.168.192**

```
$TTL    604800
5.168.192.in-addr.arpa.    IN    SOA    unixwinbsd.site. root.unixwinbsd.site. (
            2019061304    ; Serial
             604800        ; Refresh
              86400        ; Retry
            2419200        ; Expire
             604800 )    ; Negative Cache TTL
; name servers
5.168.192.in-addr.arpa.    300	IN    NS    ns2.unixwinbsd.site.
5.168.192.in-addr.arpa.    300	IN    NS    unixwinbsd.site.

; PTR Records
2.5.168.192.in-addr.arpa.	300	IN	PTR	ns2.unixwinbsd.site.
2.5.168.192.in-addr.arpa.	300	IN	PTR	unixwinbsd.site.
2.5.168.192.in-addr.arpa.	300	IN	PTR	www.unixwinbsd.site.
```

After all the scripts for each zone are created, continue by creating symlinks.

```console
root@ns2:~# cd /var/cache/bind
root@ns2:/var/cache/bind# ln -s /etc/bind/zones/db.5.168.192 .
root@ns2:/var/cache/bind# ln -s /etc/bind/zones/db.unixwinbsd.site .
```

### b.3. Create `key-signing key` and `zone-signing key`

The process of creating KSK and ZSK keys is very important, these keys are used to enable DNSSEC on `bind9`. The dnssec-keygen program is used to generate keys.


#### b.3.1 For `unixwinbsd.site` Zone

```console
root@ns2:~# mkdir -p /etc/bind/keys
root@ns2:~# cd /etc/bind/keys
root@ns2:/etc/bind/keys# dnssec-keygen -K /etc/bind/keys/ -a RSASHA256 -b 2048 -n ZONE unixwinbsd.site
root@ns2:/etc/bind/keys# dnssec-keygen -K /etc/bind/keys/ -a RSASHA256 -b 4096 -f KSK  -n ZONE unixwinbsd.site
```

View the results of creating the key with the `ls` command.

```console
root@ns2:/etc/bind/keys# ls -l
total 16
-rw-r--r-- 1 root bind  613 Jul  8 06:56 Kunixwinbsd.site.+008+09154.key
-rw------- 1 root bind 1776 Jul  8 06:56 Kunixwinbsd.site.+008+09154.private
-rw-r--r-- 1 root bind  959 Jul  8 06:56 Kunixwinbsd.site.+008+54787.key
-rw------- 1 root bind 3316 Jul  8 06:56 Kunixwinbsd.site.+008+54787.private
```

Then you enter the key values ​​into each zone file that you created above.

```console
root@ns2:~# cat /etc/bind/keys/Kunixwinbsd.site.+008+*.key >> /etc/bind/zones/db.unixwinbsd.site
```

The results can be seen in the files `/etc/bind/zones/db.5.168.192` and `/etc/bind/zones/db.unixwinbsd.site`. Both key values ​​are at the bottom of each zone's script.

After that you run the command below.

```console
root@ns2:~# dnssec-signzone -o unixwinbsd.site -t -R -S -K /etc/bind/keys/ /etc/bind/zones/db.unixwinbsd.site
Verifying the zone using the following algorithms:
- RSASHA256
Zone fully signed:
Algorithm: RSASHA256: KSKs: 1 active, 0 stand-by, 0 revoked
                      ZSKs: 1 active, 0 stand-by, 0 revoked
/etc/bind/zones/db.unixwinbsd.site.signed
Signatures generated:                       10
Signatures retained:                         0
Signatures dropped:                          0
Signatures successfully verified:            0
Signatures unsuccessfully verified:          0
Signing time in seconds:                 0.044
Signatures per second:                 227.272
Runtime in seconds:                      0.096
root@ns2:~#
```

The result of the command above will create a new file named `/etc/bind/zones/db.unixwinbsd.site.signed`.

```console
root@ns2:~# ls -l /etc/bind/zones
total 16
-rw-r--r-- 1 root bind  610 Jul  8 07:25 db.5.168.192
-rw-r--r-- 1 root bind 2126 Jul  8 07:27 db.unixwinbsd.site
-rw-r--r-- 1 root bind 7329 Jul  8 07:27 db.unixwinbsd.site.signed
```

#### b.3.2 For Zone `5.168.192.in-addr.arpa`

The method for creating KSK and ZSK keys for the `5.168.192.in-addr.arpa` zone is the same as creating keys for the `unixwinbsd.site` zone.

```console
root@ns2:~# dnssec-keygen -K /etc/bind/keys/ -a RSASHA256 -b 2048 -n ZONE 5.168.192.in-addr.arpa
Generating key pair...............................+++++ .......................................................+++++
K5.168.192.in-addr.arpa.+008+26140

root@ns2:~# dnssec-keygen -K /etc/bind/keys/ -a RSASHA256 -b 4096 -f KSK  -n ZONE 5.168.192.in-addr.arpa
Generating key pair.........................................++++ ..............................................++++
K5.168.192.in-addr.arpa.+008+36127
root@ns2:~#
```

Enter the values ​​of both keys into the file `/etc/bind/zones/db.5.168.192`.

```console
root@ns2:~# cat /etc/bind/keys/K5.168.192.in-addr.arpa.+008+*.key >> /etc/bind/zones/db.5.168.192
```
The results of the command above can be seen in the example below.

```console
$TTL    604800
5.168.192.in-addr.arpa.    IN    SOA    unixwinbsd.site. root.unixwinbsd.site. (
            2019061304    ; Serial
             604800        ; Refresh
              86400        ; Retry
            2419200        ; Expire
             604800 )    ; Negative Cache TTL
; name servers
5.168.192.in-addr.arpa.    300	IN    NS    ns2.unixwinbsd.site.
5.168.192.in-addr.arpa.    300	IN    NS    unixwinbsd.site.

; PTR Records
2.5.168.192.in-addr.arpa.	300	IN	PTR	ns2.unixwinbsd.site.
2.5.168.192.in-addr.arpa.	300	IN	PTR	unixwinbsd.site.
2.5.168.192.in-addr.arpa.	300	IN	PTR	www.unixwinbsd.site.

; This is a zone-signing key, keyid 26140, for 5.168.192.in-addr.arpa.
; Created: 20250708071417 (Tue Jul  8 07:14:17 2025)
; Publish: 20250708071417 (Tue Jul  8 07:14:17 2025)
; Activate: 20250708071417 (Tue Jul  8 07:14:17 2025)
5.168.192.in-addr.arpa. IN DNSKEY 256 3 8 AwEAAb+iS0/SflPwxqTDqajZ4Z1HvgkxeqGV96chitbWeXTO/qfxWVCE aWQDcF5wKznWb3YebWrhovp2VixNcfSMOzIZgbNAMSqZPn0p58api1zR NR6JOZ6iuxjNDzktAhnMoPgUk30ATG/So0O1RnFwG6H9L5rrkkv4nkTi 3RYoj34/575KnVzsnjmaCiFju9OA2xtkRVNYxLnXwaqY2q1CEM7kO7M6 rwQRvV/CmeM9lKkXYcBviy04OVEw7T+dGpswSiGdVIOKeJmUWLmbkRbk yRMCLg4TXoM031uuK/o1UAq59RrRbUK5XgDPkxdCPvd6OI157AQQiogE nY1dUlP7vcM=
; This is a key-signing key, keyid 36127, for 5.168.192.in-addr.arpa.
; Created: 20250708071428 (Tue Jul  8 07:14:28 2025)
; Publish: 20250708071428 (Tue Jul  8 07:14:28 2025)
; Activate: 20250708071428 (Tue Jul  8 07:14:28 2025)
5.168.192.in-addr.arpa. IN DNSKEY 257 3 8 AwEAAdtyXnLiKvOnE8jKResc2ZPKoJ0g7dlBu7jxYKor4nu0YZYlaQk8 68T3NB6TsSJQIXbLROLKMHIqmBGNbbdUydmJHtY1Sqc6nXPZq0cfZ5lC aQnTU2NFNLdGWChKztYCQXma2V3twwa0qYiH0GxN12xzgsP1HJjRPWNt n3RRm1aBHEmJlm5wv3yT+LOvPZL6Y9QetlXmkK2vDXTtqmoJnTqDkfCJ 1ZuBAbbnsFII7/Ifka/5Kp4aMkrdM015bKtQMzuRp05Qi63YG4sWkLdE 5URpQDzhBe/XfT9VCb9W967ZYr1m1aGu7mzxz6gzAnBdQjM04RMp1ccw iVl6Ue7y8Ia/qSYEsZ6fGVm8XH3my3QTwJAnwdjF6/TMJXCWbITS7Vj6 YpBU9h+mkt0LTd9K2bWgPrZUEB2Rgx5J/BaRPXoazS2Z5IiC7+gWqQpw EPW8wGYMRcG8pFoHUltpVqt4jb5+CmagmNJYWzQONDN6cQS/AS9iYzIZ AsXq2QpOfv8UrukRd5eIcrdFTVYc4ygmcqllce/yNj1ZGoM2hMLen7ob Qk4dJGVKAQV6NBwNty/v6Lf7BIMmZMHHgwe93hfGt0rGyz9GB8KUeqCl FVcdqtVkUscJRPqDlGMJ79q6XVUPcXy14O1xYSdEfG6eCcTsxYI4W3xV nxpweoWWentS5rKF
```

After that, continue with the command below.

```console
root@ns2:~# dnssec-signzone -o 5.168.192.in-addr.arpa -t -R -S -K /etc/bind/keys/ /etc/bind/zones/db.5.168.192
Verifying the zone using the following algorithms:
- RSASHA256
Zone fully signed:
Algorithm: RSASHA256: KSKs: 1 active, 0 stand-by, 0 revoked
                      ZSKs: 1 active, 0 stand-by, 0 revoked
/etc/bind/zones/db.5.168.192.signed
Signatures generated:                        7
Signatures retained:                         0
Signatures dropped:                          0
Signatures successfully verified:            0
Signatures unsuccessfully verified:          0
Signing time in seconds:                 0.044
Signatures per second:                 159.090
Runtime in seconds:                      0.080
```

The result of the command above will create a new file named `/etc/bind/zones/db.5.168.192.signed`.

Both files with the extension `*.signed` you create a symlink to /var/cache/bind.

```console
root@ns2:~# cd /var/cache/bind
root@ns2:/var/cache/bind# ln -s /etc/bind/zones/db.5.168.192.signed .
root@ns2:/var/cache/bind# ln -s /etc/bind/zones/db.unixwinbsd.site.signed .
root@ns2:/var/cache/bind#
```

### b.4. Enable KSK and ZSK Keys In `/etc/bind/named.conf.local` File

All keys from the file you created above must be activated in `/etc/bind/named.conf.local`. The example below is a script from the `/etc/bind/named.conf.local` file.

```console
//
// Do any local configuration here
//

// Consider adding the 1918 zones here, if they are not used in your
// organization
//include "/etc/bind/zones.rfc1918";
zone "unixwinbsd.site" {
    type master;
    file "/var/cache/bind/db.unixwinbsd.site.signed";
//  journal "/var/cache/bind/managed-keys.bind.jnl";
    key-directory "/var/cache/bind";
    inline-signing yes;
    update-policy local;
    sig-validity-interval 20 10;
    allow-transfer { any; };
    notify yes;
    };

zone "5.168.192.in-addr.arpa" {
    type master;
    file "/var/cache/bind/db.5.168.192.signed";
    key-directory "/var/cache/bind";
//  journal "/var/cache/bind/truested.mkeys.jnl";
    inline-signing yes;
    update-policy local;
    sig-validity-interval 20 10;
    allow-transfer { any; };
    notify yes;
    };
```

Meanwhile, you can see an example script file `/etc/bind/named.conf.options` below.

```console
acl trusted {
192.168.5.2;
127.0.0.1;
};

options {
directory "/var/cache/bind";
// key-directory "/var/named/keys/";
listen-on port 53 { 192.168.5.2; };
//listen-on-v6 port 53 { 2a0d:1640:1:241::1; };
statistics-file "/var/run/named/named.stats";
dump-file "/var/log/bind/bind.dump";
max-cache-size 241172480; // 256 Mb

forwarders { 8.8.8.8; 9.9.9.9; };

dnssec-validation yes;

minimal-responses yes;
allow-query { trusted; };
auth-nxdomain no;   
recursion yes;
allow-recursion-on { trusted; };
querylog yes;
#query-source-v6 2a0d:1640:1:241::1; 
#transfer-source-v6 2a0d:1640:1:241::1;
#notify-source-v6 2a0d:1640:1:241::1;	
empty-zones-enable yes;
allow-query-cache { trusted; };

};
// include "/etc/bind/rootzone.key";
// include "/usr/share/GeoIP/GeoIP.acl";

```


### b.5. Ownership and Permissions

The chown and chmod commands are used to grant file ownership and file usage permissions. Run the commands below, copy each file you have created above.

```console
root@ns2:/var/cache/bind# chown -R bind:bind /var/cache/bind/
root@ns2:/var/cache/bind# chown -R bind:bind /etc/bind/keys/
root@ns2:/var/cache/bind# chown -R bind:bind /etc/bind/zones/
root@ns2:/var/cache/bind# chmod -R 640 /etc/bind/keys/
root@ns2:/var/cache/bind# chmod -R 775 /var/cache/bind/
```

The last step is to run the `restart` command.

```console
root@ns2:~# systemctl restart named
root@ns2:~# systemctl status named
```

To prove whether your Bind DNS server is running or not, run the `dig` command.

```console
root@ns2:~# dig yahoo.com
root@ns2:~# dig @ns2.unixwinbsd.site unixwinbsd.site
root@ns2:~# dig @ns2.unixwinbsd.site version.bind chaos txt
root@ns2:~# dig @ns2.unixwinbsd.site www.isc.org
root@ns2:~# dig @192.168.5.2 www.isc.org. A +dnssec +multiline
root@ns2:~# dig @192.168.5.2 www.dnssec-failed.org. A
root@ns2:~# dig @216.218.130.2 www.dnssec-failed.org. A
root@ns2:~# dig @192.168.5.2 unixwinbsd.site. AXFR +multiline +onesoa
root@ns2:~# dig @192.168.5.2 unixwinbsd.site. DNSKEY +multiline +noall +answer
root@ns2:~# dig @192.168.5.2 unixwinbsd.site. SOA +dnssec +multiline
```

To complete this material, you can see an example of a DNS server bind file that we [host](https://prohoster.info/) at `https://prohoster.info/`



- [named.conf.local](https://raw.githubusercontent.com/unixwinbsd/integralist/refs/heads/main/named.conf.local?token=GHSAT0AAAAAADEWNV53GLPWJXXKDUZLQNUE2DM22UQ)
- [named.conf.options](https://raw.githubusercontent.com/unixwinbsd/integralist/refs/heads/main/named.conf.options?token=GHSAT0AAAAAADEWNV52J4OPUG3XT4KGFCYY2DM23QA)
- [Full Script](https://github.com/unixwinbsd/integralist)