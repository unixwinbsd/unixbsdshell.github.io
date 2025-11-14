---
title: Setting Up PTR Reverse Lookup Zone On Debian Ubuntu - mapping IPv4 To Hostname
date: "2025-09-24 09:30:12 +0100"
updated: "2025-09-24 09:30:12 +0100"
id: setup-ptr-reverse-zone-debian-ubuntu-mapping-ipv4
lang: en
author: Iwan Setiawan
robots: index, follow
categories: linux
tags: DNSServer
background: https://gitea.com/UnixBSDShell/OpenBSD-Web-APP/raw/branch/main/img/schema-addr-arpa-ipv4.jpg
toc: true
comments: true
published: true
excerpt: Reverse DNS (rDNS) is the process of mapping IP addresses back to hostnames. A PTR (Pointer) record is a type of DNS record used to perform this reverse mapping. While forwarding DNS maps domain names to IP addresses, rDNS does the opposite and verifies which domain name is associated with a given IP address
keywords: setup, ptr, reverse, lookup, zone, debian, ubuntu, bind, bind9, dns server, mapping, ipv4, hostname, host, ns
---

BIND can be used to run a caching DNS server or an authoritative name server, and provides features such as load balancing, notifications, dynamic updates, split DNS, DNSSEC, IPv6, and more. Berkeley Internet Name Domain (BIND) is the most popular Domain Name System (DNS) server in use today.

One of Bind's advantages is its ability to create multiple PTR zones. Reverse DNS is the process of using DNS to translate IP addresses into hostnames. Reverse DNS is the opposite of Forward DNS, which is used to translate hostnames into IP addresses.

## 1. About Reverse DNS

Reverse DNS (rDNS) is the process of mapping IP addresses back to hostnames. A PTR (Pointer) record is a type of DNS record used to perform this reverse mapping. While forwarding DNS maps domain names to IP addresses, rDNS does the opposite and verifies which domain name is associated with a given IP address. This verification is important for several reasons, including email server validation and network diagnostics.

A typical DNS query will resolve to the IP address given the domain name; hence the term `"reverse"`. A special type of PTR record is used to store reverse DNS entries. The name of a PTR record is the IP address with the reverse segment, such as "31.168.192.in-addr.arpa."

Reverse DNS queries are often used for spam filtering. Spammers can easily set the sender's email address to any domain name they wish, including legitimate domain names such as those of banks or trusted organizations.

The receiving email server can validate incoming messages by checking the sender's IP address using a reverse DNS query. If the email is legitimate, the rDNS resolver should match the email address's domain. The downside to this technique is that some legitimate email servers don't have the proper rDNS data settings to respond correctly, as in many cases, their ISPs must configure these data.


## 2. Understanding RDN and PTR Notes

Before diving into the configuration process, it is important to understand the basic concepts of RDN and PTR.


### 2.1. What is Reverse DNS (rDNS)?

Reverse DNS is a method used to resolve an IP address back to its corresponding domain name. In a standard DNS query, a domain name is translated into an IP address (e.g., domain unixshell.top >>> 192.0.2.1). Reverse DNS performs the opposite function, verifying the domain name associated with that IP address (e.g., 192.0.2.1 >>> unixshell.top). This process is crucial in verifying the validity of an IP address.


### 2.2. What is a PTR Record?

A PTR (Pointer) record is a type of DNS record used specifically for reverse DNS lookups. PTR records reside in the reverse zone of the IP address space and are used to associate an IP address with a canonical hostname. When someone performs a reverse lookup, the DNS server consults the PTR record to determine the domain name associated with that IP address.

Since we're talking about domain addressing, dividing the network into subnets doesn't matter in this case. The names are treated exactly like regular domain names. This means that the domain name system of machines within this domain can be represented as shown in the figure below.

<br/>

<img alt="schema addr-arpa ipv4" width="99%" class="lazyload" style="display: block; margin: auto;" src="{{ 'https://gitea.com/UnixBSDShell/OpenBSD-Web-APP/raw/branch/main/img/schema-addr-arpa-ipv4.jpg' | relative_url }}">

<br/>

## 3. Creating a PTR Zone

IP address allocation is essentially the delegation of authority to reverse map IP addresses. Therefore, since an RIR is allocated a block of IP addresses, it assumes the authoritative responsibility to delegate reverse maps and operate the reverse map DNS infrastructure at its level. Similarly, the LIR or NIR continues the delegation until it reaches the end customer. The figure below shows the allocation of IP addresses down to the consumer (end user).

<br/>
<img alt="nextcloud openssl port 443" width="99%" class="lazyload" style="display: block; margin: auto;" src="{{ 'https://gitea.com/UnixBSDShell/OpenBSD-Web-APP/raw/branch/main/img/IP-Address-Allocation-and-Delegation.jpg' | relative_url }}">
<br/>

We've implemented all of the content in this article on a Debian server in a Virtual Private Hosting machine [(prohoster.info)](http://prohoster.info). To create the PTR zone, we used Bind 9.20 as the DNS server application. We'll assume your Bind server is running normally. Open the `"/etc/bind/named.conf.local"` file and type the following:


```console
zone "122.83.45.in-addr.arpa" {
    type master;
    file "/var/lib/bind/zones/db.122.83.45";
//    key-directory "/var/lib/bind/keys";
//    dnssec-policy high;
//  journal "/var/cache/bind/truested.mkeys.jnl";
//    inline-signing yes;
//    update-policy local;
//    sig-validity-interval 20 10;
// 216.218.133.2; 2001:470:600::2; he.net
//checkds explicit;
    };
```

After you write the script above, continue by creating a zone file `"/var/lib/bind/zones/db.122.83.45"`, and add the following script.

```console
$ORIGIN 122.83.45.in-addr.arpa.
$TTL 86400
122.83.45.in-addr.arpa.    IN    SOA    dns5.unixshell.top. iwanse1212.yandex.com. (
				2025083020 ; serial
				86400 ; refresh (1 day)
				3600 ; retry (1 hour)
				2419200 ; expire (4 weeks)
				86400 ; minimum (1 day)	
                                )

; name servers
122.83.45.in-addr.arpa.		300	IN	NS	dns5.unixshell.top.
122.83.45.in-addr.arpa.		300     IN      NS      slave.dns.he.net.
122.83.45.in-addr.arpa.		300     IN      NS      ns3.he.net.
122.83.45.in-addr.arpa.		300     IN      NS      ns2.he.net.
122.83.45.in-addr.arpa.		300     IN      NS      ns5.he.net.
122.83.45.in-addr.arpa.		300     IN      NS      ns1.he.net.
122.83.45.in-addr.arpa.		300     IN      NS      ns4.he.net.
122.83.45.in-addr.arpa.		300     IN      NS      ns1.afraid.org.
122.83.45.in-addr.arpa.		300     IN      NS      ns2.afraid.org.
122.83.45.in-addr.arpa.		300     IN      NS      ns3.afraid.org.
122.83.45.in-addr.arpa.		300     IN      NS      ns4.afraid.org.
122.83.45.in-addr.arpa.		300     IN      NS      ns2.trifle.net.
; dnshenet-key.3.238.185.in-addr.arpa.	600	IN	TXT	"uKkN0AscTB4Xu3n6llWzGDnlofrQVAxrL2EFU97tdPs"

; PTR Records
; 236.3.238.185.in-addr.arpa.		600	IN	PTR	dns5.unixshell.top.
78.122.83.45.in-addr.arpa.		600	IN	PTR	unixshell.top.
75.122.83.45.in-addr.arpa.		600	IN	PTR	linux.unixshell.top.
```

Save changes and reconfigure `‘named’`.

```console
root@dns5:~# rndc reconfig
root@dns5:~# rndc reload
```

## 4. Checking the PTR Zone
After completing all the steps above, check the PTR zone you created. Before running the check command, ensure all configuration files and zones are running normally. Run the command below to check the zone files.

```shell
root@dns5:~# named-checkconf /usr/local/etc/bind/named.conf
root@dns5:~# named-checkzone 122.83.45.in-addr.arpa /var/lib/bind/zones/db.122.83.45
zone 122.83.45.in-addr.arpa/IN: loaded serial 2025083020
OK
root@dns5:~#
```

You can use the command below to check the PTR zone file.

```shell
root@dns5:~# dig 2.1.16.172.in-addr.arpa PTR

; <<>> DiG 9.20.12 <<>> 2.1.16.172.in-addr.arpa PTR
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NXDOMAIN, id: 58579
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 0, AUTHORITY: 1, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 1232
; COOKIE: 9564b3cc6a67729d0100000068b2f713c818bdd4375381c5 (good)
;; QUESTION SECTION:
;2.1.16.172.in-addr.arpa.       IN      PTR

;; AUTHORITY SECTION:
16.172.IN-ADDR.ARPA.    86400   IN      SOA     16.172.IN-ADDR.ARPA. . 0 28800 7200 604800 86400

;; Query time: 0 msec
;; SERVER: 2a0d:1640:1:241::1#53(2a0d:1640:1:241::1) (UDP)
;; WHEN: Sat Aug 30 16:05:23 EEST 2025
;; MSG SIZE  rcvd: 134
```

```console
root@dns5:~# dig -x 45.83.122.78 +trace
root@dns5:~# nslookup 45.83.122.78
root@dns5:~# host 45.83.122.78
```

If you want to use the online utility, open the url link below to check your domain zone.

- [Into DNS](https://intodns.com/unixshell.top)
- [MxToolBox](https://mxtoolbox.com/ReverseLookup.aspx)
- [WhatIsMyIP](https://www.whatismyip.com/reverse-dns-lookup/)
- [Hacker Target](https://hackertarget.com/reverse-dns-lookup/)
- [WhatIsMyIPAddress](https://whatismyipaddress.com/ip-hostname)
- [Google Public DNS](https://dns.google/)

If you're not sure why this is necessary, you should know that reverse permissions (PTR zones) are necessary for proper email operation (if you have a mail server, it's best to do this for its IP address). Otherwise, emails sent through your SMTP service may be "redirected" by most mail relays.