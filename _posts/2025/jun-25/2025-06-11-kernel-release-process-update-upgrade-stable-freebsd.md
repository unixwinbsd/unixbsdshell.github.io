---
title: FreeBSD Kernel Release Update and Upgrade Process to FreeBSD Stable
date: "2025-06-11 13:01:13 +0100"
updated: "2025-06-11 13:01:13 +0100"
id: kernel-release-process-update-upgrade-stable-freebsd
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: UnixShell
background: /img/Logo.png
toc: true
comments: true
published: true
excerpt: FreeBSD-CURRENT contains work in progress, experimental modifications, and transition mechanisms that may or may not be included in the next official version. Although many FreeBSD engineers compile the FreeBSD-CURRENT source code regularly, there are brief instances when the source code cannot be built
keywords: kernel, ports, system, package, pkg, openbsd, update, upgrade, cvs, mirror
---

FreeBSD-CURRENT is the "cutting edge" of FreeBSD, and users should have a high level of technical expertise. Less technical users who want to follow the development branch should use FreeBSD-STABLE.


FreeBSD-CURRENT contains work in progress, experimental modifications, and transition mechanisms that may or may not be included in the next official version. Although many FreeBSD engineers compile the FreeBSD-CURRENT source code regularly, there are brief instances when the source code cannot be built. These issues are addressed as quickly as possible, however, whether FreeBSD-CURRENT provides a disaster or new features depends on when the source code is synchronized.


In this article we will learn how to update the FreeBSD kernel from Release/Current to FreeBSD Stable. Before upgrading, first check the system FreeBSD version.


```console
root@ns1:~ # uname -a
FreeBSD ns1 13.2-RELEASE FreeBSD 13.2-RELEASE releng/13.2-n254617-525ecfdad597 GENERIC amd64
```

Please note, the contents of this article can also be applied to FreeBSD 14.x-RELEASE The author has tried it on FreeBSD 14.1-RELEASE and it works. However, in writing this article, we are using FreeBSD 13.2 RELEASE.

In the example written in this article, I will update the RELEASE version to the FreeBSD Stable version. In older versions of FreeBSD, subversion is used to update the FreeBSD kernel. Gradually, along with the development and number of FreeBSD users, they switched to git to update the kernel.

Before starting the FreeBSD kernel update, delete all the files in the `/usr/src` directory. This file contains all the FreeBSD system files.

```console
root@ns1:~ # rm -rf /usr/src/*
root@ns1:~ # rm -rf /usr/src/.*
```

To start updating the FreeBSD kernel with git, you need to clone the FreeBSD Stable files. Follow these steps to download the files with Git.

```console
root@ns1:~ # pkg install git
root@ns1:~ # git clone -b stable/13 --depth 1 https://git.FreeBSD.org/src.git /usr/src
```

The above script will install the git application and the second script will download the files used to update the kernel. The files are stored in the `/usr/src` folder. Once downloaded, continue with the script below.


```console
root@ns1:~ # cd /usr/src
root@ns1:/usr/src # git pull && git branch --all
```


## 1. Edit the GENERIC File
The main file for compiling the kernel is called **GENERIC** which is located in the `/usr/src/sys` folder, which can also be accessed via `/sys`. There are a number of subdirectories here that represent various parts of the kernel, but the most important, for our purposes, is the conf folder, the folder for editing custom kernel configurations, and applications.

In this folder, we must specify what machine we are using, in this article, the FreeBSD system is built on an AMD64 computer, so the folder we will use is `/usr/src/sys/amd64/conf`. Note the word amd64 before the conf folder. If your computer uses the i386 architecture, use the `/usr/src/sys/i386/conf` folder. In this folder, the **GENERIC** file is located.

You can edit the **GENERIC** file according to your FreeBSD computer machine. The **GENERIC** file contains the computer hardware kernel such as the processor, sound card, land card, motherboard, not only that, the application program kernel is also stored in the GENERIC file. In this example we will edit the **GENERIC** file to create a Firewall Router (Gateway).

Since Router Firewall is closely related to packet filter firewall and ipfw firewall applications, we must compile the firewall kernel in the **GENERIC** file. Add the following script to the `/usr/src/sys/amd64/conf/GENERIC` file to compile the firewall kernel.

 
```
device		      bpf
options         IPFIREWALL
options         IPDIVERT
options         IPFIREWALL_VERBOSE
options         IPFIREWALL_VERBOSE_LIMIT=17
options         IPFIREWALL_NAT
options         LIBALIAS
options         ROUTETABLES=7
options         DUMMYNET
options         HZ="1000"
options         IPFIREWALL_DEFAULT_TO_ACCEPT
options         IPSTEALTH
options         DEVICE_POLLING
options         ROUTETABLES=2
options         MROUTING
device          coretemp
options         IPFIREWALL_NAT64
options         IPFIREWALL_NPTV6
options         IPFIREWALL_PMOD

options         ALTQ
options         ALTQ_CBQ
options         ALTQ_RED
options         ALTQ_RIO
options         ALTQ_HFSC
options         ALTQ_PRIQ

device		    pf
device		    pflog
device		    pfsync
```

Next, backup the GENERIC kernel, in this case we will copy the GENERIC file to a file named "ROUTERSIUDIN".
 
```console
root@ns1:~ # cd /usr/src/sys/i386/conf
root@ns1:/usr/src/sys/i386/conf # cp GENERIC ROUTERSIUDIN
```


## 2. Compile the GENERIC File
After the **GENERIC** file is edited and backed up, the FreeBSD kernel named "ROUTERSIUDIN" is now ready to be compiled. Before compiling the ROUTERSIUDIN kernel, write an iden script like the following.


```
ident      GENERIC
```

Replace with


```
ident    ROUTERSIUDIN
```

After that, compile the `ROUTERSIUDIN` kernel. Use the following script to compile the `ROUTERSIUDIN` kernel.

```console
root@ns1:~ # cd /usr/src
root@ns1:/usr/src # make buildworld KERNCONF=ROUTERSIUDIN
```

The script above will build the kernel of the Udin routers world, after building the world continue with.

 
```console
root@ns1:/usr/src # make buildkernel KERNCONF=ROUTERSIUDIN
root@ns1:/usr/src # make installkernel KERNCONF=ROUTERSIUDIN
root@ns1:/usr/src # make installworld KERNCONF=ROUTERSIUDIN
root@ns1:/usr/src # reboot
```

After the restart/reboot process is complete, check the FreeBSD version with the script below.

```console
root@ns1:~ # uname -a
```

The kernel compilation time is quite long, a computer with an Intel Core(TM)2 Duo E8400 @ 3.00GHz processor takes about 20 hours. If you compile the kernel at noon tomorrow morning, the kernel will be finished. So the length of the kernel compilation process depends on the computer's processor.

Compiling the source code for a FreeBSD kernel update has several advantages over a binary update. The code can be built using those options that allow us to use specific hardware. Basic system elements can be built with non-default settings or omitted if not needed or desired.