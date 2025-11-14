---
title: How to Configure Linux Binary Compatibility on FreeBSD
date: "2025-09-26 07:15:21 +0100"
updated: "2025-09-26 07:15:21 +0100"
id: configure-linux-binary-compatibility-on-freebsd
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: UnixShell
background: /img/Logo.png
toc: true
comments: true
published: true
excerpt: The FreeBSD system provides Linux binary compatibility. The presence of Linux binaries makes it easier for users to install and run unmodified Linux binaries. It is available for x86 (32- and 64-bit) and AArch64 architectures. Some Linux-specific operating system features are not yet fully supported
keywords: linux, unix, freebsd, binary, compatibility, configuration, linuxulator, virtual, machine, emulator
---

Linux binary compatibility, often referred to as Linuxulator, is a mechanism for running unmodified Linux binaries under the FreeBSD system. Linuxulator does not involve a virtual machine or emulator. Instead, Linuxulator provides binaries with a kernel interface identical to that provided by the native Linux kernel. Technically, it is similar to how 32-bit FreeBSD binaries run on a 64-bit FreeBSD kernel.

The FreeBSD system provides Linux binary compatibility. The presence of Linux binaries makes it easier for users to install and run unmodified Linux binaries. It is available for x86 (32- and 64-bit) and AArch64 architectures. Some Linux-specific operating system features are not yet fully supported. This is because most of them involve functionality that is hardware-specific or related to system management, such as cgroups or namespaces.

Linux binaries running on FreeBSD began in 1995. These applications use the Linux executable format and provide a dedicated Linux system call table. Early Linux binaries were used to play the video game Doom. Gradually, many Linux applications and libraries were packaged and made available through the FreeBSD Ports Collection. However, because FreeBSD tools do not understand Linux package dependencies, this process is time-consuming and requires manual configuration.

![How to Configure Linux Binary Compatibility on FreeBSD](https://raw.githubusercontent.com/unixwinbsd/FreeBSD_NodeJS_WebApp/refs/heads/main/How%20to%20Configure%20Linux%20Binary%20Compatibility%20on%20FreeBSD.jpg)


This article will explain and demonstrate how to configure and install Linux binaries on FreeBSD. This article was written to accomplish this using a computer with FreeBSD 13.2 installed.

## 1. Linux Binary Installation Process

The Linux binary installation process on FreeBSD requires the use of the provided system ports. Follow these steps to install a Linux binary package on FreeBSD.

```
root@ns1:~ # cd /usr/ports/emulators/linux_base-c7
root@ns1:/usr/ports/emulators/linux_base-c7 # make install clean
```


Once the installation process is complete, a configuration prompt will appear from the program developer. This prompt will look something like the one below.

```
====> Compressing man pages (compress-man)
===>  Installing for linux_base-c7-7.9.2009_1
===>  Checking if linux_base-c7 is already installed
===>   Registering installation for linux_base-c7-7.9.2009_1
Installing linux_base-c7-7.9.2009_1...
Some programs need linprocfs mounted on /compat/linux/proc.  Add the
following line to /etc/fstab:

linprocfs   /compat/linux/proc	linprocfs	rw	0	0

Then run "mount /compat/linux/proc".

Some programs need linsysfs mounted on /compat/linux/sys.  Add the
following line to /etc/fstab:

linsysfs    /compat/linux/sys	linsysfs	rw	0	0

Then run "mount /compat/linux/sys".

Some programs need tmpfs mounted on /compat/linux/dev/shm.  Add the
following line to /etc/fstab:

tmpfs    /compat/linux/dev/shm	tmpfs	rw,mode=1777	0	0

Then run "mount /compat/linux/dev/shm".

===> SECURITY REPORT: 
      This port has installed the following files which may act as network
      servers and may therefore pose a remote security risk to the system.
/compat/linux/usr/bin/gawk
/compat/linux/usr/lib64/libdb-4.7.so
/compat/linux/usr/lib/libgio-2.0.so.0.5600.1
/compat/linux/usr/lib64/libdb_cxx-4.7.so
/compat/linux/usr/lib/libresolv-2.17.so
/compat/linux/usr/lib/libgssrpc.so.4.2
/compat/linux/usr/lib/libdb-5.3.so
/compat/linux/usr/lib/libcrypto.so.1.0.2k
/compat/linux/usr/lib64/libgio-2.0.so.0.5600.1
/compat/linux/usr/lib/libdb-4.7.so
/compat/linux/usr/lib64/libselinux.so.1
/compat/linux/usr/libexec/gam_server
/compat/linux/usr/lib64/libgssrpc.so.4.2
/compat/linux/usr/lib64/libcrypto.so.1.0.2k
/compat/linux/usr/lib/libselinux.so.1
/compat/linux/usr/lib64/libresolv-2.17.so
/compat/linux/usr/bin/dgawk
/compat/linux/usr/lib/libdb_cxx-4.7.so
/compat/linux/usr/lib64/libdb-5.3.so
/compat/linux/usr/bin/pgawk

      If there are vulnerabilities in these programs there may be a security
      risk to the system. FreeBSD makes no guarantee about the security of
      ports included in the Ports Collection. Please type 'make deinstall'
      to deinstall the port if this is a concern.
===>  Cleaning for linux_base-c7-7.9.2009_1

```

In this article, I've already colored the display above, meaning we need to colorize it first. Okay, using the references above, let's start configuring the Linux binary. Let's open the `/etc/fstab` file and edit its contents by inserting the script above into the `/etc/fstab` file. For convenience, use the **"ee"** editor to insert the script above.

```
root@ns1:~ # ee /etc/fstab
linprocfs   /compat/linux/proc     linprocfs       rw      0       0
linsysfs    /compat/linux/sys      linsysfs        rw      0       0
tmpfs       /compat/linux/dev/shm  tmpfs           rw,mode=1777 0 0
devfs       /compat/linux/dev      devfs           rw,late 0 0
fdescfs     /compat/linux/dev/fd   fdescfs         rw,late,linrdlnk 0 0
```

The next step is to create a `/compat/linux` folder according to the script above.

```
root@ns1:~ # mkdir -p /compat/linux/dev/shm
root@ns1:~ # mkdir -p /compat/linux/proc
root@ns1:~ # mkdir -p /compat/linux/sys
root@ns1:~ # mkdir -p /compat/linux/dev/fd
```

Next, use the `"mount"` command to activate the above script.

```
root@ns1:~ # mount /compat/linux/proc
root@ns1:~ # mount /compat/linux/sys
root@ns1:~ # mount /compat/linux/dev/shm
root@ns1:~ # mount /compat/linux/dev/fd
```

Once the Linux binaries are successfully mounted, proceed to create a ZFS data set for the Linux binary files.

```
root@ns1:~ # zfs create -o compression=on -o mountpoint=/compat zroot/compat
root@ns1:~ # zfs snapshot -r zroot/compat@2022-04-22

```

The above script will create a ZFS filesystem in the `/compat` folder. The next step is to install `linux-sublime-text4`.

Follow the steps below to install `linux-sublime-text4`.

```
root@ns1:~ # cd /usr/ports/editors/linux-sublime-text4
root@ns1:/usr/ports/editors/linux-sublime-text4 # make install clean
```

## 2. Activate Linux Binary

Even though we've installed the Linux binary package, it can't be activated yet. Okay, now we'll activate the Linux binary package on a FreeBSD system. Open and edit the `/boot/loader.conf` file and enter the following script.

```
root@ns1:~ # ee /boot/loader.conf
zfs_load="YES"

linux_load="YES"
linux64_load="YES"
fdescfs_load="YES"
linprocfs_load="YES"
tmpfs_load="YES"
linsysfs_load="YES"
```

The above script will read the Linux kernel and ZFS filesystem when the computer is shut down or restarted. After that, we create an rc.d startup script in the `/etc/rc.conf` file.

```
root@ns1:~ # ee /etc/rc.conf
zfs_enable="YES"
kld_list="linux linux64 cuse fusefs /boot/modules/i915kms.ko"
linux_enable="YES"
```

After the rc.d startup script is successfully created, now you `restart/reboot` the computer.


```
root@ns1:~ # reboot
```

Wait for the computer to restart normally. Once the computer is up and running, the Linux binary installation and configuration are complete. You can use this Linux binary package to install Ubuntu, Debian, and even VGA card drivers.