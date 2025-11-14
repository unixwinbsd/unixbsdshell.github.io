---
title: How to Update the OpenBSD Ports System
date: "2025-06-09 13:01:13 +0100"
updated: "2025-06-09 13:01:13 +0100"
id: update-ports-system-openbsd
lang: en
author: Iwan Setiawan
robots: index, follow
categories: openbsd
tags: SysAdmin
background: https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS-aV6Oap1gmc-LJQULVCYdMiJOMG94WHSp5A&s
toc: true
comments: true
published: true
excerpt: On the OpenBSD operating system, there is a lot of software that you can install. However, due to space constraints and to speed up the installation process, most of the software is provided through the OpenBSD port collection. The port collection includes software packages that you can download, compile, and install.
keywords: ports, system, package, pkg, openbsd, update, upgrade, cvs, mirror
---

The port system in OpenBSD is not exactly the same as the port system in FreeBSD. This is because developers only include tested and stable applications in the port, in other words there are no development branches etc. Untested and unstable applications are rarely included in the OpenBSD repository. Although the use of applications in OpenBSD ports is stable, we recommend that you use pkg packages.

On the OpenBSD operating system, there is a lot of software that you can install. However, due to space constraints and to speed up the installation process, most of the software is provided through the OpenBSD port collection. The port collection includes software packages that you can download, compile, and install.

The first step to using the ports system on an OpenBSD server is to have a ports.tar.gz file. This file contains a collection of software that you can install. Usually the ports.tar.gz file is found on the OpenBSD installation CD. If you don't have it, you can download it from the OpenBSD repository or Github. Please note that using the ports system is a bit more difficult than using pkg packages. The ports system is intended for advanced users.

This article will show you how to configure an OpenBSD 7.5 system to fetch the latest versions from the ports repository, and how to install software from the ports collection.



## 1. How to Install Ports
On OpenBSD systems, ports are not created automatically when you install OpenBSD. You must download the system ports and store them in the `/usr` directory. Here we provide a guide to downloading ports on OpenBSD 7.5.

```console
foo# cd /usr
foo# ftp https://cdn.openbsd.org/pub/OpenBSD/$(uname -r)/{ports.tar.gz,SHA256.sig}
foo# signify -Cp /etc/signify/openbsd-$(uname -r | cut -c 1,3)-base.pub -x SHA256.sig ports.tar.gz
```
The above command is used to download the ports.tar.gz file. Once the download is complete, run the extract command and save the extracted file in the `/usr/ports` directory.

```console
foo# cd /usr
foo# tar xzf /tmp/ports.tar.gz
foo# rm ports.tar.gz SHA256.sig
```
Once you have successfully extracted the `ports.tar.gz` file, proceed to setting up the `/etc/mk.conff` file.

## 2. How to Configure OpenBSD Ports
In this section, we will do some global settings to build the port. This prevents multiple "make" statements from appearing when you use the port. The port infrastructure can be run as a normal user, but we recommend that you use the superuser as root. Unless, you have finished installing the software, and start configuring the software.

It is possible to use a read-only port tree by separating the directories written during port creation:
- The port working directory. This is controlled by the WRKOBJDIR variable, which specifies the directory that will contain the working directory.
- The directory that contains the distribution files. This is controlled by the DISTDIR variable.
- The directory that contains the newly created binary package. This is controlled by the PACKAGE_REPOSITORY variable.

To use all these variables, you can add the script below to the `/etc/mk.conf` file.

```console
foo# touch /etc/mk.conf
foo# nano /etc/mk.conf
WRKOBJDIR=/usr/obj/ports
DISTDIR=/usr/distfiles
PACKAGE_REPOSITORY=/usr/packages
#FETCH_PACKAGES=Yes
PLIST_BD=/usr/obj/ports/plist
BULK_COOKIES_DIR=/usr/obj/ports/bulk_cookies
UPDATE_COOKIES_DIR=/usr/obj/ports/update_cookies
```

## 3. Update OpenBSD Ports
To update ports to a stable version, use the CVS command. Choose the mirror closest to your city. We will give an example of how to update ports with CVS.

Add the following script to the `/root/.profile` file.

```console
export CVSROOT=anoncvs.usa.openbsd.org:/cvs
```
After that, in the `/etc/installurl` file, you type the following script.

```console
anoncvs.usa.openbsd.org
```
Then proceed with updating OpenBSD Ports.

```console
foo# cd /usr/ports
foo# cvs -d anoncvs@anoncvs.usa.openbsd.org:/cvs -q up -rOPENBSD_`uname -r | sed 's/\./_/'` -Pd
```

Here are some mirrors you can use:
- anoncvs@anoncvs.usa.openbsd.org:/cvs
- anoncvs@anoncvs5.usa.openbsd.org:/cvs
- anoncvs@mirror.arc.nasa.gov:/cvs
- anoncvs@anoncvs6.usa.openbsd.org:/cvs
- anoncvs@anoncvs1.ca.openbsd.org:/cvs
- anoncvs@valkyrie.secureops.com:/cvs
- anoncvs@anoncvs.uk.openbsd.org:/cvs
- anoncvs@anoncvs.tw.openbsd.org:/cvs

To complete the update process, run the command below.

```console
foo# cvs -q up -Pd -rOPENBSD_7_5
```

## 4. Search for Software/Applications by Ports
As explained above, the ports system can be run by a regular user. If you wish, change ownership of the ports directory to your local user name and group, so that the ports system can create the underlying working directory as a regular user. Note, however, that ports can be built as a regular user, but must be installed by the root user or with doas.

To run doas, you do not need to install `doas`, just enable it. Doas can be enabled with the doas.conf file. Create a `/etc/doas.conf` file and add the script below to the `/etc/doas.conf` file. Follow the commands below to create and add the script to the `/etc/doas.conf` file.

```console
foo# touch /etc/doas.conf
foo# nano /etc/doas.conf
#permit persist setenv { PKG_CACHE PKG_PATH } aja cmd pkg_add
permit setenv { -ENV PS1=$DOAS_PS1 SSH_AUTH_SOCK } :wheel
permit nopass tedu as root cmd /usr/sbin/procmap
permit nopass keepenv setenv { PATH } root as root

permit nopass setenv { \
    FTPMODE PKG_CACHE PKG_PATH SM_PATH SSH_AUTH_SOCK \
    DESTDIR DISTDIR FETCH_CMD FLAVOR GROUP MAKE MAKECONF \
    MULTI_PACKAGES NOMAN OKAY_FILES OWNER PKG_DBDIR \
    PKG_DESTDIR PKG_TMPDIR PORTSDIR RELEASEDIR SHARED_ONLY \
    SUBPACKAGE WRKOBJDIR SUDO_PORT_V1 } :wsrc

# Allow wheel by default
#permit keepenv :wheel
```
After that, run the command below.

```console
foo# cd /usr/ports
foo# doas pkg_add portslist
quirks-7.14 signed on 2024-03-17T12:22:05Z
portslist-7.52: ok
```
Once you have dos enabled and have the port tree and port list packages on your OpenBSD system. Running the software search command becomes very easy. Simply use `make search key="searchkey"` as shown in this example.

```console
foo# make search key=apache
```
The above command is used to search for apache software. Here we provide some examples of how to search for software on ports.

```console
foo# make search key=nginx
foo# make search key=isc-bind
foo# make search key=freeradius
```

## 5. How to Install and Remove Software with Ports
This is probably the last part of our article. In this section we will learn how to install and remove software using OpenBSD ports. Below we provide an example of how to install **Nginx** software.

```console
foo# cd /usr/ports/www/nginx
foo# make build
foo# make install
foo# make clean
```
Below we will provide another example of how to install Bash.

```console
foo# cd /usr/ports/shells/bash
foo# make build
foo# make install
foo# make clean
```
It would be incomplete if we did not explain how to remove software in OpenBSD. We will explain how to remove software in OpenBSD. Follow the command guide below to `remove` software in OpenBSD.

```console
foo# cd /usr/ports/www/nginx
foo# make uninstall
foo# make clean=packages
```
Below, we also show how to `remove Bash`.

```console
foo# cd /usr/ports/shells/bash
foo# make uninstall
foo# make clean=packages
```
In this article you have learned how to use OpenBSD ports. There are many ways to manage and use OpenBSD ports. We recommend that you read other articles to deepen your understanding of the port system used in OpenBSD.