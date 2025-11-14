---
title: Setting up a Mirror Site to convert PKG Packages on FreeBSD
date: "2025-09-13 09:11:29 +0100"
updated: "2025-09-13 09:11:29 +0100"
id: setup-mirror-site-convert-pkg-package-freebsd
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: UnixShell
background: /img/Logo.png
toc: true
comments: true
published: true
excerpt: PKG packages on FreeBSD contain pre-compiled software packages – called packages. This is the easiest way to install additional software under TwinCAT/BSD or update existing software
keywords: mirror, repository, package, pkg, ports, sistem, convert, site
---

Those who are already very familiar with Linux systems may find that FreeBSD's package management solution is actually more or less a perfect combination of the following two major Linux distribution package managers:

- *Arch Linux:* Pacman, which is compatible with pkg (also supports the KISS concept).
- *Gentoo Linux:* Portage, the equivalent of Ports (Portage itself is a clone of Ports).

To understand what you should be working with with PKG packages, you first need to understand some common FreeBSD terminology that may have different meanings if you're using other operating systems like Linux. PKG packages on FreeBSD contain pre-compiled collections of software – called packages. This is the easiest way to install additional software under TwinCAT/BSD or update existing software.

In this article, we'll discuss how to create a mirror repository for PKG packages. Using these mirrors can help speed up the process, as you can choose a FreeBSD mirror whose servers are close to your country.

## A. What is a PKG Package?

In every operating system, packages are often referred to as structured files, denoted by the .pkg or .mpkg file extension. PKG packages are typically used to carry installable software. Packages can contain application or software components in the form of scripts, receipts, and other metadata needed to install, update, or uninstall an application. However, there are several types of packages you might encounter on each operating system.

In general, a PKG package is a filename extension used for several file formats that contain software packages and other files to be installed on a device, on a specific operating system such as FreeBSD, OpenBSD, NetBSD, or DragonflyBSD.

The pkg utility provides an interface for manipulating packages, primarily listing, adding, removing, and updating packages. pkg-static is a statically linked variant of pkg that is typically only used for initial pkg installations. There are some differences in functionality. See pkg.conf(5) for details.

To use PKG packages on FreeBSD, you must first install the FreeBSD system. Afterward, you can use PKG to update, remove, or install applications. On FreeBSD, PKG packages are similar to the Ports system. However, PKG packages are faster for manipulating applications. This advantage makes PKG a top choice for application developers.

## B. Installation Sources in FreeBSD

Each operating system has its own way of creating installation sources, such as Linux and Ubuntu using apt packages. Similarly, FreeBSD has a different method than Linux. You can use several methods to install, remove, or update applications.

In FreeBSD, there are four types of installation sources:

- Paket pkg
- System ports
- portsnap, dan
- update.

## C. Create PKG Packages for FreeBSD Mirror Sites

Many FreeBSD users and network administrators manage multiple servers. They face various challenges and demands when it comes to updating their infrastructure with the latest security and software patches. FreeBSD Update Server can simplify this process by allowing them to test updates on multiple machines before deploying them across the network. This also means they can update their servers more quickly from their local network rather than over a slower internet connection.

The pkg package repository provides binary packages, whose pkg output paths are stored in `/var/cache/pkg/`. In FreeBSD, the pkg source is split into two configuration files: system-level and user-level. Before changing the PKG mirror path, add the following script to `/etc/make.conf`.

```yml
root@ns1:~ # ee /etc/make.conf
WITH_PKG=yes
```

Not all sources have both quarterly and latest. To get rolling package updates, change quarterly to latest. The difference between the two can be found in the FreeBSD manual. Please note that the `CURRENT` version is only the latest version.

Use the following command to change the system-level pkg source to use latest.

```yml
root@hostname1:~ # sed -i '' 's/quarterly/latest/g' /etc/pkg/FreeBSD.conf
```

If you want to replace http with https, please install `/usr/ports/security/ca_root_nss` first, then change http to https, and run the following command.

```yml
root@hostname1:~ # pkg update -f
```

Now we'll change the default FreeBSD mirror path. Before changing the FreeBSD PKG mirror, we recommend [reading our previous article](https://unixwinbsd.site/freebsd/update-upgrade-pkg-ports-package-binary-freebsd).


### a. Create user-level source directories and files

```console
 root@hostname1:~ # mkdir -p /usr/local/etc/pkg/repos
 root@hostname1:~ # chmod -R +x /usr/local/etc/pkg/
 root@hostname1:~ # ee /usr/local/etc/pkg/repos/163.conf
 
163: {
url: "http://mirrors.163.com/freebsd-pkg/${ABI}/quarterly",
}
FreeBSD: { enabled: no }
```

<br/>

```console
 root@hostname1:~ # ee /usr/local/etc/pkg/repos/ustc.conf
 
ustc: {
url: "http://mirrors.ustc.edu.cn/freebsd-pkg/${ABI}/quarterly",
}
FreeBSD: { enabled: no }
```

<br/>
```console
 root@hostname1:~ # ee /usr/local/etc/pkg/repos/nju.conf
 
nju: {
url: "http://mirrors.nju.edu.cn/freebsd-pkg/${ABI}/quarterly",
}
FreeBSD: { enabled: no }
```

<br/>
### b. Modify the make.conf file

To enable the local mirror to run directly, you must type the following script in the `/etc/make.conf` file.

```yml
root@hostname1:~ # ee /etc/make.conf
MASTER_SITE_OVERRIDE?=http://mirrors.nju.edu.cn/freebsd-ports/distfiles/${DIST_SUBDIR}/
MASTER_SITE_OVERRIDE?=http://mirrors.163.com/freebsd-ports/distfiles/${DIST_SUBDIR}/
MASTER_SITE_OVERRIDE?=http://mirrors.ustc.edu.cn/freebsd-ports/distfiles/${DIST_SUBDIR}/
```

### c. Download Ports
This repository is the source for downloading the ports themselves. This repository is identical to the previous portsnap repository.

```yml
root@hostname1:~ # cd /tmp
root@hostname1:/tmp # fetch https://mirrors.nju.edu.cn/freebsd-ports/ports.tar.gz
```

### d. Extract ports

After that, run the extract command. Place the extracted files in `/usr/ports`.

```yml
root@hostname1:/tmp # tar -zxvf ports.tar.gz -C /usr/ports
```

### e. Install the pkg Package

The next step is to install pkg. This will allow the FreeBSD mirror to immediately become the mirror we created earlier.

```yml
root@hostname1:~ # cd /usr/ports/ports-mgmt/pkg
root@hostname1:/usr/ports/ports-mgmt/pkg # make deinstall
root@hostname1:/usr/ports/ports-mgmt/pkg # make reinstall
```

### f. Delete the Default Mirror

Since we're going to replace the default mirror with the one we created above, you'll need to delete the default FreeBSD mirror.

```yml
root@hostname1:~ # rm -rf /var/db/pkg/repos/FreeBSD
```

The final step is to update pkg, with the following command.

```yml
root@hostname1:~ # pkg update && pkg upgrade
```

Be careful when changing mirrors. Replacing the default FreeBSD mirror with a local mirror is only useful when the download connection is very slow. Using a local mirror will speed up the download and installation process. This tutorial should only be used as a reference. In practice, simply use the default FreeBSD mirror.