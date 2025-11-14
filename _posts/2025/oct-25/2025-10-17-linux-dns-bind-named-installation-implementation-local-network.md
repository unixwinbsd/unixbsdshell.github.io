---
title: Linux and DNS Bind Named - Installation, Configuration, and Implementation of a DNS Server on a Local Network
date: "2025-10-17 20:36:21 +0100"
updated: "2025-10-17 20:36:21 +0100"
id: linux-dns-bind-named-installation-implementation-local-network
lang: en
author: Iwan Setiawan
robots: index, follow
categories: linux
tags: WebServer
background: /img/oct-25/oct-25-111.jpg
toc: true
comments: true
published: true
excerpt: To ensure your Bind DNS server runs properly, you need to delete the /etc/resolv.conf symlink. This is because we will replace the contents of this script with the name server IP address of your Ubuntu server. Here's how to delete the resolv.conf symlink.
keywords: linux, ubuntu, dns, bind, named, local network, installation, configuration, dns server
---

Linux and DNS Bind Named - Installation, Configuration, and Implementation of a DNS Server on a Local Network
linux-dns-bind-named-installation-implementation-local-network.md

BIND, short for Berkeley Internet Name Domain, is an implementation of the DNS protocol. BIND 9 is the latest version of the BIND DNS server. This version makes several major improvements, including IPv6 support, more flexible configuration and management, improved caching performance, EDNS0 support for large UDP responses, and improved management of dynamically assigned IP addresses.

BIND is the most widely used name server software on the Internet. It supports several different domain name service protocols, including BIND4 (the original Berkeley Internet Name Domain version 4), BIND8 (the historical successor to BIND4), and DNS services for IPv6 through two separate implementations: one daemon-based and the other called lwres (lightweight resolver).

<br/>
<img alt="Berkeley Internet Name Domain Scheme" width="99%" class="lazyload" style="display: block; margin: auto;" src="{{ '/img/oct-25/oct-25-111.jpg' | relative_url }}">
<br/>

## A. System Specifications

- OS: Ubuntu server 24.04
- Host: ns3
- IP address: 192.168.5.3
- Bind Version: BIND 9.18.24-0ubuntu5-Ubuntu

## B. Install Bind DNS Server 9

On the Ubuntu operating system, installing the Bind DNS server is very simple and straightforward. First, ensure all your Ubuntu apt packages are updated. If not, run the following command:


```sh
root@ns3:~# apt-get update && sudo apt-get upgrade -y
```

Now that your system is up to date, you can proceed with installing the DNS server - BIND. This can be done by installing several Bind packages, as shown below.


```html
root@ns3:~# apt install bind9 bind9-dev bind9-dnsutils bind9-doc bind9-host bind9-libs bind9-utils
```

The above command will install BIND9 and two supporting packages that contain the files necessary for the DNS server to function properly.

- BIND9 is DNS server software.
- bind9utils is a BIND configuration management utility and is also the name of the command used to manage BIND from the command line.
- bind9-doc is a documentation package for the BIND software.

Once the installation is complete, you can verify that all packages were successfully installed by running the following command:

```terminal
root@ns3:~# named -v
BIND 9.18.24-0ubuntu5-Ubuntu (Extended Support Version) <id:>
```

## C. Remove Symlink resolv.conf

When you first install Ubuntu, the system automatically creates a symlink file `/etc/resolv.conf` by default. This file contains a name server script that connects your Ubuntu system to public DNS servers like Google, Quad, OpenDNS, or Cloudflare. The resolv.conf file is symlinked to the `/run/systemd/resolve/stub-resolv.conf` file.

To ensure your Bind DNS server runs properly, you need to delete the `/etc/resolv.conf` symlink. This is because we will replace the contents of this script with the name server IP address of your Ubuntu server. Here's how to delete the resolv.conf symlink.

```console
root@ns3:~# ls -l /etc/resolv.conf
lrwxrwxrwx 1 root root 39 Apr 23 09:40 /etc/resolv.conf -> ../run/systemd/resolve/stub-resolv.conf
```

<br/>

```console
root@ns3:~# unlink /etc/resolv.conf
```

After you have successfully removed the `/etc/resolv.conf symlink`, create a new resolv.conf file with the following command.

```
root@ns3:~# touch /etc/resolv.conf
```

The next step, you type the script below in the `/etc/resolv.conf` file.

```sh
domain kursor.my.id
nameserver 192.168.5.3
#nameserver 8.8.8.8
```

## D. Bind 9 DNS Server Configuration

The location of the main Bind DNS server configuration file varies from operating system to operating system. On Ubuntu, the main Bind configuration file is located in the `/etc/bind` folder. You'll need to modify several files in that folder, the main one being `"named.conf"`. Leave the "named.conf" script at its default values ​​and follow the instructions within the file.

```sh
include "/etc/bind/named.conf.options";
include "/etc/bind/named.conf.local";
include "/etc/bind/named.conf.default-zones";
```

<br/>

```sh
zone "." {
	type hint;
	file "/usr/share/dns/root.hints";
};

zone "localhost" {
	type master;
	file "/etc/bind/db.local";
};

zone "127.in-addr.arpa" {
	type master;
	file "/etc/bind/db.127";
};

zone "0.in-addr.arpa" {
	type master;
	file "/etc/bind/db.0";
};

zone "255.in-addr.arpa" {
	type master;
	file "/etc/bind/db.255";
};
```

Then, continue by creating a zone for your Ubuntu server's domain name. Open the `named.conf.local` file, delete all script contents from it, and replace them with the script below.

```sh
zone "kursor.my.id" {
    type master;
    file "/etc/bind/zones/db.kursor.my.id";
    // allow-transfer { };
    };

zone "5.168.192.in-addr.arpa" {
    type master;
    file "/etc/bind/zones/db.5.168.192";
    // allow-transfer { };
    };
```

## E. Create Zone

Because the zone file is located in the `/etc/bind/zones` folder, you create a folder to store the zone file.

```sh
root@ns3:~# mkdir -p /etc/bind/zones
root@ns3:~# touch /etc/bind/zones/db.5.168.192
root@ns3:~# touch /etc/bind/zones/db.kursor.my.id
```

In each zone file, you enter the following script.

**Script /etc/bind/zones/db.kursor.my.id**

```sh
$TTL    604800
@    IN    SOA    ns3.kursor.my.id. admin.kursor.my.id. (
             2019061308    ; Serial
             604800        ; Refresh
              86400        ; Retry
            2419200        ; Expire
             604800 )    ; Negative Cache TTL
;
; name servers - NS records
    IN    NS    ns3.kursor.my.id.

; name servers - A records
ns3.kursor.my.id.    IN    A    192.168.5.3
```

<br/>

**Script /etc/bind/zones/db.5.168.192**

```sh
$TTL    604800
@    IN    SOA    kursor.my.id. root.kursor.my.id. (
            2019061304    ; Serial
             604800        ; Refresh
              86400        ; Retry
            2419200        ; Expire
             604800 )    ; Negative Cache TTL
; name servers
    IN    NS    ns3.kursor.my.id.

; PTR Records
204    IN    PTR    ns3.kursor.my.id.
```

<br/>

**Script /etc/bind/db.0**

```sh
$TTL	604800
@	IN	SOA	localhost. root.localhost. (
			      1		; Serial
			 604800		; Refresh
			  86400		; Retry
			2419200		; Expire
			 604800 )	; Negative Cache TTL
;
@	IN	NS	localhost.
```

<br/>

**Script /etc/bind/db.127**

```sh
$TTL	604800
@	IN	SOA	localhost. root.localhost. (
			      1		; Serial
			 604800		; Refresh
			  86400		; Retry
			2419200		; Expire
			 604800 )	; Negative Cache TTL
;
@	IN	NS	localhost.
1.0.0	IN	PTR	localhost.
```

<br/>

**Script /etc/bind/db.255**

```sh
$TTL	604800
@	IN	SOA	localhost. root.localhost. (
			      1		; Serial
			 604800		; Refresh
			  86400		; Retry
			2419200		; Expire
			 604800 )	; Negative Cache TTL
;
@	IN	NS	localhost.
```

<br/>

**Script /etc/bind/db.empty**

```sh
$TTL	86400
@	IN	SOA	localhost. root.localhost. (
			      1		; Serial
			 604800		; Refresh
			  86400		; Retry
			2419200		; Expire
			  86400 )	; Negative Cache TTL
;
@	IN	NS	localhost.
```

<br/>

**Script /etc/bind/db.local**

```sh
$TTL	604800
@	IN	SOA	localhost. root.localhost. (
			      2		; Serial
			 604800		; Refresh
			  86400		; Retry
			2419200		; Expire
			 604800 )	; Negative Cache TTL
;
@	IN	NS	localhost.
@	IN	A	127.0.0.1
@	IN	AAAA	::1
```
<br/>

## F. Check Zone

To ensure all zones are functioning properly, we can perform a check on each zone. First, we'll check the `named.conf` file.

```sh
root@ns3:~# named-checkconf /etc/bind/named.conf
```

Then you continue by checking the cursor.my.id zone and other zones.

```sh
root@ns3:~# named-checkzone kursor.my.id /etc/bind/zones/db.kursor.my.id
zone kursor.my.id/IN: loaded serial 2019061308
OK
root@ns3:~# named-checkzone 5.168.192.in-addr.arpa /etc/bind/zones/db.5.168.192
zone 5.168.192.in-addr.arpa/IN: loaded serial 2019061304
OK
```

If the `"OK"` message appears, it means the zone is running and functioning properly. Then, check the other zones as well, as shown in the example below.

```ruby
root@ns3:~# named-checkzone localhost /etc/bind/db.local
root@ns3:~# named-checkzone 127.in-addr.arpa /etc/bind/db.127
root@ns3:~# named-checkzone 0.in-addr.arpa /etc/bind/db.0
root@ns3:~# named-checkzone 255.in-addr.arpa /etc/bind/db.255
```

## G. Enable and Run Bind

The final step in this article is to enable and run the Bind DNS server. Before enabling Bind, make sure you've enabled the Bind DNS server with the following command.

```sh
root@ns3:~# systemctl enable named
```

After that, you run Bind with the systemctl or service command.

```sh
root@ns3:~# systemctl restart named
root@ns3:~# service named restart
```

BIND starts automatically after installation. You can check its status using the systemctl command as shown below.

```sh
root@ns3:~# systemctl status named
? named.service - BIND Domain Name Server
     Loaded: loaded (/usr/lib/systemd/system/named.service; enabled; preset: enabled)
     Active: active (running) since Wed 2024-05-22 06:43:50 UTC; 1s ago
       Docs: man:named(8)
   Main PID: 2147 (named)
     Status: "running"
      Tasks: 6 (limit: 1972)
     Memory: 5.4M (peak: 5.9M)
        CPU: 39ms
     CGroup: /system.slice/named.service
             +-2147 /usr/sbin/named -f -u bind

May 22 06:43:50 ns3 named[2147]: zone 127.in-addr.arpa/IN: loaded serial 1
May 22 06:43:50 ns3 named[2147]: zone 5.168.192.in-addr.arpa/IN: loaded serial 2019061304
May 22 06:43:50 ns3 named[2147]: zone localhost/IN: loaded serial 2
May 22 06:43:50 ns3 named[2147]: zone 0.in-addr.arpa/IN: loaded serial 1
May 22 06:43:50 ns3 named[2147]: zone 255.in-addr.arpa/IN: loaded serial 1
May 22 06:43:50 ns3 named[2147]: zone kursor.my.id/IN: loaded serial 2019061308
May 22 06:43:50 ns3 named[2147]: zone 5.168.192.in-addr.arpa/IN: sending notifies (serial 2019061304)
May 22 06:43:50 ns3 named[2147]: all zones loaded
May 22 06:43:50 ns3 named[2147]: running
May 22 06:43:50 ns3 systemd[1]: Started named.service - BIND Domain Name Server.
```

Once you're sure the Bind DNS server is running on your Ubuntu system, proceed to check all DNS records on the client machine. Run the dig command below to check the domain name "cursor.my.id." The result is that the domain name cursor.my.id resolves to the server IP address `"192.168.5.3"`, which is your Ubuntu server's IP address.

```sh
root@ns3:~# dig kursor.my.id

; <<>> DiG 9.18.24-0ubuntu5-Ubuntu <<>> kursor.my.id
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 8401
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 0, AUTHORITY: 1, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 1232
; COOKIE: 568d13a59ed7a3cb01000000664d95b5f467dd618f2675b8 (good)
;; QUESTION SECTION:
;kursor.my.id.                  IN      A

;; AUTHORITY SECTION:
kursor.my.id.           604800  IN      SOA     ns3.kursor.my.id. admin.kursor.my.id. 2019061308 604800 86400 2419200 604800

;; Query time: 0 msec
;; SERVER: 192.168.5.3#53(192.168.5.3) (UDP)
;; WHEN: Wed May 22 06:50:29 UTC 2024
;; MSG SIZE  rcvd: 115
```

Also check public DNS servers like Google.com, Yahoo.com, and others. The results show that your Bind DNS server should answer all these requests.

```sh
root@ns3:~# dig facebook.com

; <<>> DiG 9.18.24-0ubuntu5-Ubuntu <<>> facebook.com
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 19504
;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 1232
; COOKIE: be9840787bbb179701000000664d96c003a4a7009cb47df9 (good)
;; QUESTION SECTION:
;facebook.com.                  IN      A

;; ANSWER SECTION:
facebook.com.           48      IN      A       157.240.235.35

;; Query time: 0 msec
;; SERVER: 192.168.5.3#53(192.168.5.3) (UDP)
;; WHEN: Wed May 22 06:54:56 UTC 2024
;; MSG SIZE  rcvd: 85
```

<br/>

```ruby
root@ns3:~# dig one.one.one.one
root@ns3:~# dig dns9.quad9.net
```

By following this guide, you have successfully installed and configured the Bind DNS server as a local DNS resolver on your Ubuntu 24.04 server. You've learned how to customize the Bind configuration file, enable DNS caching, enhance privacy and security, optimize Bind performance, and configure the DNS resolver on client machines.

ISC-Bind Named provides reliable and efficient DNS resolution while prioritizing privacy and security. With a local DNS resolver, you can enjoy faster and more secure network communications with the Bind DNS server.