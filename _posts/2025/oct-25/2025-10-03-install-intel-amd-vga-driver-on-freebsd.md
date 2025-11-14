---
title: How to Install Intel and AMD VGA Drivers on FreeBSD Systems
date: "2025-10-03 11:57:39 +0100"
updated: "2025-10-05 11:57:39 +0100"
id: install-intel-amd-vga-driver-on-freebsd
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: SysAdmin
background: /img/oct-25/oct-25-33.jpg
toc: true
comments: true
published: true
excerpt: DRM stands for Direct Rendering Manager and is a term taken from the Linux kernel development community that refers to how they solve the problem of dealing with newer graphics processors. It exposes APIs that allow user space applications to interact directly with the GPU
keywords: installation, intel, amd, vga, driver, vga driver, freebsd, unix, system, kmod, gpu, Linuxkpi, onboard
---

Actually, there are many ways to install the Carad VGA kernel on FreeBSD. This is because VGA cards consist of various types and brands. But of the many types of VGA cards, the onboard market is the most widely used. Onboard VGA can be said to dominate the entire computer market, from desktop PCs to laptops, all of which have embedded onboard VGA.

In this article we will discuss how to install a VGA Card using the drm-kmod kernel, one of the DRM drivers ported from Linux for FreeBSD which uses LinuxKPI. The driver folder contains source code from Linux to run on FreeBSD with LinuxKPI.



## 1. Waht is drm-kmod

DRM stands for `"Direct Rendering Manager"` and is a term taken from the Linux kernel development community that refers to how they solve the problem of dealing with newer graphics processors. It exposes APIs that allow user space applications to interact directly with the GPU.

Initially, FreeBSD was often called an application system that had difficulty getting graphics support, but now it is supported by a kernel developed by the Linux community. The kernel modules for the GPU have been embedded in one chip, one for the Intel chip, and one for the AMD. This driver then interacts with FreeBSD via `lkpi` (Linux Kernel Programming Interface). This approach allows FreeBSD to import Linux drivers with relatively minor modifications that will hopefully facilitate long-term FreeBSD support.

drm-kmod indirectly provides various kernel modules for use with:

- AMD graphics hardware.
- Intel Integrated Graphics.


### 1.1. AMD Graphics Hardware

There are two modules for AMD hardware, namely amdgpu and radeonkms


### 1.2. Intel Integrated Graphics

Intel HD Graphics refers to a class of graphics chips that are integrated on the same die as Intel CPUs. Intel HD Graphics chips are found in many modern laptop and desktop systems that have Intel CPUs embedded in them. Commonly found configurations include Kabylake Intel i915 HD Graphics.


## 2. How drm-kmod works

In addition to making long-term support easier, a lot of effort has been made by FreeBSD developers to make the VGA Card driver installation process easier. The firmware module was initially obtained from the Linux firmware repository, then the developers used this firmware module for use with the FreeBSD drm kms driver.

The firmware files are located in the amdgpukmsfw directory, the i915kmsfw file and the radeonkmsfw file, for each driver. The directory with the same name, but without -files, contains Makefiles for building kmods firmware for loading into the FreeBSD kernel.

LinuxKPI is a small compatibility layer that allows Linux drivers to run in the FreeBSD environment with minor modifications. The drm-kmod package, for example, includes Intel and AMD Linux graphics driver code, but compiles and runs fine on FreeBSD using LinuxKPI.

Although drm-kmod provides a working driver, there are FreeBSD-specific bugs, performance hits, and missing features as a result of the small LinuxKPI codebase. But you don't need to worry, all GPLv2 licensed Linux code has been rewritten under FreeBSD's 2-clause BSD License.


## 3. Installation and Configuration of drm-kmod

To start the drm-kmod installation, follow the steps below.

```
root@ns1:~ # pkg install drm-kmod
Message from drm-510-kmod-5.10.163_7:

--
The drm-510-kmod port can be enabled for amdgpu (for AMD
GPUs starting with the HD7000 series / Tahiti) or i915kms (for Intel
APUs starting with HD3000 / Sandy Bridge) through kld_list in
/etc/rc.conf. radeonkms for older AMD GPUs can be loaded and there are
some positive reports if EFI boot is NOT enabled (similar to amdgpu).

For amdgpu: kld_list="amdgpu"
For Intel: kld_list="i915kms"
For radeonkms: kld_list="radeonkms"

Please ensure that all users requiring graphics are members of the
"video" group.
```

After the above installation is complete, type the following command in the `/etc/rc.conf` file, use the `"ee"` editor to enter the command.

```
root@ns1:~ # ee /etc/rc.conf
#You activate one, according to the VGA on your computer
#kld_list="amdgpu"     #For amdgpu
kld_list="i915kms"    #For Intel
#kld_list="radeonkms"  #For radeonkms
```

The command above to activate the VGA Caard kernel, you select according to the type of VGA used on the computer. If your computer uses an Intel type VGA card, use the command `kld_list="i915kms"`. Because in this article, we are using an Intel type VGA card, type the following command in the `/boot/loader.conf` file.

```
root@ns1:~ # ee /boot/loader.conf
kld_list="/boot/modules/i915kms.ko"
```

If your computer uses an amdgpu or radeonkms VGA card, type the following script in the `/boot/loader.conf` file.

```
root@ns1:~ # ee /boot/loader.conf
#kld_list="amdgpu"
kld_list="/boot/modules/radeonkms.ko"
```

The final step is to reboot or restart the computer.

```
root@ns1:~ # reboot
```

After the restart process is complete, you can see the results of your FreeBSD Desktop display. Is there a change in appearance? The article above only explains the onboard type VGA Card configuration process. If your computer uses an Offboard VGA Card, you can read another article about the FreeBSD Offboard VGA kernel.