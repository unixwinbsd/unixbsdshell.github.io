---
title: Bind DNS Server with TLS using Stunnel on OpenBSD
date: "2025-06-03 17:11:11 +0100"
updated: "2025-06-03 17:11:11 +0100"
id: installing-dns-bind-stunnel-openbsd
lang: en
author: Iwan Setiawan
robots: index, follow
categories: openbsd
tags: DNSServer
background: https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/img/dns_bind_server_with_stunnel.jpg
toc: true
comments: true
published: true
excerpt: Stunnel has the power to create blocks of data in a format that cannot be deciphered by attackers. This allows for the creation of encrypted tunnels for specific applications, making it a popular tool in the world of ethical hacking and penetration testing. The encryption is known as a key and is stored locally on both the client and server computers.
keywords: bind, stunnel, openbsd, dns, dnscrypt, proxy, dnscrypt proxy, openbsd, dns server, installing
---

Stunnel is a versatile open source client-server based program that provides encryption for secure data communication using SSL/TLS protocols. Stunnel can run on various operating systems such as Unix, Linux, BSD, Windows, and others. Stunnel is designed to help secure HTTP/HTTPS ports, as Stunnel is able to encrypt traffic, proxy connections, and redirect applications so that they can run safely on your computer with untrusted network connections.

Stunnel can also inspect each packet in the encrypted tunnel and make adjustments to improve performance. Stunnel manages one or more client-server TCP/IP connections by creating encrypted tunnels through which only the client and server are allowed to communicate. These encrypted connections serve as a substitute for direct connections between the client application and the server application, which helps prevent communication from being interrupted while in transit from one end of the connection to the other.

Stunnel has the power to create blocks of data in a format that cannot be deciphered by attackers. This allows for the creation of encrypted tunnels for specific applications, making it a popular tool in the world of ethical hacking and penetration testing. The encryption is known as a key and is stored locally on both the client and server computers.

When communication is required between two endpoints, Stunnel connects to the server, receives the essential information for a particular connection (hostname, port number, and protocol) from the server, and then creates an encrypted tunnel over an encrypted TCP/IP connection. Once the tunnel is established, Stunnel releases its TCP/IP credentials and terminates it.

Stunnel software is an implementation of the SSL protocol or often called Secure Sockets Layer and TLS (Transport Layer Security). The benefits of Stunnel can facilitate end-to-end encryption, data integrity, and authentication between two hosts. The transmission protocol can be several protocols, such as FTP, IMAP, POP3, telnet, and HTTP. Stunnel can be used to authenticate with the server through a client certificate or with an authentication agent through single sign-on (SSO). Stunnel can also be used to provide an encrypted layer for network traffic that does not require authentication with the server.

<br/>
![diagram server dns bind with stunnel](https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/img/dns_bind_server_with_stunnel.jpg)
<br/>

## 1. How to Install Stunnel
As we know, Bind DNS server does not have direct DNS-over-TLS (DOT) support. If you want to enable DOT support on Bind, you need to add Stunnel, so that Bind can forward DNS directly to the TLS protocol. Due to its flexibility and power, Stunnel is able to encrypt TLS without making any major changes to the running client or server.

On OpenBSD, Stunnel repository is available in PKG package and port, you can install it directly. To make the process easier, use PKG package to install Stunnel, as in the example below.

```console
ns3# pkg_add stunnel
```
During the installation process, OpenBSD automatically creates a user and group for Stunnel. These groups and users are very useful during the Stunnel setup process.

Run the command below to grant file ownership.

```console
ns3# chown -R _stunnel:_stunnel /etc/stunnel/
```

## 2. Stunnel Configuration
On OpenBSD, the Stunnel configuration file is located at `/etc/stunnel`. Please open and edit the stunnel.conf file. We recommend that you delete the entire contents of the stunnel.conf script, and replace it with the script we have created. Adjust the script to your OpenBSD server specifications. Here is a complete example of the `/etc/stunnel/stunnel.conf` script.

```console
chroot = /etc/stunnel
setuid = _stunnel
setgid = _stunnel
;pid = /var/stunnel/stunnel.pid
;foreground = yes
;debug = info
;output = /var/stunnel/stunnel.log

[dnsclient]
client = yes
CApath = /etc/ssl
CAfile = /etc/ssl/cert.pem
cert = /etc/stunnel/server-cert.pem
key = /etc/stunnel/server-key.pem
accept = 192.168.5.3:1053
connect = 8.8.8.8:853
verifyChain = yes
verify = 4
checkIP = 8.8.8.8
checkHost = dns.google
OCSPaia = yes

[dnsserver]
client = no
cert = /etc/stunnel/client-cert.pem
key = /etc/stunnel/client-key.pem
accept = 853
connect = 1053
```

In the example script above, we divide three stunnel settings:
- Global Settings.
- DNS Server Settings, and
- DNS Client Settings

What you need to pay attention to is creating a TLS certificate. Here we provide an example of creating a TLS certificate for a DNS server and DNS client. The first thing you need to do is create a root `CA` certificate.

```console
ns3# cd /etc/stunnel
ns3# openssl genrsa 2048 > ca-key.pem
Generating RSA private key, 2048 bit long modulus
.................................................
..............
e is 65537 (0x010001)
ns3# openssl req -new -x509 -nodes -days 1825 -key ca-key.pem -out ca-cert.pem
```
After that you create a server certificate, remove the password and sign it with the `CA key`.

```console
ns3# openssl req -newkey rsa:2048 -days 1825 -nodes -keyout server-key.pem -out server-req.pem
ns3# openssl rsa -in server-key.pem -out server-key.pem
ns3# openssl x509 -req -in server-req.pem -days 1825 -CA ca-cert.pem -CAkey ca-key.pem -set_serial 01 -out server-cert.pem
```
Proceed by creating a client certificate, removing the password and signing with the `CA key`.

```console
ns3# openssl req -newkey rsa:2048 -days 1825 -nodes -keyout client-key.pem -out client-req.pem
ns3# openssl rsa -in client-key.pem -out client-key.pem
ns3# openssl x509 -req -in client-req.pem -days 1825 -CA ca-cert.pem -CAkey ca-key.pem -set_serial 01 -out client-cert.pem
```

<br/>
```console
ns3# openssl verify -CAfile ca-cert.pem server-cert.pem client-cert.pem
```

After that, activate Stunnel with the rcctl command.

```console
ns3# rcctl enable stunnel
ns3# rcctl restart stunnel
```


## 3. Configure ISC Bind DNS Server
The main requirement for setting up Bind is that you must have read the previous article ["Install ISC Bind DNS Server Using OpenBSD"](https://unixwinbsd.site/openbsd/instal-isc-dns-bind-server-openbsd/). Because in this article we will not discuss how to install Bind and we will assume that your ISC Bind server is running normally on OpenBSD.


Open the configuration file **/var/named/etc/named.conf**. Change the script below.

```console
zone "." {
  type forward;
  forward first;
  forwarders { 1.1.1.1; 8.8.8.8; };
};
```
Replace with the script below.

```console
zone "." {
  type forward;
  forward first;
  forwarders {
    192.168.5.3 port 1053;    
  };
};
```

Then you run ISC Bind DNS Server.

```console
foo# rcctl restart isc_named
```
The last step is to check ISC Bind, whether it is running or not.

```console
ns3# dig yahoo.com
ns3# nslookup facebook.com
```

Congratulations, you've successfully installed DNS Bind with Stunnel. You can implement it on your Windows computer by configuring the Windows interface to ensure Stunnel runs properly.

As you can see, setting up stunnel on OpenBSD is not difficult at all, so we hope this article was useful for you and you will adopt another way to use network services safely.