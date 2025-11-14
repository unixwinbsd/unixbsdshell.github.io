---
title: How to Update the OpenBSD Kernel
date: "2025-10-20 21:15:21 +0100"
updated: "2025-10-20 21:15:21 +0100"
id: how-to-update-openbsd-kernel
lang: en
author: Iwan Setiawan
robots: index, follow
categories: openbsd
tags: UnixShell
background: /img/oct-25/oct-25-116.jpg
toc: true
comments: true
published: true
excerpt: Before we proceed with the kernel update process, the first and most important step is to check your OpenBSD system. This step should be done first, because at the end of the update process, we will know whether our OpenBSD kernel is updated or not.
keywords: kernel, system, openbsd, update, upgrade, generic, src, bsd, unix
---

The kernel contains many operating system features. Like external utilities, not all of them are necessary or appropriate on all machines. A GENERIC kernel attempts to be all things to all people. Building a custom kernel allows for the removal of unnecessary features, as well as features that might be useful to an intruder once they gain access. This article provides detailed step-by-step instructions for updating the OpenBSD kernel.

Of the various techniques discussed, building a custom kernel is one of the more time-consuming, relatively difficult to test properly, and therefore relatively high-risk, and certainly provides less benefit for the effort than most of the other techniques discussed.

The basic principle behind system hardening is to remove unnecessary functionality and transform a general-purpose system into a limited- or single-purpose machine. This principle applies to choosing which kernel options to use and which network services to run.

If security is a top priority, a custom kernel should be considered. However, if cost-effective security is the top priority, you'll get better results by disabling unnecessary services, using strong passwords, avoiding insecure protocols like telnet, and building a carefully crafted custom firewall.

<br/>
![How to Update the OpenBSD Kernel](/img/oct-25/oct-25-116.jpg) 
<br/>

## A. System Specifications
In creating this article, we used a computer that doesn't have high specifications. However, this doesn't detract from the content of this article. The computer specifications we used are as follows:

- OS: OpenBSD 7.6 amd64
- Host: Acer Aspire M1800
- Uptime: 3 mins
- Packages: 95 (pkg_info)
- Shell: ksh v5.2.14 99/07/13.2
- Terminal: /dev/ttyp0
- CPU: Intel Core 2 Duo E8400 (2) @ 3.0
- Memory: 208MiB / 1775MiB

## B. Checking the OpenBSD System

Before we proceed with the kernel update process, the first and most important step is to check your OpenBSD system. This step should be done first, because at the end of the update process, we will know whether our OpenBSD kernel is updated or not.

The method for this task is almost the same for all BSD-based operating systems, even Linux systems, in terms of the commands used. Run the command below to check your OpenBSD system.


```console
ns5# uname -a
OpenBSD ns5.kursor.my.id 7.6 GENERIC.MP#338 amd64
```
From the command above, it is very clear that the kernel we are using is called "GENERIC.MP", with the OpenBSD version 7.6.


## C. Download Source Code

When you first install OpenBSD, the source code for updating the kernel isn't included. Although the directory `"/usr/src"` exists, it's empty. Therefore, to begin the update process, you must download the entire contents of /usr/src.

OpenBSD uses the CVS version control system to manage its sources. The cvs program is used to pull a copy of the desired source code onto your local machine for compilation. An introduction to cvs and detailed instructions for retrieving the URL link are available on the anonymous CVS page. First, you must download the file or source code. After that, you run the update process to update the entire file and save it to your local computer.

There are many [repository links on CVS](https://www.openbsd.org/anoncvs.html), please choose one that you find most helpful and easier to use.

Below are some OpenBSD CVS URLs you can use:

```console
CVSROOT=anoncvs@anoncvs.au.openbsd.org:/cvs
reposync rsync://anoncvs.au.openbsd.org/cvs/

CVSROOT=anoncvs@anoncvs.comstyle.com:/cvs
reposync rsync://anoncvs.comstyle.com/cvs/

CVSROOT=anoncvs@obsdacvs.cs.toronto.edu:/cvs
reposync rsync://obsdacvs.cs.toronto.edu/obsdcvs/

CVSROOT=anoncvs@anoncvs.fr.openbsd.org:/cvs
reposync rsync://anoncvs.fr.openbsd.org/openbsd-cvs/

CVSROOT=anoncvs@mirror.osn.de:/cvs
reposync -p rsync://mirror.osn.de/openbsd-all/
```

### a. Download with CVS

To use cvs, you must avoid running it as root. On OpenBSD systems, by default, the `/usr/src` directory (files used for kernel updates) is in the wsrc group. Therefore, you only need to add the user who uses cvs. To do this, simply create a new user named unixwinbsd by running the `"adduser"` command.


```console
ns5# adduser
```

After you have successfully created a new user, continue with the following command:

```console
ns5# user mod -G wsrc unixwinbsd
```

As we have explained above, the `/src` directory on OpenBSD is still empty, so you have to download a lot of files to put into the `/usr/src` directory.

```console
ns5# cd /usr
ns5# cvs -qd anoncvs@anoncvs.au.openbsd.org:/cvs checkout -rOPENBSD_7_6 -P src
```

In the example script above, we use the URL `"anoncvs@anoncvs.au.openbsd.org:/cvs"` as the repository to download the `/src` file. Once the download is complete, update the downloaded file with the following command.

```console
ns5# cd /usr/src
ns5# cvs -q up -Pd -rOPENBSD_7_6
ns5# cvs -q anoncvs@anoncvs.au.openbsd.org:/cvs update -Pd -rOPENBSD_7_6
```

### b. Change The GENERIC File

Once you've completed all the steps above, let's move on to modifying the GENERIC file. This file contains the kernel configuration. You can add, delete, or delete all or part of the file's contents.

Based on the `"uname -a"` command above, the **GENERIC** file we're currently using is **"GENERIC.MP"** Copy the **GENERIC.MP** file, as shown below.

```console
ns5# cd /usr/src/sys/arch/amd64/conf
ns5# cp -R GENERIC.MP ROUTER.MP
```

### c. Change the ROUTER.MP file

In this article, we'll simply add a small script to the file. We'll add the **TIMEZONE and ART** scripts, as shown in the example below.

```
ns5# cd /usr/src/sys/arch/amd64/conf
ns5# nano ROUTER.MP
# $OpenBSD: GENERIC.MP,v 1.16 2021/02/09 14:06:19 patrick Exp $

include "arch/amd64/conf/GENERIC"

option	MULTIPROCESSOR
#option	MP_LOCKDEBUG
option	WITNESS
option TIMEZONE=300
option  ART

cpu*		at mainbus?
```

### d. Kernel Update Process

Then, we'll continue with the kernel update process. Follow the commands below to update the OpenBSD kernel.

```console
ns5# cd /usr/src/sys/arch/amd64/conf
ns5# config ROUTER.MP
ns5# cd ../compile/ROUTER.MP
ns5# make clean
ns5# make depend
ns5# make -j4
ns5# make install
```

## D. Download Source Code with Github

The method above shows how to download the `/src` file using a CVS repository. If you prefer, you can use an alternative repository like GitHub.

```console
ns5# cd /usr
ns5# git clone https://github.com/openbsd/src.git
```

The update process is the same as above. Simply follow steps 2, 3, and 4.

The most important part of the kernel update process is editing the `GENERIC.MP` file. During this process, you'll need to adjust which kernels are and are not required by your OpenBSD system.