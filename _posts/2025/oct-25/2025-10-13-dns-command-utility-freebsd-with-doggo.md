---
title: FreeBSD INETD Daemon and inetd conf Configuration Files
date: "2025-10-13 10:49:33 +0100"
updated: "2025-10-13 10:49:33 +0100"
id: dns-command-utility-freebsd-with-doggo
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: DNSServer
background: /img/oct-25/oct-25-71.jpg
toc: true
comments: true
published: true
excerpt: Doggo is a modern command-line DNS lookup utility similar to dig, with colorful output, support for DNS-over-TLS and DNS-over-HTTPS protocols, and more. In this article we will discuss how to install and use doggo on a FreeBSD system.
keywords: freebsd, dns, doggo, command, utility, dns server, dig
---

Doggo is a modern command-line DNS lookup utility similar to dig, with colorful output, support for DNS-over-TLS and DNS-over-HTTPS protocols, and more. Doggo is available on almost all UNIX operating systems, including Linux, macOS, and Microsoft Windows. Its colorful output and support for DNSCrypt, DOT, and DOT make Doggo very user-friendly.

Doggo is a modern command-line DNS client written in Golang. Therefore, it's no surprise that it's called `"dog + go = doggo"`. The Doggo utility displays information concisely and neatly. Similar to dig, it performs DNS lookups and displays the responses returned from the queried nameservers, useful for troubleshooting DNS issues.


![doggo dns utility](/img/oct-25/oct-25-71.jpg)


In this article we will discuss how to install and use doggo on a FreeBSD system.

## A. Doggo Features
1. Colorful output
2. Supports JSON format
3. Supports multiple transport protocols
- DNS over HTTPS (DoH)
- DNS over TLS (DoT)
- DNS over QUIC (DoQ)
- DNS over TCP
- DNS over UDP
- DNS over DNSCrypt
4. Supports ndots and lookup configuration from resolv.conf or command-line arguments.
5. Supports IP4 and IP6.
6. Supports multiple resolvers simultaneously.
7. Available as a web tool, visit: https://doggo.mrkaran.dev.
8. Works with zsh and fish shell.
9. Capable of performing reverse DNS lookups.

## B. Doggo Installation Process
To install Doggo on FreeBSD, you'll need to use FreeBSD's ports system. Here's an example of a doggo installation script.


```
root@ns1:~ # cd /usr/ports/dns/doggo
root@ns1:/usr/ports/dns/doggo # make install clean
```

## C. How to Use Doggo
### a. Do a DNS search for google.com

```
root@ns1:~ # doggo google.com
NAME                       	        TYPE 	    CLASS	TTL   	ADDRESS                    	        NAMESERVER 
google.com.                	        CNAME	    IN   	        213s  	forcesafesearch.google.com.	1.1.1.1:53	
forcesafesearch.google.com.	A    	            IN   	        71314s	216.239.38.120             	        1.1.1.1:53	
google.com.                	        CNAME	    IN   	        213s  	forcesafesearch.google.com.	1.0.0.1:53	
forcesafesearch.google.com.	A    	            IN   	        71314s	216.239.38.120             	        1.0.0.1:53
```

### b. MX record query for google.com Using Resolver 8.8.8.8

```
root@ns1:~ # doggo MX google.com @8.8.8.8
NAME       	TYPE	CLASS	TTL 	ADDRESS            	        NAMESERVER 
google.com.	MX  	IN   	        300s	10 smtp.google.com.	8.8.8.8:53
```
<br/>

```
root@ns1:~ # doggo -t MX -n 1.1.1.1 google.com
NAME       	TYPE	CLASS	TTL 	ADDRESS            	        NAMESERVER 
google.com.	MX  	IN   	        300s	10 smtp.google.com.	1.1.1.1:53	
google.com.	MX  	IN   	        300s	10 smtp.google.com.	1.0.0.1:53
```

### c. Displaying Query DNS Records For archive.org Using Cloudflare DoH resolver

```
root@ns1:~ # doggo archive.org @https://cloudflare-dns.com/dns-query 
NAME        	TYPE	CLASS	TTL 	ADDRESS      	NAMESERVER                           
archive.org.	A   	        IN   	        216s	207.241.224.2	        https://cloudflare-dns.com/dns-query
```

### d. Requesting DNS Data for unixwinbsd.blogspot.com With JSON Output

```
root@ns1:~ # doggo unixwinbsd.blogspot.com --json
[
    {
        "answers": [
            {
                "name": "unixwinbsd.blogspot.com.",
                "type": "CNAME",
                "class": "IN",
                "ttl": "300s",
                "address": "blogspot.l.googleusercontent.com.",
                "status": "",
                "rtt": "19ms",
                "nameserver": "1.1.1.1:53"
            },
            {
                "name": "blogspot.l.googleusercontent.com.",
                "type": "A",
                "class": "IN",
                "ttl": "263s",
                "address": "74.125.200.132",
                "status": "",
                "rtt": "19ms",
                "nameserver": "1.1.1.1:53"
            }
        ],
        "authorities": null,
        "questions": [
            {
                "name": "unixwinbsd.blogspot.com.",
                "type": "A",
                "class": "IN"
            }
        ]
    },
    {
        "answers": [
            {
                "name": "unixwinbsd.blogspot.com.",
                "type": "CNAME",
                "class": "IN",
                "ttl": "300s",
                "address": "blogspot.l.googleusercontent.com.",
                "status": "",
                "rtt": "0ms",
                "nameserver": "1.0.0.1:53"
            },
            {
                "name": "blogspot.l.googleusercontent.com.",
                "type": "A",
                "class": "IN",
                "ttl": "263s",
                "address": "74.125.200.132",
                "status": "",
                "rtt": "0ms",
                "nameserver": "1.0.0.1:53"
            }
        ],
        "authorities": null,
        "questions": [
            {
                "name": "unixwinbsd.blogspot.com.",
                "type": "A",
                "class": "IN"
            }
        ]
    }
```

### e. Request DNS Data For google.com and Display RTT

```
root@ns1:~ # doggo google.com --time
NAME                       	        TYPE 	    CLASS	TTL   	ADDRESS                    	        NAMESERVER	TIME TAKEN 
google.com.                	        CNAME	    IN   	        265s  	forcesafesearch.google.com.	1.1.1.1:53	        8ms       	
forcesafesearch.google.com.	A    	            IN   	        81816s	216.239.38.120             	        1.1.1.1:53	        8ms       	
google.com.                	        CNAME	    IN   	        265s  	forcesafesearch.google.com.	1.0.0.1:53	        0ms       	    
forcesafesearch.google.com.	A    	            IN       	        81816s	216.239.38.120             	        1.0.0.1:53	        0ms
```

### f. Query A, NS, and MX Records for the domain duckduckgo.com


```
root@ns1:~ # doggo google.com A NS MX
NAME                       	        TYPE 	CLASS	TTL    	ADDRESS                    	        NAMESERVER 
google.com.                	        CNAME	IN   	        145s   	forcesafesearch.google.com.	1.1.1.1:53	
forcesafesearch.google.com.	A    	        IN   	        66288s 	216.239.38.120             	        1.1.1.1:53	
google.com.                	        CNAME	IN   	        145s   	forcesafesearch.google.com.	1.0.0.1:53	
forcesafesearch.google.com.	A    	        IN   	        66288s 	216.239.38.120             	        1.0.0.1:53	
google.com.                	        NS   	IN   	        177459s	ns2.google.com.            	        1.1.1.1:53	
google.com.                	        NS   	IN   	        177459s	ns3.google.com.            	        1.1.1.1:53	
google.com.                	        NS   	IN   	        177459s	ns4.google.com.            	        1.1.1.1:53	
google.com.                	        NS   	IN   	        177459s	ns1.google.com.            	        1.1.1.1:53	
google.com.                	        NS   	IN   	        177484s	ns4.google.com.            	        1.0.0.1:53	
google.com.                	        NS   	IN   	        177484s	ns2.google.com.            	        1.0.0.1:53	
google.com.                	        NS   	IN   	        177484s	ns3.google.com.            	        1.0.0.1:53	
google.com.                	        NS   	IN   	        177484s	ns1.google.com.            	        1.0.0.1:53	
google.com.                	        MX   	IN   	        300s   	10 smtp.google.com.        	1.1.1.1:53	
google.com.                	        MX   	IN   	        300s   	10 smtp.google.com.        	1.0.0.1:53
```

### g. Sending DOT Query on Port 853

```
root@ns1:~ # doggo google.com @tls://@1.1.1.1
NAME       	TYPE	CLASS	TTL 	ADDRESS       	NAMESERVER  
google.com.	A   	        IN   	        181s	142.251.12.138	1.1.1.1:853	
google.com.	A   	        IN   	        181s	142.251.12.139	1.1.1.1:853	
google.com.	A   	        IN   	        181s	142.251.12.102	1.1.1.1:853	
google.com.	A   	        IN   	        181s	142.251.12.101	1.1.1.1:853	
google.com.	A   	        IN           	181s	142.251.12.100	1.1.1.1:853	
google.com.	A   	        IN   	        181s	142.251.12.113	1.1.1.1:853
```

Although less popular than Dig, Doggo's presence has attracted serious attention from system administrators, who are considering replacing Dig. Its comprehensive features and unconventional design make it a worthy competitor to Dig.
