---
title: OpenBSD How to Use PKG Packages and Update PKG Package Management
date: "2025-10-19 09:10:28 +0100"
updated: "2025-10-19 09:10:28 +0100"
id: openbsd-use-pkg-packages-update-pkg-management
lang: en
author: Iwan Setiawan
robots: index, follow
categories: openbsd
tags: UnixShell
background: /img/oct-25/oct-25-114.jpg
toc: true
comments: true
published: true
excerpt: PKG packages use mirrors to connect to OpenBSD repositories. Selecting a repository mirror is the first step before running a PKG package. There are many mirrors available in OpenBSD. You can see a complete list of them in the OpenBSD Mirrors section.
keywords: openbsd, use, pkg, packages, update, upgrade, package, management, command, shell
---

As with other operating systems, there are many applications you can use on an OpenBSD system. All of these applications are packaged in PKG packages, making them easy to install and manage. The purpose of PKG packages is to simplify and track installed software, allowing you to easily update or remove it.

Each PKG package includes a single piece of software that has been packaged and compiled for the OpenBSD version and architecture. In this article, we'll discuss using PKG packages first, as they are generally easier and quicker to use than ports. Once you've mastered these packages, we'll move on to discussing ports. Many of the tools that work with PKG packages also work with ports.

On OpenBSD, [every system and port PKG package](https://unix.stackexchange.com/questions/513710/how-can-i-install-a-package-on-openbsd) must be kept up-to-date with its packages. Most OpenBSD users consistently use pkg_add for package installation and pkg_delete for package removal. The pkg utility can also be used to update packages. If you're using OpenBSD, we recommend using PKG packages over ports for application installation. This is because the OpenBSD development team focuses more on creating and maintaining PKG packages.

The following are frequently used PKG package commands, because these commands can help you make it easier to manage each package you use.

- **pkg_add** - This command is often used to install and upgrade packages.
- **pkg_check** - This command is used to check the consistency of installed packages.
- **pkg_delete** - This command is used to remove installed packages.
- **pkg_info** - Commands for information about packages

<br/>
![how to update openbsd pkg package](/img/oct-25/oct-25-114.jpg)
<br/>

## 1. PKG Package Repository Mirror

PKG packages use mirrors to connect to OpenBSD repositories. Selecting a repository mirror is the first step before running a PKG package. There are many mirrors available in OpenBSD. You can see a complete list of them in the ["OpenBSD Mirrors"](https://www.openbsd.org/ftp.html#ftp) section.

You must include the mirror repository link address in the `/etc/installurl` and `/root/.profile` files. We'll provide an example of using the mirror link `https://cdn.openbsd.org/pub/OpenBSD`. See the example below.

```console
foo# nano /etc/installurl
https://cdn.openbsd.org/pub/OpenBSD
```

Additionally, you should also type the mirror link in the `/root/.profile` file, as in the example below.

```console
foo# nano /root/.profile
# $OpenBSD: dot.profile,v 1.10 2023/11/16 16:03:51 millert Exp $
# sh/ksh initialization

PATH=/sbin:/usr/sbin:/bin:/usr/bin:/usr/X11R6/bin:/usr/local/sbin:/usr/local/bin
export PKG_PATH=https://cdn.openbsd.org/pub/OpenBSD/$(uname -r)/packages/$(arch -s)/
export PATH
: ${HOME='/root'}
export HOME
umask 022

case "$-" in
*i*)    # interactive shell
	if [ -x /usr/bin/tset ]; then
		eval `/usr/bin/tset -IsQ '-munknown:?vt220' $TERM`
	fi
	;;
esac
```

## 2. How to Update PKG Packages

Like most computer users, we want to use the latest versions of the applications we use. We're the same; we always want to try out new versions of the applications we use. To achieve this, you need to update the pkg packages.

The pkg package update command is used to [update the local copy of the repository catalog](https://www.reddit.com/r/openbsd/comments/1echkjw/about_packages_and_updates/)  from the remote package repository database. Catalog updates are typically downloaded only if the primary copy in the remote package repository is more recent than the local copy. Before starting the installation process, make sure you update your package repository catalog to the latest version. This will affect the latest version of the application you are about to install.

On OpenBSD, to update a pkg package use the pkg_add command. Use the parameters below to ensure the latest version from the OpenBSD repositories.

- **-u:** To perform an upgrade
- **-i:** For interactive, and
- **-v:** For verbose output.

Run the command below to start updating the OpenBSD PKG packages.

```console
foo# pkg_add -uvi
```

## 3. How to Install PKG Packages

OpenBSD includes a diverse collection of system tools as part of its base system. [The pkg_add command](https://news.ycombinator.com/item?id=9361147)  can be used to install third-party software. This command installs binaries previously created by OpenBSD developers. You can use `pkg_add` to install software from local media or from a network.

We'll provide examples of how to install several applications with OpenBSD. Consider the example below of installing Nginx.


```console
foo# pkg_add nginx
```

To make the application installation process clearer in OpenBSD, we will provide some application installation examples.

```console
foo# pkg_add isc-bind-9.18.25v3
```

<br/>
```console
foo# pkg_add unzip
```

## 4. How to Find PKG Packages

Next, we'll learn how to search for applications available on OpenBSD. This search process is essential if we don't know the application type and version. Use the pkg_info command to search for applications. Below, we provide several examples of running the pkg_info command.


**Looking for unzip software**

```console
foo# pkg_info -Q unzip
lunzip-1.14
unzip-6.0p17
unzip-6.0p17-iconv
```

<br/>

**Looking for BIND software**

```console
foo# pkg_info -Q bind
bindgraph-0.2p0
cbindgen-0.26.0
debug-isc-bind-9.18.24v3
debug-isc-bind-9.18.24v3-geoip
debug-nsgenbind-0.8
isc-bind-9.18.24v3
isc-bind-9.18.24v3-geoip
keybinder3-0.3.0p9
libbind-6.0p7v0
libindi-1.9.8p0
nsgenbind-0.8
py3-pybind11-2.11.1
xapian-bindings-perl-1.4.24
xapian-bindings-python-1.4.24p0
xbindkeys-1.8.7
```

Another way to search for software in the OpenBSD repositories is with the `"pkglocate"` command. Before you can use the `"pkglocate"` command, you must first install pkglocatedb. Run the command below to install `pkglocatedb`.

```console
foo# pkg_add pkglocatedb
```

Run the command below to search for apache and Nginx software.

```console
foo# pkglocate apache
foo# pkglocate nginx
```

## 5. How to Remove Software/Applications with PKG

Once you know how to update, install, and search for PKG packages, your tutorial won't be complete without learning how to remove them. The delete command is very useful if you no longer need the software you're using. The `pkg_delete` command is used to remove software you've installed on OpenBSD. Below, we provide several examples of how to use `pkg_delete` to remove software.

```console
foo# pkg_delete nginx
nginx-1.24.0p0: ok
Read shared items: ok
```

<br/>

```console
foo# pkg_delete isc-bind
foo# pkg_delete unzip
```

## 6. Check Installed Packages

The `pkg_check` command is used to verify as much information as possible about installed packages. This command is rarely used, except in cases of serious system failures while using the `pkg_add` and `pkg_delete` commands. To clarify, here's an example of how to use the `pkg_check` command.

```console
foo# pkg_check isc-bind-9.18.24v3
Packing-list sanity: ok
Direct dependencies: ok
Reverse dependencies: ok
Files from packages: ok
```

<br/>

```console
foo# pkg_check nginx-1.24.0p0
Packing-list sanity: ok
Direct dependencies: ok
Reverse dependencies: ok
Files from packages: ok
```

All of the commands above are basic OpenBSD commands and are essential for you to understand, as they are frequently used and even integral to the OpenBSD system. If you don't master them all, you'll undoubtedly encounter problems using the OpenBSD system.