---
title: How to Install and Use Socat Command on Freebsd
date: "2025-07-09 17:32:21 +0100"
updated: "2025-07-09 17:32:21 +0100"
id: install-and-use-socat-command-freebsd
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: SysAdmin
background: https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/img/diagram-socat-freebsd.jpg
toc: true
comments: true
published: true
excerpt: Transferring data between computers on a public or private network can be a challenge, especially when you need to transfer data both ways. The socat command in FreeBSD provides a powerful and flexible solution for bidirectional data transfer between network connections
keywords: socat, command, install, use, freebsd, openbsd, transfer, data, networking, host
---

Transferring data between computers on a public or private network can be a challenge, especially when you need to transfer data both ways. The socat command in FreeBSD provides a powerful and flexible solution for bidirectional data transfer between network connections.

In this article, we will learn how to use the socat command and provide practical examples to help you understand the use of the socat command. The goal is to establish a connection between two data sources, where each data source can be a file, Unix socket, UDP, TCP, or standard input.

On FreeBSD systems socat is not installed automatically like SSH or NTP. To be able to use Socat you have to install it first so you can experience the benefits of the Socat command.

<br/>
<img alt="diagram socat freebsd" width="99%" class="lazyload" style="display: block; margin: auto;" src="{{ 'https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/img/diagram-socat-freebsd.jpg' | relative_url }}">
<br/>

## 1. Install Socat

On FreeBSD, Socat is installed in various ways, but most people use the PKG package or Ports system. So that all Socat libraries and dependencies can be built perfectly, we use the ports system to install Socat. Use the following command to start it.

```
root@ns3:~ # cd /usr/ports/net/socat
root@ns3:/usr/ports/net/socat # make config
root@ns3:/usr/ports/net/socat # make install clean
```

To complete the socat command, you also install the Curl and Bash applications, because when used, these applications are always used with socat.

```
root@ns3:/usr/ports/net/socat # pkg install curl bash
```

Same as other applications, Socat also has Start up rc.d. which can make Socat run automatically. But people rarely use the rc.d script, usually manual commands are used to run socat. But there's nothing wrong, we will discuss Start Up rc.d socat.

So that socat can run automatically on FreeBSD systems, enter the script below in the **"/etc/rc.conf"** file.

```
socat_enable="YES"
socat_daemonuser="root"
socat_flags="/usr/local/etc/socat-instances.conf"
```

The socat configuration file is named `"/usr/local/etc/socat-instances.conf"`, edit the file as needed. To run socat use the following command.

```
root@ns3:~ # service socat restart
```


## 2. Socat Binary Files

After the installation process is complete, Socat produces three bin files, namely:
- /usr/local/bin/filan
- /usr/local/bin/procan
- /usr/local/bin/socat

`Socat` is a command line based relay utility that establishes two bidirectional byte streams and is used for bidirectional data transfer between two independent data channels. Each of these data channels can be a file, a pipe, a device (terminal or modem etc.), a socket (UNIX, IP4, IP6 - raw, UDP, TCP), a file descriptor (stdin etc.), a program, or an arbitrary combination -the authority of these two.

`Filan` is a utility that can output information about its active file descriptor to stdout. Filan is used for debugging socat, but it may be useful for other purposes as well. Use the -h option to find more info.

`Procan` is a utility that can output information about process parameters to stdout. Procan is often used to better understand some UNIX process properties and for socat debugging, but it may be useful for other purposes as well.


## 3. How to Use Socat

Socat's syntax is quite simple and easy to write.

```
socat [options] <address> <address>
```

For socat to work, you must provide a source and destination address. The syntax for these addresses is:

```
protocol:ip:port
```


### a. Connects socat to TCP port 80 on a local or remote network

```
root@ns3:~ # socat - TCP4:www.unixwinbsd.site:80
root@ns3:~ # socat - TCP4:192.168.5.2:80
```

In the example above, socat transfers data between STDIO (-) and TCP4 connections to port 80 on the host named www.unixwinbsd.site and local host 192.168.5.2.


### b. Using the socat command as a TCP port forwarder

For a single connection

```
root@ns3:~ # socat TCP4-LISTEN:80 TCP4:192.168.5.2:80
```

For multiple connections, use the fork option

```
root@ns3:~ # socat TCP4-LISTEN:81,fork,reuseaddr TCP4:TCP4:192.168.5.2:80
root@ns3:~ # socat TCP-LISTEN:80,fork TCP:64.233.170.121:80
```

In the example above, socat would listen on port 81, accept the connection, and forward the connection to port 80 on the remote host. In the second script, all TCP4 connections to port 80 will be redirected to 202.54.1.5. You can end the connection by pressing [CTRL+C].

```
root@ns3:~ # socat TCP-LISTEN:3306,reuseaddr,fork UNIX-CONNECT:/tmp/mysql.sock
```

In the example script above, socat will listen on port 3306, accept the connection, and forward the connection to the Unix socket on the remote host.


### c. Implementing socat as a simple network based message collector

```
root@ns3:~ # socat -u TCP4-LISTEN:3334,reuseaddr,fork OPEN:/tmp/test.log,creat,append
```

In the example script above, when a client connects to port 3334, a new child process will be generated, and all data sent by the client will be added to the /tmp/test.log file. If the file does not exist, socat will create it. The reuseaddr option allows the server process to be restarted immediately.


### d. The socat command will send a broadcast to the local network

```
root@ns3:~ # socat - UDP4-DATAGRAM:224.255.0.1:6666,bind=:6666,ip-add-membership=224.255.0.1:nfe0
```

In the example script above, socat will transfer data from stdin to the specified multicast address using UDP via port 6666 for local and remote connections. This command also tells the nfeo interface to receive multicast packets for the specified group. nfe0 is your computer's ethernet card.

Socat is a great utility for connecting to remote servers. With the socat command you can create remote connections easily. In this example we will use socat for remote MySQL connections. We will try to connect a web server to a remote MySQL server by connecting via a local socket.

On your remote MySQL server, type the following command.

```
root@ns3:~ # socat TCP-LISTEN:3307,reuseaddr,fork UNIX-CONNECT:/tmp/mysql.sock &
```

The above command will start socat and configure it to listen and use port 3307. After that, on the web server on your computer, type the following command.

```
root@ns3:~ # socat UNIX-LISTEN:/tmp/mysql.sock,fork,reuseaddr,unlink-early,user=mysql,group=mysql,mode=777 TCP:192.168.5.2:3307 &
```

The above command will connect the local IP 192.168.5.2 to the remote server using port 3307. All the communication is done on the Unix socket `/tmp/mysql.sock`, and this makes it look like a local server.

The basic socat command in FreeBSD provides a powerful and flexible solution for bidirectional data transfer between networks. Using the socat command, you can create two endpoints to perform data transfer and connect them. Socat makes the job of data transfer easier over different network connections.