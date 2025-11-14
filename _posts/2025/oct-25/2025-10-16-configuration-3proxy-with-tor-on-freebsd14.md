---
title: Configuring 3Proxy with TOR Onion on FreeBSD
date: "2025-10-16 14:15:24 +0100"
updated: "2025-10-16 14:15:24 +0100"
id: configuration-3proxy-with-tor-on-freebsd14
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: Anonymous
background: https://gitea.com/UnixBSDShell/OpenBSD-Web-APP/raw/branch/main/image/oct-25-87.jpg
toc: true
comments: true
published: true
excerpt: Here, I'll explain how to set up a secure internet environment using a robust FreeBSD server equipped with 3Proxy, Tor, and Privoxy. Combining these three applications can enhance your computer's security, especially on ports 80 and 443.
keywords: 3proxy, polipo, proxy, server, tor, sock, sock5, port, freebsd, http, anonymous, internet, access, configuration
---

It's considered impossible to achieve maximum security when surfing the internet, as spam, ads, and bots can spy on our data and identity. However, we can minimize the level of online crime. Several tools and software can help achieve at least a level of anonymity and privacy that approaches perfect security. Here, I'll explain how to set up a secure internet environment using a robust FreeBSD server equipped with 3Proxy, Tor, and Privoxy. Combining these three applications can enhance your computer's security, especially on ports 80 and 443.

I won't explain installing TOR and Privoxy in this tutorial. We'll focus on installing and configuring 3Proxy. You can read articles about installing TOR and Privoxy elsewhere online.

## A. System specifications:
- OS: FreeBSD 13.2 Stable
- CPU: AMD Phenom(tm) II X4 955 Processor
- IP Server: 192.168.9.3
- Interface: em0 ( 1 Land Card )
- Hostname: router2
- Domain: unixexplore.com

<br/>

![3proxy with tor](https://gitea.com/UnixBSDShell/OpenBSD-Web-APP/raw/branch/main/image/oct-25-87.jpg)

<br/>

## B. What is 3Proxy

Three Proxy is a Unix-based proxy server system that can run on HTTP, HTTPS, and FTP ports. It also supports [SOCKSv4, SOCKSv5, POP3, and SMTP proxies](https://forums.freebsd.org/threads/howto-use-tor-network-and-web-proxy.40307/). 3Proxy works on both TCP and UDP ports. You can use each proxy as a standalone program (socks, proxy, tcppm, udppm, pop3p) or use a combined program (3proxy).

The federated proxy also supports features such as access control, bandwidth throttling, daily/weekly/monthly traffic restrictions, proxy chains, log rotation, sylog and ODBC logging, etc.


## C. 3Proxy Installation Process

To perform the installation, we'll need to use FreeBSD Ports. First, log in as root on the FreeBSD server. Once logged in, type the following script to [install 3PRoxy](https://unixwinbsd.site/freebsd/polipo-proxy-server-with-tor-sock-on-freebsd).


```
root@router2:~ # cd /usr/ports/net/3proxy
root@router2:/usr/ports/net/3proxy # make install clean
```


Next, we add the script in the `/etc/rc.conf` file.


```
root@router2:~ # ee /etc/rc.conf
threeproxy_enable="YES"
threeproxy_flags="/usr/local/etc/3proxy.cfg"
```

This script is useful for the boot process. If our FreeBSD server is rebooted or shut down, 3Proxy will automatically start because the rc.conf file is enabled.

Then, we restart our FreeBSD server.

```
root@router2:~ # reboot
```

After rebooting your FreeBSD Server, open the log file and note which ports 3Proxy is running on. Here's an example of a 3Proxy log file.

It turns out that 3Proxy supports multiple ports, including one that supports DNS, port 53. Once you know which ports 3Proxy is running on, edit the 3proxy.cfg file in the `/usr/local/etc/3proxy.cfg` folder.

```
nserver 1.1.1.1:53/tcp
nserver 1.0.0.1:53/tcp
nscache 65536
daemon
log /var/log/3proxy/log D
logformat "- +_L%t.%.  %N.%p %E %U %C:%c %R:%r %O %I %h %T"
rotate 30
```

The parent is the BACKEND proxy IP and Port. In this tutorial, we will use the TOR and Privoxy BACKENDs.

The TOR IP/Port is 192.168.9.3 9050, and the Privoxy IP/Port is 192.168.9.3 8008.

```
parent 500 socks5 192.168.9.3 9050
parent 1000 connect 192.168.9.3 8008
```

What you need to pay attention to is filling in the external and internal IP, if your FreeBSD server computer only uses 1 interface or 1 landcard then the internal and external IP must be the same.

```
external 192.168.9.3
internal 192.168.9.3
```

For the complete source code for the 3proxy.cfg file, you can copy and paste it at the end of this article.

Once the 3proxy.cfg file is configured, restart 3PRoxy.

```
root@router2:~ # service 3proxy restart
```

## C. Test 3Proxy

The 3Proxy test will be conducted on the Mozilla Firefox browser. You can also do it on other browsers such as Yandex, Opera, Comodo, etc.

Open the Firefox browser, click the settings menu, and if you have configured everything above, you can now open your web browser.

Complete the installation and configuration of 3Proxy with the TOR and Privoxy backends. Now... you have your own proxy server. Enjoy and experience the sensation of safe and comfortable surfing, without annoying ads or hackers tracking your identity data.

Example of the complete source code from the 3proxy.cfg file located in the `/usr/local/etc/3proxy.cfg` folder. You can copy and paste this source code directly, as this tutorial uses this source code. You only need to set the internal IP, external IP, and parent IP.


```
#!/usr/local/bin/3proxy
# Yes, 3proxy.cfg can be executable, in this case you should place
# something like
#config /usr/local/3proxy/3proxy.cfg
# to show which configuration 3proxy should re-read on realod.

#system "echo Hello world!"
# you may use system to execute some external command if proxy starts

# We can configure nservers to avoid unsafe gethostbyname() usage
#nserver 1.1.1.1
#nserver 1.0.0.1
nserver 1.1.1.1:53/tcp
nserver 1.0.0.1:53/tcp
# nscache is good to save speed, traffic and bandwidth
nscache 65536

#nsrecord porno.security.nnov.ru 0.0.0.0
# nobody will be able to access porno.security.nnov.ru by the name.
#nsrecord wpad.security.nnov.ru www.security.nnov.ru
# wpad.security.nnov.ru will resolve to www.security.nnov.ru for
# clients


timeouts 1 5 30 60 180 1800 15 60
# Here we can change timeout values

users 3APA3A:CL:3apa3a "test:CR:$1$qwer$CHFTUFGqkjue9HyhcMHEe1"
# note that "" required, overvise $... is treated as include file name.
# $1$qwer$CHFTUFGqkjue9HyhcMHEe1 is 'test' in MD5 crypt format.
#users $/usr/local/etc/3proxy/passwd
# this example shows you how to include passwd file. For included files
# <CR> and <LF> are treated as field separators.

daemon
# now we will not depend on any console (daemonize). daemon must be given
# before any significant command on *nix.

#service
# service is required under NT if you want 3proxy to start as service

log /var/log/3proxy/log D
#log c:\3proxy\logs\3proxy.log D
# log allows to specify log file location and rotation, D means logfile
# is created daily

#logformat "L%d-%m-%Y %H:%M:%S %z %N.%p %E %U %C:%c %R:%r %O %I %h %T"
#logformat "Linsert into log (l_date, l_user, l_service, l_in, l_out, l_descr) values ('%d-%m-%Y %H:%M:%S', '%U', '%N', %I, %O, '%T')"
#Compatible with Squid access.log:
#
#"- +_G%t.%. %D %C TCP_MISS/200 %I %1-1T %2-2T %U DIRECT/%R application/unknown"
#or, more compatible format without %D
#"- +_G%t.%.      1 %C TCP_MISS/200 %I %1-1T %2-2T %U DIRECT/%R application/unknown"
#
#Compatible with ISA 2000 proxy WEBEXTD.LOG (fields are TAB-delimited):
#
#"-	+ L%C	%U	Unknown	Y	%Y-%m-%d	%H:%M:%S	w3proxy	3PROXY	-	%n	%R	%r	%D	%O	%I	http	TCP	%1-1T	%2-2T	-	-	%E	-	-	-"
#
#Compatible with ISA 2004 proxy WEB.w3c
#
#"-	+ L%C	%U	Unknown	%Y-%m-%d	%H:%M:%S	3PROXY	-	%n	%R	%r	%D	%O	%I	http	%1-1T	%2-2T	-	%E	-	-	Internal	External	0x0	Allowed"
#
#Compatible with ISA 2000/2004 firewall FWSEXTD.log (fields are TAB-delimited):
#
#"-	+ L%C	%U	unnknown:0:0.0	N	%Y-%m-%d	%H:%M:%S	fwsrv	3PROXY	-	%n	%R	%r	%D	%O	%I	%r	TCP	Connect	-	-	-	%E	-	-	-	-	-"
#
#Compatible with HTTPD standard log (Apache and others)
#
#"-""+_L%C - %U [%d/%o/%Y:%H:%M:%S %z] ""%T"" %E %I"
#or more compatible without error code
#"-""+_L%C - %U [%d/%o/%Y:%H:%M:%S %z] ""%T"" 200 %I"

# in log file we want to have underscores instead of spaces
logformat "- +_L%t.%.  %N.%p %E %U %C:%c %R:%r %O %I %h %T"


archiver gz /usr/bin/gzip %F
#archiver zip zip -m -qq %A %F
#archiver zip pkzipc -add -silent -move %A %F
#archiver rar rar a -df -inul %A %F
# if archiver specified log file will be compressed after closing.
# you should specify extension, path to archiver and command line, %A will be
# substituted with archive file name, %f - with original file name.
# Original file will not be removed, so archiver should care about it.

rotate 30
# We will keep last 30 log files

#auth iponly
#auth nbname
#auth strong
# auth specifies type of user authentication. If you specify none proxy
# will not do anything to check name of the user. If you specify
# nbname proxy will send NetBIOS name request packet to UDP/137 of
# client and parse request for NetBIOS name of messanger service.
# Strong means that proxy will check password. For strong authentication
# unknown user will not be allowed to use proxy regardless of ACL.
# If you do not want username to be checked but wanna ACL to work you should
# specify auth iponly.


#allow ADMINISTRATOR,root
#allow * 127.0.0.1,192.168.1.1 * *
allow * 192.168.9.3 * *
#allow * 192.168.9.3/24 * 25,53,110,20-21,1024-65535
parent 500 socks5 192.168.9.3 9050
parent 1000 connect 192.168.9.3 8008
# we will allow everything if username matches ADMINISTRATOR or root or
# client ip is 127.0.0.1 or 192.168.1.1. Overwise we will redirect any request
# to port 80 to our Web-server 192.168.0.2.
# We will allow any outgoing connections from network 192.168.1.0/24 to
# SMTP, POP3, FTP, DNS and unprivileged ports.
# Note, that redirect may also be used with proxy or portmapper. It will
# allow you to redirect requests to different ports or different server
# for different clients.

#  sharing access to internet

external 192.168.9.3
# external is address 3proxy uses for outgoing connections. 0.0.0.0 means any
# interface. Using 0.0.0.0 is not good because it allows to connect to 127.0.0.1

internal 192.168.9.3
# internal is address of interface proxy will listen for incoming requests
# 127.0.0.1 means only localhost will be able to use this proxy. This is
# address you should specify for clients as proxy IP.
# You MAY use 0.0.0.0 but you shouldn't, because it's a chance for you to
# have open proxy in your network in this case.

auth none
# no authentication is requires

dnspr
#fakeresolve

# dnsproxy listens on UDP/53 to answer client's DNS requests. It requires
# nserver/nscache configuration.


#external $./external.ip
#internal $./internal.ip
# this is just an alternative form fo giving external and internal address
# allows you to read this addresses from files

#auth strong
# We want to protect internal interface
deny * * 127.0.0.1,192.168.1.1
# and llow HTTP and HTTPS traffic.
allow * * * 80-88,8080-8088 HTTP
allow * * * 443,8443 HTTPS
proxy -n

auth none
# pop3p will be used without any authentication. It's bad choice
# because it's possible to use pop3p to access any port
pop3p

tcppm 25 mail.my.provider 25
#udppm -s 53 ns.my.provider 53
# we can portmap port TCP/25 to provider's SMTP server and UDP/53
# to provider's DNS.
# Now we can use our proxy as SMTP and DNS server.
# -s switch for UDP means "single packet" service - instead of setting
# association for period of time association will only be set for 1 packet.
# It's very userfull for services like DNS but not for some massive services
# like multimedia streams or online games.

#auth strong
flush
allow 3APA3A,test
maxconn 20
socks
# for socks we will use password authentication and different access control -
# we flush previously configured ACL list and create new one to allow users
# test and 3APA3A to connect from any location


#auth strong
flush
internal 127.0.0.1
allow 3APA3A 127.0.0.1
maxconn 3
admin
#only allow acces to admin interface for user 3APA3A from 127.0.0.1 address
#via 127.0.0.1 address.

# map external 80 and 443 ports to internal Web server
# examples below show how to use 3proxy to publish Web server in internal
# network to Internet. We must switch internal and external addresses and
# flush any ACLs

#auth none
#flush
#external $./internal.ip
#internal $./external.ip
#maxconn 300
#tcppm 80 websrv 80
#tcppm 443 websrv 443


#chroot /usr/local/jail
#setgid 65535
#setuid 65535
# now we needn't any root rights. We can chroot and setgid/setuid.
```

You can use the complete script example from the `/usr/local/etc/3proxy.cfg` file above as a guide for installation and configuration.