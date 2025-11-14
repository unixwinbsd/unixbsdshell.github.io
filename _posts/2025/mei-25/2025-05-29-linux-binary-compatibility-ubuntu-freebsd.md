---
title: Ubuntu Install Guide on FreeBSD - Linux Binary Compatibility
date: "2025-05-29 09:01:00 +0100"
updated: "2025-09-06 13:25:09 +0100"
id: linux-binary-compatibility-ubuntu-freebsd
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: SysAdmin
background: https://gitflic.ru/project/unixbsdshell/ruby-static-page-jekyll-rb-openbsd/blob/raw?file=assets/images/15Starting%20Point%20for%20LinuxBot.jpg&commit=502843a8a243a1d20b43a0e577b73ae88fa5e5d8
toc: true
comments: true
published: true
excerpt: FreeBSD's native Linux Binatibility allows FreeBSD users, running i386 32-bit, amd64 64-bit, or arm64 64-bit architectures, to install and run 32-bit and 64-bit Linux binaries directly on a FreeBSD machine. This is done through system call tables, meaning, Linux applications can run without emulation or virtualization. FreeBSD’s native Linux Binatibility was introduced in the 90s.
keywords: ubuntu, install, guide, freebsd, linux, binary, compatibility, bash, shell
---

This article will cover the procedure for installing a base Ubuntu system into FreeBSD’s native Linux Binary Compatibility, so that Ubuntu and Debian-based desktop applications, such as Signal, Spotify, and Netflix, can run directly on FreeBSD. The discussion in this article uses Ubuntu 20.04 which will be installed into a FreeBSD 13.2 Stable system for the AMD64 64-bit architecture.

FreeBSD’s native Linux Binatibility allows FreeBSD users, running i386 32-bit, amd64 64-bit, or arm64 64-bit architectures, to install and run 32-bit and 64-bit Linux binaries directly on a FreeBSD machine. This is done through system call tables, meaning, Linux applications can run without emulation or virtualization. FreeBSD’s native Linux Binatibility was introduced in the 90s.

</br>
<img alt="starting point for linuxbot" width="99%" class="lazyload" style="display: block; margin: auto;" src="{{ 'https://gitflic.ru/project/unixbsdshell/ruby-static-page-jekyll-rb-openbsd/blob/raw?file=assets/images/15Starting%20Point%20for%20LinuxBot.jpg&commit=502843a8a243a1d20b43a0e577b73ae88fa5e5d8' | relative_url }}">
<br/>

## 1. Vulnerability Statistics
This is a list of vulnerability statistics for FreeBSD and Linux. The generally lower amount of security issues on FreeBSD doesn't necessarily mean that FreeBSD is more secure than Linux, even though I do believe it is, but it can also be because there is a lot more eyes on Linux. However, the attack surface on most Linux distributions are considerably higher that on FreeBSD.


| Year    | FreeBSD | Linux |
|---------|---------|-------|
| 1999    | 18      | 19    |
| 2000    | 27      | 5     |
| 2001    | 36      | 22    |
| 2002    | 31      | 15    |
| 2003    | 14      | 19    |
| 2004    | 15      | 51    |
| 2005    | 17      | 133   |
| 2006    | 27      | 90    |
| 2007    | 9       | 62    |
| 2008    | 15      | 71    |
| 2009    | 11      | 102   |
| 2010    | 8       | 123   |
| 2011    | 10      | 83    |
| 2012    | 10      | 115   |
| 2013    | 13      | 189   |
| 2014    | 18      | 130   |
| 2015    | 6       | 86    |
| 2016    | 6       | 217   |
| 2017    | 23      | 454   |
| 2018    | 29      | 177   |
| 2019    | 18      | 170   |
| 2020    | 31      | 126   |
| 2021    | 25      | 158   |
| 2022    | 1       | 73    |
|---------|---------|-------|
| Total   | 430     | 2780  |


For further information about the specific vulnerabilities you can take a look at the [CVE Details](https://www.blogger.com/blog/post/edit/2425380976366117670/8935719792500982828#) website for  [FreeBSD](https://www.blogger.com/blog/post/edit/2425380976366117670/8935719792500982828#)  and  [Linux](https://www.cvedetails.com/product/47/Linux-Linux-Kernel.html?vendor_id=33)

## 2. FreeBSD Kernel For Ubuntu Linux
The first step to run Ubuntu on FreeBSD is to enable the Ubuntu Linux kernel on your FreeBSD computer. FreeBSD has built-in binary compatibility with Linux. This allows you to run both Ubuntu and Linux binaries. This is enabled by loading a Linux kernel module. Here is the Linux kernel on FreeBSD.

```yml
kldload linux
kldload linux64
kldload fdescfs
kldload linprocfs
kldload tmpfs
kldload linsysfs
```

In order for the Linux kernel to be active on the FreeBSD machine, so that when the computer is restarted, the kernel can be read directly by FreeBSD. Enter the Linux kernel script in the /boot/loader.conf file.

```console
root@ns1:~ # ee /boot/loader.conf
linux_load="YES"
linux64_load="YES"      
fdescfs_load="YES"
linprocfs_load="YES"
tmpfs_load="YES"
linsysfs_load="YES"
```

The above script will make the Ubuntu Linux kernel permanent on the FreeBSD system. Once the kernel is permanent, create the rc.d script in the `/etc/rc.conf` file.

```console
root@ns1:~ # ee /etc/rc.conf
kld_list="linux linux64 cuse fusefs /boot/modules/i915kms.ko"
linux_enable="YES"
ubuntu_enable="YES"
```

## 3. Create a Basic Ubuntu System Script on FreeBSD rcd
Type the following script to start activating the Ubuntu Base System.

```console
root@ns1:~ # touch /usr/local/etc/rc.d/ubuntu
root@ns1:~ # chmod +x /usr/local/etc/rc.d/ubuntu
root@ns1:~ # ee /usr/local/etc/rc.d/ubuntu
#!/bin/sh
#
# PROVIDE: ubuntu
# REQUIRE: archdep mountlate
# KEYWORD: nojail
#

. /etc/rc.subr

name="ubuntu"
desc="Ubuntu for FreeBSD Linux Binary Compatibility"
rcvar="ubuntu_enable"
start_cmd="${name}_start"
stop_cmd=":"

unmounted()
{
  [ `stat -f "%d" "$1"` == `stat -f "%d" "$1/.."` -a `stat -f "%i" "$1"` != `stat -f "%i" "$1/.."` ]
}

ubuntu_start()
{
  local _tmpdir
  load_kld -e 'linux(aout|elf)' linux
  case `sysctl -n hw.machine_arch` in
    amd64)
      load_kld -e 'linux64elf' linux64
      ;;
  esac
  if [ -x "/compat/ubuntu/sbin/ldconfigDisabled" ]; then
    _tmpdir=`mktemp -d -t linux-ldconfig`
    /compat/ubuntu/sbin/ldconfig -C ${_tmpdir}/ld.so.cache
    if ! cmp -s "${_tmpdir}/ld.so.cache" "/compat/ubuntu/etc/ld.so.cache"; then
      cat "${_tmpdir}/ld.so.cache" > "/compat/ubuntu/etc/ld.so.cache"
    fi
    rm -rf ${_tmpdir}
  fi
  load_kld pty
  if [ `sysctl -ni kern.elf64.fallback_brand` -eq "-1" ]; then
    sysctl kern.elf64.fallback_brand=3 > /dev/null
  fi
  if [ `sysctl -ni kern.elf32.fallback_brand` -eq "-1" ]; then
    sysctl kern.elf32.fallback_brand=3 > /dev/null
  fi
  sysctl compat.linux.emul_path="/compat/ubuntu"
  unmounted "/compat/ubuntu/dev" && (mount -o nocover -t devfs devfs "/compat/ubuntu/dev" || exit 1)
  unmounted "/compat/ubuntu/dev/fd" && (mount -o nocover,linrdlnk -t fdescfs fdescfs "/compat/ubuntu/dev/fd" || exit 1)
  unmounted "/compat/ubuntu/dev/shm" && (mount -o nocover,mode=1777 -t tmpfs tmpfs "/compat/ubuntu/dev/shm" || exit 1)
  unmounted "/compat/ubuntu/home" && (mount -t nullfs /home "/compat/ubuntu/home" || exit 1)
  unmounted "/compat/ubuntu/proc" && (mount -o nocover -t linprocfs linprocfs "/compat/ubuntu/proc" || exit 1)
  unmounted "/compat/ubuntu/sys" && (mount -o nocover -t linsysfs linsysfs "/compat/ubuntu/sys" || exit 1)
  unmounted "/compat/ubuntu/tmp" && (mount -t nullfs /tmp "/compat/ubuntu/tmp" || exit 1)
  unmounted /dev/fd && (mount -o nocover -t fdescfs fdescfs /dev/fd || exit 1)
  unmounted /proc && (mount -o nocover -t procfs procfs /proc || exit 1)
  true
}

load_rc_config $name
run_rc_command "$1"
```

The above script will enable Ubuntu Base System on FreeBSD computer. So, when the computer reboots/restarts the FreeBSD system, the computer will automatically read the above Ubuntu Base System script. Let's try restarting Ubuntu Base System now.

```console
root@ns1:~ # service ubuntu restart
```

## 4. Create a Linux Compatibility Directory ZFS Data Sheet
The Linux ZFS datasheet is used to create snapshots, delete files, and securely erase entire volumes without disturbing the FreeBSD directory file system. Follow the script below to create a ZFS datasheet for Linux.

```console
root@ns1:~ # zfs create -o compression=on -o mountpoint=/compat zroot/compat
root@ns1:~ # zfs snapshot -r zroot/compat@2022-04-22
```
Once the Linux ZFS datasheet has been created, proceed to create a directory for the Ubuntu Base System.

```console
root@ns1:~ # mkdir -p /compat/ubuntu/{dev/fd,dev/shm,home,proc,sys,tmp}
```
Enable Ubuntu Base System on FreeBSD.

```console
root@ns1:~ # service ubuntu restart
compat.linux.emul_path: /compat/ubuntu -> /compat/ubuntu
```

## 5. Installing Ubuntu Base System to Linux Compatibility Directory
The Ubuntu Base System installation file is `debootstrap`. This file will be used to download and install the Ubuntu base system by specifying the Ubuntu target, such as focal for Focal Fossa, which is a version of Ubuntu 20.04 LTS.

```console
root@ns1:~ # pkg install linux-sublime-text4
root@ns1:~ # pkg install debootstrap
```
Download and install Ubuntu Base System to the Linux compatibility directory.

```console
root@ns1:~ # debootstrap --arch=amd64 --no-check-gpg focal /compat/ubuntu
I: Configuring netcat-openbsd...
I: Configuring isc-dhcp-client...
I: Configuring debconf-i18n...
I: Configuring vim-tiny...
I: Configuring ca-certificates...
I: Configuring libapt-pkg6.0:amd64...
I: Configuring gir1.2-glib-2.0:amd64...
I: Configuring whiptail...
I: Configuring keyboard-configuration...
I: Configuring libpython3.8-stdlib:amd64...
I: Configuring python3.8...
I: Configuring libxml2:amd64...
I: Configuring libpython3-stdlib:amd64...
I: Configuring apt...
I: Configuring apt-utils...
I: Configuring python3...
I: Configuring python3-six...
I: Configuring python3-gi...
I: Configuring shared-mime-info...
I: Configuring python3-netifaces...
I: Configuring lsb-release...
I: Configuring python3-cffi-backend...
I: Configuring python3-pkg-resources...
I: Configuring python3-dbus...
I: Configuring python3-yaml...
I: Configuring netplan.io...
I: Configuring ubuntu-advantage-tools...
I: Configuring python3-nacl...
I: Configuring networkd-dispatcher...
I: Configuring python3-pymacaroons...
I: Configuring console-setup-linux...
I: Configuring console-setup...
I: Configuring kbd...
I: Configuring ubuntu-minimal...
I: Configuring libc-bin...
I: Configuring systemd...
I: Configuring ca-certificates...
I: Base system installed successfully.
```
Fixed dynamic linking (ELF interpreter) with symbolic links.

```console
root@ns1:~ # cd /compat/ubuntu/lib64/
root@ns1:/compat/ubuntu/lib64 # rm ./ld-linux-x86-64.so.2
root@ns1:/compat/ubuntu/lib64 # ln -s ../lib/x86_64-linux-gnu/ld-2.31.so ld-linux-x86-64.so.2
```
After that, you restart Ubuntu.

```console
root@ns1:/compat/ubuntu/lib64 # service linux restart
root@ns1:/compat/ubuntu/lib64 # service ubuntu restart
compat.linux.emul_path: /compat/ubuntu -> /compat/ubuntu
```

## 6. Ubuntu Configuration
To configure Ubuntu on a FreBSD system, we need to enter a chroot jail, which will limit the configuration process to the base Ubuntu file system. If Ubuntu displays a message about a missing group ID, this can be ignored. You will notice that the Command Prompt will change.

```console
root@ns1:~ # chroot /compat/ubuntu /bin/bash
root@ns1:/# printf "%b\n" "0.0 0 0.0\n0\nUTC" > /etc/adjtime
root@ns1:/# dpkg-reconfigure tzdata

Current default time zone: 'Asia/Jakarta'
Local time is now:      Sun Jul  9 14:31:08 WIB 2023.
Universal Time is now:  Sun Jul  9 07:31:08 UTC 2023.

root@ns1:/# printf "APT::Cache-Start 251658240;" > /etc/apt/apt.conf.d/00aptitude
root@ns1:/# printf "APT::Cache-Start 251658240;" > /etc/apt/apt.conf.d/00aptitude
root@ns1:/# printf "deb http://archive.ubuntu.com/ubuntu/ focal main restricted universe multiverse" > /etc/apt/sources.list
root@ns1:/# exit
exit
root@ns1:~ #
```

If the above script has been executed, it means that we have enabled Linux Binary Compatibility on FreeBSD and installed the Ubuntu base system on it. With Ubuntu Linux active on FreeBSD, we can now install the Ubuntu repository on FreeBSD. Now we test by updating Ubuntu with the basic Ubuntu script, namely `apt update`.

```console
root@ns1:~ # chroot /compat/ubuntu /bin/bash
root@ns1:/# apt update
Get:1 http://archive.ubuntu.com/ubuntu focal InRelease [265 kB]
Get:2 http://archive.ubuntu.com/ubuntu focal/main amd64 Packages [970 kB]
Get:3 http://archive.ubuntu.com/ubuntu focal/main Translation-en [506 kB]
Get:4 http://archive.ubuntu.com/ubuntu focal/restricted amd64 Packages [22.0 kB]
Get:5 http://archive.ubuntu.com/ubuntu focal/restricted Translation-en [6212 B]
Get:6 http://archive.ubuntu.com/ubuntu focal/universe amd64 Packages [8628 kB]
Get:7 http://archive.ubuntu.com/ubuntu focal/universe Translation-en [5124 kB]                                      
Get:8 http://archive.ubuntu.com/ubuntu focal/multiverse amd64 Packages [144 kB]                                     
Get:9 http://archive.ubuntu.com/ubuntu focal/multiverse Translation-en [104 kB]                                     
Fetched 15.8 MB in 9s (1715 kB/s)                                                                                   
Reading package lists... Done
Building dependency tree... Done
All packages are up to date.
```

From the script above, everything is running normally. Let's continue by upgrading Ubuntu.

```console
root@ns1:/# apt list --upgradable
Listing... Done
root@ns1:/# apt upgrade
Reading package lists... Done
Building dependency tree... Done
Calculating upgrade... Done
0 upgraded, 0 newly installed, 0 to remove and 0 not upgraded.
root@ns1:/# apt autoremove
Reading package lists... Done
Building dependency tree... Done
0 upgraded, 0 newly installed, 0 to remove and 0 not upgraded.
root@ns1:/# apt clean
root@ns1:/#
```

Perfect!. All configurations are fine and Ubuntu is running normally on your FreeBSD computer. Now you can install Ubuntu-based programs on FreeBSD. To be more sure, we tested the installation of the NGINX application on Ubuntu.

```console
root@ns1:~ # chroot /compat/ubuntu /bin/bash
root@ns1:/# apt update
Hit:1 http://archive.ubuntu.com/ubuntu focal InRelease
Reading package lists... Done
Building dependency tree       
Reading state information... Done
All packages are up to date.
root@ns1:/# apt install nginx
Reading package lists... Done
Building dependency tree... Done
The following additional packages will be installed:
  fontconfig-config fonts-dejavu-core libfontconfig1 libfreetype6 libgd3 libjbig0 libjpeg-turbo8 libjpeg8
  libnginx-mod-http-image-filter libnginx-mod-http-xslt-filter libnginx-mod-mail libnginx-mod-stream libpng16-16
  libtiff5 libwebp6 libx11-6 libx11-data libxau6 libxcb1 libxdmcp6 libxpm4 libxslt1.1 nginx-common nginx-core
Suggested packages:
  libgd-tools fcgiwrap nginx-doc ssl-cert
The following NEW packages will be installed:
  fontconfig-config fonts-dejavu-core libfontconfig1 libfreetype6 libgd3 libjbig0 libjpeg-turbo8 libjpeg8
  libnginx-mod-http-image-filter libnginx-mod-http-xslt-filter libnginx-mod-mail libnginx-mod-stream libpng16-16
  libtiff5 libwebp6 libx11-6 libx11-data libxau6 libxcb1 libxdmcp6 libxpm4 libxslt1.1 nginx nginx-common nginx-core
0 upgraded, 25 newly installed, 0 to remove and 0 not upgraded.
Need to get 3851 kB of archives.
After this operation, 12.8 MB of additional disk space will be used.
Do you want to continue? [Y/n] y
```
To install Ubuntu applications on a FreeBSD computer, all you need to do is change the command prompt. Consider the following example.

```console
root@ns1:~ # chroot /compat/ubuntu /bin/bash
root@ns1:/# 
```

The above script explains `root@ns1:~ #` is the `FreeBSD` command prompt, you cannot run Ubuntu applications in this command prompt.

However, after you run the command `chroot /compat/ubuntu /bin/bash`, the command prompt will change to `root@ns1:/#`, meaning you have been active in the `Ubuntu` command prompt and can install `Ubuntu` applications in the `root@ns1:/#` command prompt.
