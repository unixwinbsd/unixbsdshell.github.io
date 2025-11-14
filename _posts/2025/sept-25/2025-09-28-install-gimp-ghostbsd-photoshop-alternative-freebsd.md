---
title: How to Install GIMP on GhostBSD FreeBSD Photoshop Alternative For Image Manipulation
date: "2025-09-28 10:11:39 +0100"
updated: "2025-09-28 10:11:39 +0100"
id: install-gimp-ghostbsd-photoshop-alternative-freebsd
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: WebServer
background: /img/oct-25/oct-25-25.jpg
toc: true
comments: true
published: true
excerpt: That means you can always get the source of the program. Additionally, it is free to download over the Internet. GIMP fills the need for a free Photoshop-like program. This tool is available for most UNIX platforms. Binary versions are available for Solaris, SunOS, HP-UX, IRIX SGI, Linux, and FreeBSD
keywords: gimp, image, photoshop, alternative, ghostbsd, freebsd, installation, jpeg, jpg, png
---

This article will guide you to learn how to install and configure the GIMP program on GhostBSD or FreeBSD. For those of you who are used to Windows, you may already be familiar with the Photoshop program, the best image editing program in its class. For UNIX fans, especially those based on FreeBSD or GhostBSD, don't be discouraged, because there is GIMP whose capabilities and features are no less than Photoshop.


## 1. What Is GIMP

GIMP (GNU Image Manipulation Program) is a free, powerful, and powerful program for painting, image processing, and image manipulation. If you are used to using the Adobe Photoshop program, indirectly you will also like the GIMP program. GIMP is a project of Spencer Kimball and Peter Mattis at the University of California, Berkeley. GIMP originally started as a compiler class project in LISP. Frustration with the program, coupled with numerous system crashes, pushed the project in a new direction. Instead of LISP, the students decided to write an image manipulation project in C. The result quickly developed into a complete image editing program.

One important aspect of GIMP is that it is free software. It is released under the General Public License of the Free Software Foundation. That means you can always get the source of the program. Additionally, it is free to download over the Internet. GIMP fills the need for a free Photoshop-like program. This tool is available for most UNIX platforms. Binary versions are available for Solaris, SunOS, HP-UX, IRIX SGI, Linux, and FreeBSD. Since this program was written for UNIX, you're out of luck if you only have access to a Microsoft Windows or Apple Macintosh machine.

If you install and run GIMP, you will find that it is packed with features. Paint tools include brush, airbrush, text tool, clone, blur, and sharpen. You can also change the image with rotation, scaling, flipping and cropping. GIMP supports many common file formats: TIFF, GIF, JPEG, BMP, PPM, and others.


Selection can be done with the rectangle, ellipse, and freehand tools. If that's not enough, you can use smart scissors, blur selection by color, and even bezier selection. The program supports a large number of channel operations and many display types from 8 bit to 24 bit. Newer beta versions of the program support layers, transparency, and scripts to automatically generate logos and other images. Soon the program may be able to operate with graphics tablets.

One fantastic feature is the ability to use plug-ins, which allow users to create their own special features and special effects. GIMP volunteers and enthusiasts have written nearly a hundred different plug-ins including pinch, despeckle, oilify, plasma, map to sphere, fade, mosaic, line integral convolution, motion blur, engrave, page curl, sparkle, checkerboard, lens flare, displace , lunarize, de-interlace, and extrude. Users can get these plug-ins from the Web easily or write them themselves.


## 2. Install GIMP on Ghostbsd

On FreeBSD GIMP can be installed with the pkg package manager or with the ports system, whereas on GhostBSD you can only install GIMP with the pkg package manager, unless you have installed the ports system on GhostBSD. Before we start installing GIMP, we must first install GIMP dependencies.

### 2.1. GIMP Dependencies

GIMP dependencies are needed so that GIMP can run perfectly, because they will provide the binary and library files that GIMP needs. The following is how to install GIMP dependent programs.


On the GhostBSD Desktop display, right-click the mouse and click "Open in Terminal", a display like the following will appear.

```
Welcome to fish, the friendly interactive shell
Type help for instructions on how to use fish
ns3-ghostbsd-pc@ns3 /u/h/n/Desktop>
```

Once you are in the GhostBSD command shell menu, follow these steps.

```
ns3-ghostbsd-pc@ns3 /u/h/n/Desktop> su root
Password: masukkan password root GhostBSD anda
root@ns3:/usr/home/ns3-ghostbsd-pc/Desktop # pkg install graphics/gimp-app
root@ns3:/usr/home/ns3-ghostbsd-pc/Desktop # pkg install print/gimp-gutenprint
root@ns3:/usr/home/ns3-ghostbsd-pc/Desktop # pkg install print/gutenprint
```

The script above explains that GIMP will run on a super user, namely the root user. After the GIMP dependencies have been successfully installed, continue with installing GIMP.


### 2.2. GIMP installation

Now we will install GIMP. As a first step, we will demonstrate how to install GIMP on a FreeBSD system.

```
root@ns1:~ # cd /usr/ports/graphics/gimp
root@ns1:/usr/ports/graphics/gimp # make install clean
```

The script above is how to install GIMP on FreeBSD with a ports system. Then how to install GIMP on GhostBSD. Follow the steps below to install GIMP on GhostBSD.

```
root@ns3:/usr/home/ns3-ghostbsd-pc/Desktop # pkg install graphics/gimp
Updating GhostBSD repository catalogue...
GhostBSD repository is up to date.
All repositories are up to date.
Checking integrity... done (0 conflicting)
The following 1 package(s) will be affected (of 0 checked):

New packages to be INSTALLED:
	gimp: 2.10.32,2

Number of packages to be installed: 1

Proceed with this action? [y/N]: y
[1/1] Installing gimp-2.10.32,2...
[1/1] Extracting gimp-2.10.32,2: 100%
=====
Message from gimp-2.10.32,2:

--
Only the english gimp manual is supplied with this port. But other
translations are available. Please use "pkg search gimp-help" or check
the graphics/gimp-help meta port.
```

## 3. Running GIMP

After you have successfully installed GIMP, now is the time for us to run the GIMP program. In GhostBSD GIMP we will run it in the command shell menu. We are still active in the GhostBSD command shell, type the script `"gimp"`.

```
root@ns3:/usr/home/ns3-ghostbsd-pc/Desktop # gimp
```

The script above will open the GIMP program and will appear as shown in the image below.

![oct-25-24](https://raw.githubusercontent.com/unixwinbsd/unixbsdshell.github.io/refs/heads/main/img/oct-25-24.jpg)


If it appears like the image above, it means you have successfully installed and run GIMP on GhostBSD. You can use GIMP like you would use the Photoshop program. Even though the appearance is a bit different, the features and menus are almost the same as Photoshop. For those of you who are familiar with Photoshop, you won't have much difficulty operating the GIMP program.