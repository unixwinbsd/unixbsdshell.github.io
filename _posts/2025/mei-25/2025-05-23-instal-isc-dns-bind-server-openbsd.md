---
title: Install ISC Bind DNS Server Using OpenBSD
date: "2025-05-23 08:55:35 +0100"
updated: "2025-05-23 08:55:35 +0100"
id: instal-isc-dns-bind-server-openbsd
lang: en
author: Iwan Setiawan
robots: index, follow
categories: openbsd
tags: DNSServer
background: https://dings.tech/posts/openbsd-dns-dhcp-isc/cover.jpg
toc: true
comments: true
published: true
excerpt: How DNS caching server works is when the DNS server finds the DNS address you requested, the DNS server will immediately send it to you who requested the DNS address, then store the DNS address in its database
keywords: openbsd, bind, isc, dns, server, domain, name server, hostname, dig
---

For those of you who have slow internet, DNS server caching is a smart solution to increase internet browsing speed. In general, the DNS server application functions to change names into numbers. Every website name you type will be changed to an IP address so that it will display a web page as you see it in Google Chrome or Firefox.

In general, there are several types of DNS servers. The caching type is a type that does not contain raw mapping from name to address, this type is called an authoritative DNS server which can then be divided into master, slave, and stealth. DNS server caching is also called a recursive server. All types of DNS servers can be titled server names.

How DNS caching server works is when the DNS server finds the DNS address you requested, the DNS server will immediately send it to you who requested the DNS address, then store the DNS address in its database.

Later, when a friend of yours requests the same DNS address, the DNS caching server will take the DNS address from its database. So it can speed up the processing time of DNS requests.

The slower your internet connection, the more useful the DNS server cache is to improve internet access. To maintain accuracy, there is a configurable expiration time (time to live/TTL) on the server data that forces it to return to the internet periodically for updates.

## 1. System Specifications
- OS: OpenBSD 7.6
- domain: kursor.my.id
- Hostname: foo
- IP Address: 192.168.7.3
- Bind version: isc-bind-9.18.25v3


## 2. How to Install ISC Bind DNS Server
One of the advantages of ISC Bind is that it can be installed on all operating systems, such as Windows, MacOS, Linux, and BSD including OpenBSD. However, each system has a different way of configuration. In this section, we will learn how to install, configure, and use ISC Bind on an OpenBSD server.

Since DNS Bind is very familiar, like other operating systems, in OpenBSD ISC Bind is already available in the `pkg_add` repository. You can run the command below to install ISC Bind on OpenBSD.


```console
foo# pkg_add isc-bind-9.18.25v3
```

After the installation process is complete, by default the ISC Bind application creates a user and group named **_bind:_bind**. This user will be very useful when doing configuration. The location of the ISC Bind directory on OpenBSD is slightly different from FreeBSD. OpenBSD places the ISC Bind application in **/var/named**. All configuration files are stored in that directory.

By default the **/var/named** directory contains two folders, namely `/etc and /tmp`, during the configuration process we will add several folders to this directory, such as `/master,  /standard and others`.

## 3. Configuration Process
In this section we will discuss the steps to configure ISC Bind. The ISC Bind configuration file is named `named.conf`. You can set all your DNS server caching needs in that file.

### a. Enable ISC Bind
Before you configure ISC Bind, first enable the Bind DNS server by running the command below.

```console
foo# rcctl enable isc_named
foo# rcctl restart isc_named
isc_named(ok)
isc_named(ok)
```

The above command is to enable ISC Bind and create `rndc.key` file. Try opening the contents of `rndc.key` script file with cat command.

```console
foo# cat /var/named/etc/rndc.key
key "rndc-key" {
        algorithm hmac-sha256;
        secret "sLhSyJAo609lksFnU2Z0y5MbiSnoVJfTMz21foPVv3g=";
};
```

<br/>
### b. Edit the configuration file named .conf
We will use the entire contents of the rndc.key script file to configure the `named.conf` file. Now you open the named.conf file, then you delete the entire contents of the script and replace it with the script below.

```console
foo# nano /var/named/etc/named.conf
key "rndc-key" {
	algorithm hmac-sha256;
	secret "sLhSyJAo609lksFnU2Z0y5MbiSnoVJfTMz21foPVv3g=";
};

 
 controls {
 	inet 127.0.0.1 port 953
 		allow { 127.0.0.1; } keys { "rndc-key"; };
 };

acl clients {
	192.168.7.0/24;
	127.0.0.1;
};
acl IP_LAN { 192.168.7.3; };

options {
	directory "/tmp";
	version "dns foo.kursor.my.id";
	listen-on port 53 { IP_LAN; };
	#listen-on-v6 { any; };
	allow-recursion { clients; };
	allow-query { clients; };
	allow-query-cache { clients; };
        allow-transfer { none; };
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

zone "7.168.192.in-addr.arpa" in {
        type master;
        file "master/insternal.rev";
};
```

<br/>
### c. Add the zone settings
In the named.conf file script above, there are several zones that will be used by ISC Bind. We will customize the zone creation according to the script above. The first step is to create a directory for the zone.

```yml
foo# mkdir -p /var/named/standard
foo# mkdir -p /var/named/master
foo# touch /var/named/standard/localhost
foo# touch /var/named/standard/loopback
foo# touch /var/named/master/internal.lan
foo# touch /var/named/master/internal.rev
```

After that, in the zone file you add a script like the example below. As usual, we use the nano text editor.

```console
foo# nano /var/named/standard/localhost
$ORIGIN localhost.
$TTL 6h

@       IN      SOA     localhost. root.localhost. (
                        1       ; serial
                        1h      ; refresh
                        30m     ; retry
                        7d      ; expiration
                        1h )    ; minimum

                NS      localhost.
                A       127.0.0.1
                AAAA    ::1
```

<br/>
```console
foo# nano /var/named/standard/loopback
$ORIGIN 127.in-addr.arpa.
$TTL 6h

@       IN      SOA     localhost. root.localhost. (
                        1       ; serial
                        1h      ; refresh
                        30m     ; retry
                        7d      ; expiration
                        1h )    ; minimum

                NS      localhost.
1.0.0           PTR     localhost.
```

<br/>
```console
foo# nano /var/named/master/internal.lan
$ORIGIN .
$TTL    86400   ; 24 hours
kursor.my.id    IN SOA  foo.kursor.my.id. root.foo.kursor.my.id. (
                        2010022201 ; Serial
                        86400           ; Refresh (24 hours)
                        3600             ; Retry (1 hour)
                        172800         ; Expire (48 hours)
                        3600             ; Minimum (1 hour)
                )
kursor.my.id.		IN	NS      foo.kursor.my.id.

$ORIGIN kursor.my.id.
foo.kursor.my.id.	IN	A       192.168.7.3
```

<br/>
```console
foo# nano /var/named/master/insternal.rev
$ORIGIN .
$TTL    86400   ; 24 hours
7.168.192.in-addr.arpa	IN	SOA	foo.kursor.my.id. root.foo.kursor.my.id. (
                                2010022201      ; Serial
                                86400           ; Refresh (24 hours)
                                3600            ; Retry (1 hour)
                                172800          ; Expire (48 hours)
                                3600            ; Minimum (1 hour)
                                )
	IN	NS      foo.kursor.my.id.

$ORIGIN 7.168.192.in-addr.arpa.
100	IN     PTR     foo.kursor.my.id.
```

<br/>
### d. Change permissions and ownership
As we explained above, by default ISB Bind running on OpenBSD has “_bind” user and group. Run the command below for file permissions and ownership.

```console
foo# cd /var/named
foo# chown -R _bind:_bind master standard var tmp
```

<br/>
### e. Root hints file
The Root hints file is a file that contains the names and IP addresses of authoritative name servers for the root zone, so that the software can bootstrap the DNS resolution process. You should download this file from the official Iana site repository.

```console
foo# wget https://www.internic.net/domain/named.root -P /var/named/etc
```

<br/>
### f. Edit the resolv.conf file
The resolv.conf file in OpenBSD is used to connect the OpenBSD server to the domain name system (DNS). You must populate this file with the DNS you want to use. Since you are using ISC Bind as a caching DNS server, we will populate this file with the private IP address of the OpenBSD server.

```console
foo# nano /etc/resolv.conf
domain kursor.my.id
nameserver 192.168.7.3
```

<br/>
### g. Check the zone
Untuk memastikan tidak ada kesalahan di setiap zona yang telah Anda buat, periksa dengan perintah di bawah ini. Pertama, kita periksa berkas konfigurasi utama yang bernama  ***"/var/named/etc/named.conf"**.

```console
foo# named-checkconf /var/named/etc/named.conf
```
Then, you continue by checking the zones you have created above.

```yml
foo# named-checkzone kursor.my.id /var/named/master/internal.lan
zone kursor.my.id/IN: loaded serial 2010022201
OK
foo# named-checkzone 7.168.192.in-addr.arpa /var/named/master/internal.rev
zone 7.168.192.in-addr.arpa/IN: loaded serial 2010022201
OK
```

<br/>
### h. Check DNS name servers
If nothing is wrong, we continue with checking the DNS name server. This check aims to ensure that the ISB Bind DNS server is functioning properly. We use the dig command to check the DNS name server. Consider the example command below.

```console
foo# dig yahoo.com

; <<>> dig 9.10.8-P1 <<>> yahoo.com
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 59861
;; flags: qr rd ra; QUERY: 1, ANSWER: 6, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 1232
;; QUESTION SECTION:
;yahoo.com.                     IN      A

;; ANSWER SECTION:
yahoo.com.              1800    IN      A       74.6.231.21
yahoo.com.              1800    IN      A       98.137.11.163
yahoo.com.              1800    IN      A       74.6.143.25
yahoo.com.              1800    IN      A       74.6.231.20
yahoo.com.              1800    IN      A       98.137.11.164
yahoo.com.              1800    IN      A       74.6.143.26

;; Query time: 27 msec
;; SERVER: 192.168.7.3#53(192.168.7.3)
;; WHEN: Wed Apr 17 16:40:48 WIB 2024
;; MSG SIZE  rcvd: 134

```

Here are some dig commands you can use to check the ISC Bind DNS server.

```console
foo# dig @192.168.7.3 azion.com
foo# dig facebook.com +trace
foo# dig -x 172.217.14.238
foo# dig google.com +short
forcesafesearch.google.com.
216.239.38.120
```

Apart from using the dig command, you can also use the nslookup command. Below we provide an example of using `nslookup`.

```console
foo# nslookup -type=ns google.com
Server:         192.168.7.3
Address:        192.168.7.3#53

Non-authoritative answer:
google.com      nameserver = ns2.google.com.
google.com      nameserver = ns3.google.com.
google.com      nameserver = ns4.google.com.
google.com      nameserver = ns1.google.com.

Authoritative answers can be found from:
ns1.google.com  internet address = 216.239.32.10
ns2.google.com  internet address = 216.239.34.10
ns3.google.com  internet address = 216.239.36.10
ns4.google.com  internet address = 216.239.38.10
ns1.google.com  has AAAA address 2001:4860:4802:32::a
ns2.google.com  has AAAA address 2001:4860:4802:34::a
ns3.google.com  has AAAA address 2001:4860:4802:36::a
ns4.google.com  has AAAA address 2001:4860:4802:38::a
```

<br/>
```console
foo# nslookup -type=mx yahoo.com
foo# nslookup -type=soa facebook.com
foo# nslookup -type=txt google.com
foo# nslookup google.com ns1.google.com
```

By following this tutorial, you can use ISB Bind as your personal DNS server. You can use it for your Windows computer by setting the DNS server IP to the IP address 192.168.7.3. Now experience the speed of accessing the internet with the ISC Bind DNS server. Surely you will feel the difference.
