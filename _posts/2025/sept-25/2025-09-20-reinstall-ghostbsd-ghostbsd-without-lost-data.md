---
title: How to Reinstall GhostBSD Without Losing Data
date: "2025-09-20 17:05:33 +0100"
updated: "2025-09-20 17:05:33 +0100"
id: reinstall-ghostbsd-ghostbsd-without-lost-data
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: SysAdmin
background: https://gitea.com/UnixBSDShell/OpenBSD-Web-APP/raw/branch/main/image/remote-with-putty.png
toc: true
comments: true
published: true
excerpt: GhostBSD is a simple, elegant, and friendly BSD operating system for desktops and laptops based on FreeBSD. GhostBSD is a slow moving release while some GNU/Linux distros are on the cutting edge side; we try to offer a stable update and release cycle
keywords: bsd, ghostbsd, freebsd, unix, reinstall, install, losing, data
---

GhostBSD is a desktop distribution based on FreeBSD and offers a modified MATE user environment. By default, GhostBSD uses the OpenRC init system and the ZFS file system. Live mode and installation to hard drive are supported (using ginstall's own installer written in Python).

The latest release, GhostBSD 23.06.01, is designed using `FreeBSD 13.2 stable`. In this latest version, GhostBSD automates the installation of the correct NVIDIA drivers when booting in Live mode. The Update Station update installation utility provides package reinstallation if the update attempt fails. The BWN_GPL_PHY setting is enabled in the GENERIC kernel to build drivers containing GPLv2 licensed code. So it provides detection on most Broadcom chip-based devices, including iMacs.

GhostBSD is a simple, elegant, and friendly BSD operating system for desktops and laptops based on FreeBSD. GhostBSD is a slow moving release while some GNU/Linux distros are on the cutting edge side; we try to offer a stable update and release cycle. The official desktop environment is MATE. This system comes with a graphical application for installing software and updating your system. Most codecs for playing multimedia files are pre-installed. The installer utilizes OpenZFS, making installation easy and suitable for newcomers to BSD. With modest hardware requirements, GhostBSD is ideal for modern workstations and 64-bit single-board computer hardware.

In general, BSD-based OS such as FReeBSD are often considered difficult to understand and beyond the knowledge of the average computer user. We are trying to simplify FreeBSD to lower the entry level for using FreeBSD on a desktop or laptop. We provide all the benefits of the FreeBSD operating system combined with our in-house GUI tools.

For some people who are new to using GhostBSD, they will definitely have difficulty operating this system. Sometimes when GhostBSD is tampered with, system failures often occur. Usually this system failure is like GhostBSD not being able to boot into the Desktop display. If it's like that, GhostBSD users will feel annoyed and it will make them dizzy. How could it not be, GhostBSD doesn't go to the Desktop, what we see is a row of letters and numbers.

This article will help GHostBSD users in overcoming the problem above, namely GhostBSD won't log in or won't display the Desktop screen. This article will guide GhostBSD users to reinstall without losing data.


## 1. Reinstall GhosBSD

The process of reinstalling or reinstalling GhostBSD does not require a Flash Disk, so there is no Hard Disk formatting process. Because you don't use a flash disk, to reinstall this you have to enter server mode or the GhostBSD command shell. Make sure your GhostBSD is still connected to the internet and can be remoted with Putty. The following are the steps to reinstall GhostBSD.


### a. Login With Putty/Remmina

The Putty application is used to make it easier for us to reinstall GhostBSD, and make sure that GhostBSD SSH is active and can be accessed remotely with Putty or Remmina. In this article we will remote GhostBSD with Remmina. In the Remmina menu, type the GhostBSD computer IP, in this article the GhostBSD IP is 192.168.5.4. See the image below for Login with Remmina. If you use Windows, it is recommended to just use Putty.

<br/>
<img alt="remote with putty" width="99%" class="lazyload" style="display: block; margin: auto;" src="{{ 'https://gitea.com/UnixBSDShell/OpenBSD-Web-APP/raw/branch/main/image/remote-with-putty.png' | relative_url }}">

<br/>
<img alt="type ip address for remote putty" width="99%" class="lazyload" style="display: block; margin: auto;" src="{{ 'https://gitea.com/UnixBSDShell/OpenBSD-Web-APP/raw/branch/main/image/type-ip-address-for-remote-putty.png' | relative_url }}">
<br/>



### b. Download GhostBSD-Build

The GhostBSD-Build master file can be downloaded from Github. This file contains the main GhostBSD installation files. With this file we can reinstall GhostBSD. Before downloading the file, we will first install the dependencies to reinstall GhostBSD.


```yml
root@ns3:~ # pkg install git transmission-cli rsync
```

After that, we continue by downloading the GhostBSD-Build file. We will place this file in the `/tmp` folder, because this file is only temporary, after the installation is complete we will not use this file again.

```yml
root@ns3:~ # cd /tmp
root@ns3:/tmp # git clone https://github.com/ghostbsd/ghostbsd-build.git
Cloning into 'ghostbsd-build'...
remote: Enumerating objects: 10717, done.
remote: Counting objects: 100% (832/832), done.
remote: Compressing objects: 100% (341/341), done.
remote: Total 10717 (delta 453), reused 778 (delta 429), pack-reused 9885
Receiving objects: 100% (10717/10717), 138.86 MiB | 1.17 MiB/s, done.
Resolving deltas: 100% (4802/4802), done.
```


### c. GhostBSD-Build Reinstallation

After the download process above is complete, we can continue by starting to reinstall GhostBSD. This process takes a very long time, which is different from installing GhostBSD with a flash disk.


```yml
root@ns3:/ # cd /tmp
root@ns3:/tmp # cd ghostbsd-build
```

#### c.1. GhostBSD installation with MATE as default desktop


```console
root@ns3:/tmp/ghostbsd-build # ./build.sh -d mate -b unstable

or

root@ns3:/tmp/ghostbsd-build # ./build.sh -d mate -b release
```


#### c.2. GhostBSD installation with XFCE as default desktop

```yml
root@ns3:/tmp/ghostbsd-build # ./build.sh -d xfce -b unstable
```


The ghostbsd-build file can not only be used for the GhostBSD reinstallation process. This file can also be burned on a CD or Flashdisk and can be used for the GhostBSD installation process. It is hoped that this article will help FreeBSD Desktop users to reduce any difficulties for FreeBSD users.