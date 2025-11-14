---
title: How to Use the Netcat Command in FreeBSD
date: "2025-02-26 10:30:41 +0100"
updated: "2025-02-26 10:30:41 +0100"
id: how-to-use-netcat-command-freebsd-example
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: SysAdmin
background: /img/Logo.png
toc: true
comments: true
published: true
excerpt: Netcat is one of the most widely used Unix utilities and allows you to create TCP and UDP connections, receive data, and send it.
keywords: netcat, ls, command, shell, freebsd, example, kernel
---

Netcat is one of the most widely used Unix utilities that allows you to create TCP and UDP connections, receive data, and send it. Although useful and simple, many do not know how to use it and ignore it. In fact, Netcat features are very much needed by a system administrator.

By using this utility, you can perform several steps when performing penetration testing on your server. This utility is very useful when the attacked machine does not have any packages installed (or interesting ones) and your server has low capabilities (eg IoT/embedded devices), etc.

Netcat can help make your work easier, as below:
- Perform a port scan.
- Carrying out advanced ports.
- Collect service banners.
- Can Listen port (bind for reverse connection).
- Download and upload files.
- Output raw HTTP content.
- Have a small chat in one network.

In general, with the functions that Netcat has you can replace several Unix utilities, so this tool can be considered as a kind of combined utility for performing certain tasks on FreeBSD systems.

This article will show you how to simulate a client using a useful tool called Netcat and realize a direct connection using your own computer terminal.

Although Netcat has many features and can do many things, its main purpose and most used functions are:
- Create an initial socket to establish a connection from the server to the client.
- Once connected, Netcat will automatically create a second socket to send files from the server to the client and vice versa. (This is the really cool part.).



## 1. Install Netcat

The Netcat installation process is almost the same as other applications such as Socat, even the Netcat installation process on FreeBSD is very easy. Netcat does not have configuration files like Unbound, Apache Nginx and others.

To start the Netcat installation, you can use the port system on FreeBSD. Run the following command to start the installation process.
```
root@ns3:~ # cd /usr/ports/net/netcat
root@ns3:/usr/ports/net/netcat # make config
root@ns3:/usr/ports/net/netcat # make install clean
```
If you want to install Netcat with the PKG package, use the command below.
```
root@ns3:~ # pkg install netcat-1.10_3
```
Netcat has many variants written by different authors. The original version was called netcat (nc). It quickly gained recognition, but at some point the authors stopped developing it. But Netcat remained popular and many people used it, prompting other authors to rewrite Netcat. Lots of developers rewrite Netcat, sometimes Netcat is rewritten differently from the initial version, there are also those who rewrite it exactly the same as the original. The last version of Netcat released was in January 2007, the version was 1.10.


## 2. Practical Example of Netcat

Netcat commands are almost the same on all operating systems. Below we provide a basic example of how to use Netcat on FreeBSD.

### a. Check TCP/UDP ports
```
root@ns3:~ # nc -vn 192.168.5.2 22
Connection to 192.168.5.2 22 port [tcp/*] succeeded!
SSH-2.0-OpenSSH_9.3 FreeBSD-20230316

root@ns3:~ # nc -vn 192.168.5.2 80
Connection to 192.168.5.2 80 port [tcp/*] succeeded!

root@ns3:~ # nc -vn 192.168.5.2 53
nc: connect to 192.168.5.2 port 53 (tcp) failed: Connection refused
```
In the example script above, Netcat can connect to Apache and SSH servers, while with the Unbound server port 53, Netcat cannot connect.

### b. Scan TCP/UDP ports
```
root@ns3:~ # nc -vnz 192.168.5.2 22
Connection to 192.168.5.2 22 port [tcp/*] succeeded!
root@ns3:~ # nc -vnz 192.168.5.2 80
Connection to 192.168.5.2 80 port [tcp/*] succeeded!
root@ns3:~ # nc -vnz 192.168.5.2 443
nc: connect to 192.168.5.2 port 443 (tcp) failed: Connection refused
root@ns3:~ # nc -vnz 192.168.5.2 3306
nc: connect to 192.168.5.2 port 3306 (tcp) failed: Connection refused
root@ns3:~ # nc -vnz 127.0.0.1 3306
Connection to 127.0.0.1 3306 port [tcp/*] succeeded!
```

### c. Sending UDP packets

This can be useful when interacting with network devices.
```
root@ns3:~ # echo -n "FreeBSD The Power To Serve" | nc -u -w1 192.168.5.2 161
```

### d. Receives data on the UDP port and outputs the received data
```
root@ns3:~ # nc -u localhost 7777
root@ns3:~ # nc -u 192.168.5.2 7777
```

### e. Chat between nodes
```
root@ns3:~ # nc 192.168.5.3 9000
root@ns3:~ # nc 192.168.5.13 22
root@ns3:~ # nc 192.168.5.5 80
```
After executing the commands, all characters entered into the terminal window on any node will appear in the terminal window of the other node.

### f. Ping Port
```
root@ns3:~ # nc -zv google.com 443
Connection to google.com 443 port [tcp/https] succeeded!

root@ns3:~ # nc -zv unixwinbsd.site 443
Connection to unixwinbsd.site 443 port [tcp/https] succeeded!
```

### g. Copying files

One of the main frequently used features of Netcat is copying files. Even large amounts of data can be sent and individual partitions or entire hard drives can be cloned. In this example we will create a file "testfile.txt" on the client computer (A) and will copy it to the server computer (B).

Computer A (client), will send the file "testfile.txt" to computer B (server)
```
root@ns3:/tmp # nc 192.168.5.1 6790 < testfile.txt
```
Computer B (acts as the receiving server).
```
root@ns3:/tmp # nc -l -p 6790 > testfile.txt
```

### h. Cloning Hard Drives & Partitions

In this example we will use the Netcat command to clone a hard drive/partition over the network. In this example, I want to clone /dev/sda from server1 to server2. Of course the partition to be cloned must be unmounted on the target system, so if you want to clone the system partition, you must boot the target system (server2) from a rescue system or Live-CD such as Knoppix.

Computer A (client).
```
root@ns3:~ # dd if=/dev/sda | nc 192.168.5.1 1234
```
Computer B (server).
```
root@ns3:~ # nc -l -p 1234 | dd of=/dev/sda
```
After following the examples in this article, you know how to use the nc command in FreeBSD. Netcat is a powerful tool for network administrators and its functions can help make work easier.
