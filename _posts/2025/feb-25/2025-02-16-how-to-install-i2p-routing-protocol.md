---
title: How to Install i2p routing protocol on OpenBSD 7.6
date: "2025-02-16 13:17:10 +0100"
updated: "2025-02-16 13:17:10 +0100"
id: how-to-install-i2p-routing-protocol
lang: en
author: Iwan Setiawan
robots: index, follow
categories: openbsd
tags: Anonymous
background: https://www.opencode.net/unixbsdshell/balena-etcher-portable-173/-/raw/main/openbsd_i2p_dashboard.jpg
toc: true
comments: true
published: true
excerpt: If you want to install I2P on an OpenBSD system, you must install dependencies for I2P to run properly.
keywords: i2p, routing, protocol, openbsd, unix, daemon, tor, anonymous, freebsd
---

This application stands for Invisible Internet Project and is a network over the network (Internet). I2P is a fairly old project from 2003 and is considered stable and reliable. The idea of ​​I2P is to build a network of relays (people who run the i2p daemon) to create tunnels from clients to servers, but a single TCP or UDP session, between a client and a server can use many n-hop tunnels across relays.

Basically, when you start the I2P service, the program will get some information about the available relays and prepare many tunnels in advance that will be used to reach the destination when you connect.

**There are many benefits that you can enjoy by using I2P, including:**
- Your network is reliable because you don't have to worry about operator peering.
- Your network is secure because packets are encrypted, and you can even use regular encryption to reach your remote services (TLS or SSH).
- It provides privacy because no one can see where you are connecting to.
- It can prevent network routing tracking (if you are also relaying data to participate in i2p, the allocated bandwidth is used 100% of the time, and any traffic you send over I2P is indistinguishable from a standard relay!).
- It can only allow declared I2P nodes to access the server if you don't want anyone to connect to the ports you use.

It is possible to host a website on I2P (by exposing your web server port), called an eepsite and accessible using a SOCK proxy provided by your I2P daemon.

Because an I2P site is called an eepsite, which is similar to a Tor onion service. An eepsite is just a regular website with the important exception that it is only available to users connected to I2P. [An eepsite is similar to the more well-known Tor onion site](https://www.reddit.com/r/TOR/comments/vlnl17/tor_alternatives/).

In this article we will try to explain in more depth about the process of installing, configuring and using the I2P application on OpenBSD.

## 1. System Specifications Used:

In writing this article we used a computer with the following specifications:
- OS: OpenBSD 7.6 amd64
- Host: Acer Aspire M1800
- Uptime: 8 mins
- Packages: 42 (pkg_info)
- Shell: ksh v5.2.14 99/07/13.2
- Terminal: /dev/ttyp0
- CPU: Intel Core 2 Duo E8400 (2) @ 3.000GHz
- Memory: 35MiB / 1775MiB
- IP Address: 192.168.5.3
- Java version:  jdk-21.0.6.7.1v0

## 2. I2P Installation Process

The installation process is the most important part of all processes. In this process, there are many things you have to do, including:

### a. Install Dependencies

If you want to install I2P on an OpenBSD system, you must install dependencies for I2P to run properly. There are many dependencies that you must install to support I2P. Among all the dependencies, Java dependencies are very important.

```console
ns2# pkg_add jdk
```

Once you have installed the Java JDK, continue by installing java-tanukiwrapper which we will use to troubleshoot a number of common problems that occur in many Java applications installed on Unix systems such as OpenBSD.

```console
ns2# pkg_add java-tanukiwrapper
```
<br/>
### b. Install I2P

Then we continue by installing the main application that we will install, namely I2P. There are two ways to install I2P on OpenBSD, namely with the PKG and Ports packages. In this article we will install I2P with the PKG package.

```console
ns2# pkg_add i2p
```

## 3. I2P Configuration Process

In the configuration process we will set I2P to run perfectly on OpenBSD. The first step you have to do is run the following command to run I2P.

```console
ns2# /usr/local/bin/i2prouter start
```

Then you activate I2P, with the two commands below.

```console
ns2# rcctl enable i2p
ns2# rcctl restart i2p
```

After you run all the commands above, all I2P files will be saved in the `/var/i2p` directory.

### a. Change/edit Files in /var/i2p

Although you have installed I2P and activated I2P, I2P cannot be run yet. In order for I2P to run properly, there are several files that you must change the script for.

In the `/var/i2p` directory, find a file named "clients.config.bak". Then you change only part of the script from the `"/var/i2p/clients.config.bak"` file, as in the following example.

```yml
clientApp.0.args=7657 ::1,127.0.0.1 ./webapps/
change to
clientApp.0.args=7657 ::1,192.168.5.3 ./webapps/

clientApp.4.args=http://127.0.0.1:7657/
change to
clientApp.4.args=http://192.168.5.3:7657/
```
<br/>
### b. Change the files in /var/i2p/clients.config.d

Apart from the files mentioned above that you have to change, you also have to change several files in `"/var/i2p/clients.config.d"`. Look for the file `"/var/i2p/clients.config.d/00-net.i2p.router.web.RouterConsoleRunner-clients.config"`, then change the script as in the example below.

```yml
clientApp.0.args=7657 ::1,127.0.0.1 ./webapps/
change to
clientApp.0.args=7657 ::1,192.168.5.3 ./webapps/
```

After that, you also change the file `"/var/i2p/clients.config.d/04-net.i2p.apps.systray.UrlLauncher-clients.config"`.

```yml
clientApp.0.args=http://127.0.0.1:7657/
change to
clientApp.0.args=http://192.168.5.3:7657/
```

The next step is to open the file `"/usr/local/bin/i2prouter"`. In the file, find the script `"#ALLOW_ROOT=true"`. Remove the `"#"` sign in the script.

```yml
# If you'd like to run I2P as root (not recommended), uncomment the
# following line
ALLOW_ROOT=true
```

### c. Reboot I2P

The last step is you have to reboot your OpenBSD server, the goal is so that all configurations can be applied immediately in OpenBSD.

```console
ns2# reboot
```

## 4. How to Run I2P

Now we come to the final step, and this step is the step we have been waiting for. In this step we will run I2P. To run I2P you must use the Google Chrome, Yandex, Opera or other web browsers. In this article we will run I2P on Google Chrome, because it is commonly used by most people.

Before you open Google Chrome, run the following command.

```console
ns2# /usr/local/bin/i2prouter restart
```

After that, on the Google Chrome address bar menu, type the IP `"192.168.5.3:7657"`, then press the enter button. The results can be seen as shown in the image below.

![openbsd i2p dashboard](https://www.opencode.net/unixbsdshell/balena-etcher-portable-173/-/raw/main/openbsd_i2p_dashboard.jpg)

After appearing like the image above, you just have to follow the wizard menu displayed by I2P.

Congratulations...! You have successfully installed I2P on OpenBSD.

I2P is a great way to share services on a reliable and privacy-friendly network, it may not be fast but it won't stop you when you need it. Because it can easily bypass NAT or dynamic IP, I2P is perfect for remote systems that you need to access when you can use NAT or VPN.