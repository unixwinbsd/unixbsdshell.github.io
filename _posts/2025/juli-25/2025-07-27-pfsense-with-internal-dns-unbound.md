---
title: PFSense with Internal DNS - Setup Remote Unbound DNS Resolver For LAN Network
date: "2025-07-27 13:32:21 +0100"
updated: "2025-09-30 14:21:03 +0100"
id: pfsense-with-internal-dns-unbound
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: DNSServer
background: https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/images/PFSense_with_Internal_DNS.jpg
toc: true
comments: true
published: true
excerpt: To carry out its duties, the DNS server requires a client program called a resolver to connect each user's computer to the DNS server. The DNS resolver searches the host address in the HOSTS file
keywords: pfsense, internal, dns, server, unbound, dnssec, python, modules, router, firewall, freebsd, resolver, lan, network, local
---

Before we study the contents of this article further, it's a good idea to know how DNS works. You need to understand that the DNS manager consists of 3 components, namely:

- DNS resolver: is a client which is the user's computer, the party that makes DNS requests from an application program.
- Recursive DNS server: is the party that performs searches via DNS based on the resolver's request, then provides answers to the resolver.
- Authoritative DNS server: the party that provides responses after recursive searches. The response can be an answer or a delegation to another DNS server.

To carry out its duties, the DNS server requires a client program called a resolver to connect each user's computer to the DNS server. The DNS resolver searches the host address in the HOSTS file. If the host address you are looking for has been found and provided, then the process is complete. The DNS resolver searches the cache data that the resolver has created to store the results of previous requests. If there is, then it is stored in the data cache then the results are given and finished.

The DNS resolver searches the first DNS server address specified by the user. The DNS server is assigned to look for domain names in its cache. If the domain name searched by the DNS server is not found, then the search is carried out by looking at the database files (zones) owned by the server. If it is still not found, a search is carried out by contacting another DNS server that is still related to the server in question. If it has been found, it is stored in cache and the results are given to the client (via web browser).

Then next, namely DHCP, Dynamic Host Configuration Protocol (DHCP) is a service that allows devices to distribute/assign IP addresses automatically to hosts on a network. How it works, the DHCP Server will respond to requests sent by the DHCP Client. Apart from IP addresses, DHCP is also able to distribute netmask information, default gateway, DNS and NTP server configuration and many more custom options (depending on whether the DHCP client can support it).
<br/>
<img alt="PFSense with Internal DNS" width="99%" class="lazyload" style="display: block; margin: auto;" src="{{ 'https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/images/PFSense_with_Internal_DNS.jpg' | relative_url }}">
<br/>

## 1. System specifications

- PFSense Version: PFSense 2.7.2-RELEASE (amd64), built on Wed Dec 6 20:10:00 UTC 2023
- Ethernet Card 1: nfe0 (WAN)
- Ethernet Card 2: rl0 (LAN)
- IP nfe0: 192.168.5.2 (WAN)
- IP rl0: 192.168.1.1 (LAN)
- CPU Type:
    - Intel(R) Core(TM)2 Duo CPU E8400 @ 3.00GHz
    - Current: 2670 MHz, Max: 3003 MHz
    - 2 CPUs: 1 package(s) x 2 core(s)
    - AES-NI CPU Crypto: No
    - QAT Crypto: No 


## 2. Setup DNS Server Settings

To activate DNS Resolver, the first thing you have to do is set the **DNS Server Settings** section. This setting is very important, because it relates to the DNS IP that will be used by PFSense. To start setting up this section, click the `System ->> General Setup` menu. To make it clearer, look at the image below.

<br/>
<img alt="menu system general setup" width="99%" class="lazyload" style="display: block; margin: auto;" src="{{ 'https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/images/menu_system_general_setup.png' | relative_url }}">
<br/>
<img alt="type the domain name and hostname" width="99%" class="lazyload" style="display: block; margin: auto;" src="{{ 'https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/images/type_the_domain_name_and_hostname.png' | relative_url }}">
<br/>

IP 192.168.1.1 is your PFSense LAN IP and we will make it the DNS server IP. On the DNS Resolution Behavior menu, select "Use remote DNS Servers, ignore local DNS". By default, PFSense will use the local DNS service with IP 127.0.0.1. This option will change the default DNS IP to your PFSense LAN IP.


## 3. Setup DNS Resolver (Unbound)

After that we continue by configuring the DNS Resolver (Unbound). To activate DNS Resolver, click the `Service ->> DNS Resolver`. Look at the image below.
<br/>
<img alt="setup dns resolver" width="99%" class="lazyload" style="display: block; margin: auto;" src="{{ 'https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/images/setup_dns_resolver.png' | relative_url }}">
<br/>

Then you check the `Enable DNS resolver` option. For other settings, you can follow the following image guide.

<br/>
<img alt="enable dns resolver" width="99%" class="lazyload" style="display: block; margin: auto;" src="{{ 'https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/images/enable_dns_resolver.png' | relative_url }}">
<br/>
<img alt="menu custome option" width="99%" class="lazyload" style="display: block; margin: auto;" src="{{ 'https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/images/menu_custome_option.png' | relative_url }}">
<br/>

The most important part of DNS Resolver settings is in the "Custom options" option. In this option you type the following script.

```yml
## Script "Custom options" DNS Resolver
forward-zone:
name: "."
forward-ssl-upstream: yes
forward-addr: 1.1.1.1@853
forward-addr: 1.0.0.1@853
forward-addr: 8.8.8.8@853
```

Your final step is to click the blue `"Save"` icon and the `"Apply Changes"` menu at the top. To make it easier for you, you can just leave the other options as default. Let the system manage it automatically.


## 4. Test DNS Resolver

In this section we will test the DNS Resolver that you have configured above. This test aims to ensure whether the DNS Resolver is running or not. The way to do the test is to open the `Diagnostics ->> Command Prompt` menu as shown in the image below.

<br/>
<img alt="how to test DNS resolver" width="99%" class="lazyload" style="display: block; margin: auto;" src="{{ 'https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/images/how_to_test_DNS_resolver.png' | relative_url }}">
<br/>

In the "Execute Shell Command" option, type the script **dig yahoo.com** as in the example in the following image.

<br/>
<img alt="command to test dns resolver" width="99%" class="lazyload" style="display: block; margin: auto;" src="{{ 'https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/images/1command_to_test_dns_resolver.jpg' | relative_url }}">
<br/>

What you need to pay attention to is that the server must point to your PFSense LAN IP, namely 192.168.1.1. If the test results are like the picture above. You can be sure that your PFSense DNS Resolver is running normally. Next, you must reset DNS to DNS IP 192.168.1.1.


## 5. Firewall Redirect to DNS Resolver

This section is only a summary of the contents of this article. After you have successfully run the DNS Resolver on PFSense, so that all clients connecting to the PFSense server use the DNS IP 192.168.1.1, we do a redirect on the Firewall. To do this, click the `Firewall ->> NAT ->> Fort Port Forward ->> Add`  menu. Look at the image below.

<br/>
![create NAT on PFSEnese](https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/img/create-nat-pfsese.png?ref_type=heads)

<br/>
![create port forward](/img/oct-25/create a port forward.png)
<br/>

![NAT Port Forward](https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/images/2nat_port_forward.jpg)
<br/>

Another option, you just make the default (don't change it). When finished, you can see the results of creating the NAT Firewall Rules above in `Firewall ->> Rules`.


![create firewall rules](https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/images/2create_firewall_rule.jpg)



## 6. Setup DNS Resolver Over TLS

In this section we will improve your PFSense DNS Resolver security system with OpenSSL TLS. With DNS over TLS configured in the DNS Resolver system, it will make it difficult for naughty hands to infiltrate your PFSense system.

To enable DNS Over TLS, you must enable SSH in PFSense. In this article, we will not discuss SSH in PFSesne, so we will just open SSH. If you use Ubuntu open Remmina and if you use Windows open the Putty application. In this article we use Remmina to remote the PFSesne server.

<br/>
<img alt="Menu Shell PFSense" width="99%" class="lazyload" style="display: block; margin: auto;" src="{{ 'https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/img/3menu-shel-pfsense.jpg' | relative_url }}">
<br/>

Then you type option number 8 to enter the Shell Remmina menu.

```yml
[2.7.2-RELEASE][root@nspfSense.unixwinbsd.site]/root: cd /var/unbound
[2.7.2-RELEASE][root@nspfSense.unixwinbsd.site]/var/unbound: fetch ftp://FTP.INTERNIC.NET/domain/named.cache -o /var/unbound/root.hints
```

After that, we create a TLS certificate with OpenSSL. Follow the script below.

```yml
[2.7.2-RELEASE][root@nspfSense.unixwinbsd.site]/var/unbound: openssl genrsa -des3 -out myCA.key 2048
[2.7.2-RELEASE][root@nspfSense.unixwinbsd.site]/var/unbound: openssl req -x509 -new -nodes -key myCA.key -sha256 -days 1825 -out myCA.pem
[2.7.2-RELEASE][root@nspfSense.unixwinbsd.site]/var/unbound: openssl req -new -newkey rsa:2048 -nodes -keyout mydomain.key -out mydomain.csr
[2.7.2-RELEASE][root@nspfSense.unixwinbsd.site]/var/unbound: openssl x509 -req -in mydomain.csr -CA myCA.pem -CAkey myCA.key -CAcreateserial -out mydomain.pem -days 1825 -sha256
```

The next step, you enter the TLS script into the DNS Resolver configuration, as shown below.

<br/>
![display custom option pfsense](https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/images/display_custom_option_pfsense.jpg)
<br/>

```
root-hints: "/var/unbound/root.hints"

tls-service-key: "/var/unbound/mydomain.key"
tls-service-pem: "/var/unbound/mydomain.pem"
tls-port: 853

forward-zone:
name: "."
forward-ssl-upstream: yes
forward-addr: 1.1.1.1@853
forward-addr: 1.0.0.1@853
forward-addr: 8.8.8.8@853
```

Test and see the results, you will notice on the computer screen whether your PFSense DNS Resolver server is running properly.


```
[2.7.2-RELEASE][root@nspfSense.unixwinbsd.site]/var/unbound: dig google.com

; <<>> DiG 9.18.19 <<>> google.com
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 8176
;; flags: qr rd ra; QUERY: 1, ANSWER: 6, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 1432
;; QUESTION SECTION:
;google.com.			IN	A

;; ANSWER SECTION:
google.com.		265	IN	A	142.251.12.139
google.com.		265	IN	A	142.251.12.101
google.com.		265	IN	A	142.251.12.138
google.com.		265	IN	A	142.251.12.100
google.com.		265	IN	A	142.251.12.113
google.com.		265	IN	A	142.251.12.102

;; Query time: 419 msec
;; SERVER: 192.168.1.1#53(192.168.1.1) (UDP)
;; WHEN: Fri Apr 26 00:31:30 UTC 2024
;; MSG SIZE  rcvd: 135
```

If the server shows the IP 192.168.1.1 as in blue above, it means your DNS Resolver is running normally.

You can also test via a Windows computer. Configure your computer's IP address to DHCP mode (do not use static IP). Make sure the DNS IP address read is IP 192.168.1.1.

If everything is according to the test instructions, now you have a DNS Resolver that is capable of storing DNS addresses. If a client connects to your PFSense and requests a DNS address, it will be served directly by your PFSense, thereby increasing your client's internet speed.