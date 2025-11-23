---
title: Setup ddclient Dynamic DNS on FreeBSD with He Net DDNS Server
date: "2025-11-23 10:11:33 +0000"
updated: "2025-11-23 10:11:33 +0000"
id: setup-ddclient-dynamic-dns-on-freebsd-he-net-ddns
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: DNSServer
background: https://raw.githubusercontent.com/unixwinbsd/unixbsdshell.github.io/refs/heads/main/img/nop-25/nop-25-026.jpg
toc: true
comments: true
published: true
excerpt: To create a 3rd level domain from my 2nd level domain and bind this 3rd level domain to HE.net by assigning this domain name to HE.net name servers.
keywords: ddclient, ddns, dynamic, dns, he.net, server, freebsd, setup, dns server
---

Sometimes you need to register DNS for a computer with a dynamic IP address. A simple way to do this is to use a service like he.net, which we'll explain in this article. However, this method can sometimes work poorly or even very well. For more details, you can continue reading our very clear article.

## A. System Specifications:

- OS: FreeBSD 13.2 Stable
- Interface: nfe0
- Interface IP nfe0: 192.168.5.2
- Hostname: ns6
- Domain: datainchi.com
- ddclient version: ddclient-3.9.1

## B. What is Dynamic DNS?

Often when browsing the internet, we need a static IP address. This can be obtained by contacting your internet provider directly or by using a special service called Dynamic DNS (also called DynDNS, DDNS, or DinDNS). Let's discuss the second option in more detail. Dynamic DNS is a service that assigns specific IP addresses to network equipment, allowing users to connect to their devices from anywhere with a static IP address.

Many modern routers support the DDNS protocol. Not everyone knows why it's needed and how to use it. In short, DDNS stands for Dynamic DNS, a method for updating domain name information on a server. When your router connects to the internet, it's automatically assigned an IP address. If this is an external address, known as a "white" address, you can use it to access the router not only from your home network but also from any device connected to the internet outside your home.

However, providers typically issue dynamic IP addresses, which can change. After changing them, access to the router is lost. Thanks to a dynamic DNS service, you can assign a domain name to your router and still retain access even if your provider changes the IP address.
Other computers on the network can connect to your device without realizing the address has changed. Now that we know what DDNS is and understand what it is, it's easier to understand how to use it.

## C. Adding a Domain to He.Net

HeNet is a service that provides a variety of security and optimization services that help both small and large sites. Using HeNet, you can protect your website from DDoS attacks, manage website optimization, perform caching, secure connections, analyze traffic, and much more. We'll cover many of these features in this article.

To create a third-level domain from my second-level domain and bind this third-level domain to HE.net, you can assign this domain name to the HE.net nameservers. (This must be done on the second-level domain nameservers.)

The first step is to log in to the H.Net website. Then, add a domain by clicking the `"Add new domain"` menu.

<img alt="Create a new domain on the net" width="99%" class="lazyload" style="display: block; margin: auto;" src="{{ 'https://raw.githubusercontent.com/unixwinbsd/unixbsdshell.github.io/refs/heads/main/img/nop-25/nop-25-026.jpg' | absolute_url }}">

<br/>

<img alt="Type the domain name" width="99%" class="lazyload" style="display: block; margin: auto;" src="{{ 'https://raw.githubusercontent.com/unixwinbsd/unixbsdshell.github.io/refs/heads/main/img/nop-25/nop-25-024.jpg' | absolute_url }}">

<br/>

<img alt="create A address" width="99%" class="lazyload" style="display: block; margin: auto;" src="{{ 'https://raw.githubusercontent.com/unixwinbsd/unixbsdshell.github.io/refs/heads/main/img/nop-25/nop-25-025.jpg' | absolute_url }}">

After that, click `ns1.datainchi.com`, `ns2.datainchi.com`, `ns3.datainchi.com`, `ns4.datainchi.com`, then edit them. Activate the `"Enable entry for dynamic DNS"` option.

<img alt="type type A record" width="99%" class="lazyload" style="display: block; margin: auto;" src="{{ 'https://raw.githubusercontent.com/unixwinbsd/unixbsdshell.github.io/refs/heads/main/img/nop-25/nop-25-027.jpg' | absolute_url }}">

The IPv4 Address option will be automatically filled in by the He.Net server based on the IP address of your Internet Service Provider (ISP). In this article, the dynamic IP address of your Internet Service Provider (ISP) is `36.90.9.139`.

## D. DDClient Installation Process

Before installing ddclient, we must first install the dependencies required by ddclient. The following dependencies must be installed.

```yml
root@ns6:~ # pkg install curl gmake autoconf automake perl5 p5-Data-Validate-IP
```

Then we install ddclient, use the FreeBSD port system so that all dependencies can be installed perfectly.

```yml
root@ns6:~ # cd /usr/ports/dns/ddclient
root@ns6:/usr/ports/dns/ddclient # make install clean
```

Here is the script from the developer after the ddclient installation process is complete.

```console
===>  Installing for ddclient-3.9.1
===>  Checking if ddclient is already installed
===>   Registering installation for ddclient-3.9.1
Installing ddclient-3.9.1...
To configure ddclient, edit the following file:

        /usr/local/etc/ddclient.conf

If you would like to run ddclient as a daemon add the
following line to /etc/rc.conf

        ddclient_enable="YES"

If you would like to force ddclient to update your account
daily regardless of IP changes add the following line to
your /etc/periodic.conf

        daily_ddclient_force_enable="YES"

===>  Cleaning for ddclient-3.9.1
```

## E. DDClient configuration

So that ddclient can run automatically on the FreeBSD server, create the rc.d script in the `/etc/rc.conf` file and insert the script below into that file.

```yml
root@ns6:/usr/ports/dns/ddclient # ee /etc/rc.conf
ddclient_enable="YES"
```

If you want to force ddclient to update your account every day regardless of IP changes, add the following line to your `/etc/periodic.conf`.

```yml
root@ns6:~ # touch  /etc/periodic.conf
root@ns6:~ # chmod +x /etc/periodic.conf
root@ns6:~ # ee /etc/periodic.conf
daily_ddclient_force_enable="YES"
```

ddclient is a Perl client used to update dynamic DNS entries for accounts on many dynamic DNS services. This client uses curl for internet access. DDClient requires a configuration file with the appropriate settings to function. The DDClient configuration file is called ddclient.conf.

After installing ddclient, you must create/edit `/usr/local/etc/ddclient.conf`. The following is an example configuration that updates the IP address for the third-level hostname HeNet.

```console
root@ns6:~ # ee /usr/local/etc/ddclient.conf

daemon=300				# check every 300 seconds
syslog=yes				# log update msgs to syslog
mail=root				# mail all msgs to root
mail-failure=root			# mail failed update msgs to root
pid=/var/run/ddclient.pid		# record PID in file.
ssl=yes					# use ssl-support.  Works with

use=ip,                     ip=192.168.5.2
use=if,                     if=nfe0
#use=web					# via web
use=web, web=whatismyip.org
protocol=dyndns2				# default protocol
server=dyn.dns.he.net  # default
login=kanakarobih
password=E1WAP1J6rTu0Rdy4
www.datainchi.com,datainchi.com
```

In the LogIn option, fill in the username from the He.Net site.

<img alt="create a username he net" width="99%" class="lazyload" style="display: block; margin: auto;" src="{{ 'https://raw.githubusercontent.com/unixwinbsd/unixbsdshell.github.io/refs/heads/main/img/nop-25/nop-25-028.jpg' | absolute_url }}">

In the Password option, enter the password from the He.Net site.

<img alt="generate password" width="99%" class="lazyload" style="display: block; margin: auto;" src="{{ 'https://raw.githubusercontent.com/unixwinbsd/unixbsdshell.github.io/refs/heads/main/img/nop-25/nop-25-029.jpg' | absolute_url }}">

<br/>

<img alt="create a password for the net" width="99%" class="lazyload" style="display: block; margin: auto;" src="{{ 'https://raw.githubusercontent.com/unixwinbsd/unixbsdshell.github.io/refs/heads/main/img/nop-25/nop-25-030.jpg' | absolute_url }}">

After that restart DDClient.

```yml
root@ns6:~ # service ddclient restart
Stopping ddclient.
Waiting for PIDS: 862.
Starting ddclient.
```

## F. Test DDClient

If you are using an Unbound DNS Server, enable the following script in the `/usr/local/etc/unbound/unbound.conf` file.

```yml
outgoing-interface: 0.0.0.0
```

Use the command below to check if DDClient is connected to He.Net Server.

```console
root@ns6:~ # dig www.datainchi.com

; <<>> DiG 9.18.20 <<>> www.datainchi.com
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 251
;; flags: qr rd ra; QUERY: 1, ANSWER: 3, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 1232
;; QUESTION SECTION:
;www.datainchi.com.             IN      A

;; ANSWER SECTION:
www.datainchi.com.      86400   IN      CNAME   datainchi.com.
datainchi.com.          86400   IN      A       36.90.9.139
datainchi.com.          86400   IN      A       192.168.5.2

;; Query time: 0 msec
;; SERVER: 192.168.5.2#53(192.168.5.2) (UDP)
;; WHEN: Sun Nov 26 09:20:31 WIB 2023
;; MSG SIZE  rcvd: 92
```

```console
root@ns6:~ # nslookup www.datainchi.com
Server:         192.168.5.2
Address:        192.168.5.2#53

Non-authoritative answer:
www.datainchi.com       canonical name = datainchi.com.
Name:   datainchi.com
Address: 36.90.9.139
Name:   datainchi.com
Address: 192.168.5.2
```

```console
root@ns6:~ # dig datainchi.com

; <<>> DiG 9.18.20 <<>> datainchi.com
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 62339
;; flags: qr rd ra; QUERY: 1, ANSWER: 2, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 1232
;; QUESTION SECTION:
;datainchi.com.                 IN      A

;; ANSWER SECTION:
datainchi.com.          85650   IN      A       36.90.9.139
datainchi.com.          85650   IN      A       192.168.5.2

;; Query time: 0 msec
;; SERVER: 192.168.5.2#53(192.168.5.2) (UDP)
;; WHEN: Sun Nov 26 09:33:01 WIB 2023
;; MSG SIZE  rcvd: 74
```

IP `36.90.9.139` is a dynamic public IP address from your Internet Service Provider (ISP), and IP 192.168.5.2 is an unbound private DNS server IP address.

If the check results show the above, it means DDClient is connected to the He.Net dynamic server.

## G. Updating ISP Public IP

After DDClient successfully connects to the He.Net server and obtains a public IP address from the ISP, the next step is to create a script to automatically obtain a public IP address. Public IP update requests can be sent via http or https.

The most basic example of a public IP update.

```yml
curl "https://dyn.example.com:password@dyn.dns.he.net/nic/update?hostname=dyn.example.com&myip=192.168.0.1"
```

From the example script above, change the password to your DDClient password, which is E1WAP1J6rTu0Rdy4. Replace the hostname with the hostname you created on the He.Net site, for example, ns1.datainchi.com. Replace the IP address with your FreeBSD private server IP address, which is `192.168.5.2`.

Examine the example below and see the results. If the message `"good"` appears, the DDClient public IP address has been successfully updated.

```yml
root@ns6:~ # curl "https://ns1.datainchi.com:E1WAP1J6rTu0Rdy4@dyn.dns.he.net/nic/update?hostname=ns1.datainchi.com&myip=192.168.5.2"
good 192.168.5.2root@ns6:~ #
```

After thoroughly reading and practicing this article, it's clear that it provides useful knowledge on how to set up dynamic DNS on a FreeBSD server. From start to finish, the author provides a thorough understanding of the topic. Thank you for reading. If you need further information, please contact us via email.
