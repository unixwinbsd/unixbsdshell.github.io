---
title: SWAP Command In OpenBSD - SWAP File - swapctl swapon
date: "2025-05-20 15:45:35 +0100"
updated: "2025-05-20 15:45:35 +0100"
id: swap-file-freebsd-swapctl-swapon
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: SysAdmin
background: /img/Logo.png
toc: true
comments: true
published: true
excerpt: Swap file is a file system that aims to create storage space on a hard disk or solid-state drive (SSD).
keywords: freebsd, swap, swapctl, swapon, command, shell, file, openbsd
---

When you use OpenBSD, the system immediately uses two types of memory, namely random access memory (RAM) and swap files. Unlike RAM which automatically stores data, swap files will work if you have set them on the hard disk. Another difference is that RAM only stores data temporarily. When the computer is turned off, RAM will release all the data it stores. While swap files can store data permanently on the hard disk.

In OpenBSD, like other operating systems, it uses a concept called virtual memory. This concept is used to avoid running out of memory due to high workloads from running application programs. The way to do this is by adding swap space to the OpenBSD system. Swap space is used to store memory pages that do not fit in physical memory.

All data that is not stored in physical memory will be stored on the hard disk. The swap space on this hard disk is known as a swap file. So, in other words, this swap file is a backup hard disk when physical memory is full or overloaded. So that system performance will not be disrupted.

## 1. Understanding Swap Files

A swap file is a file system that aims to create storage space on a hard disk or solid-state drive (SSD). This usually happens when the computer's RAM memory is running low. To make room for other programs, the file will be exchanged with some of the RAM storage of the running program.

Swap files are more like virtual memory than physical RAM. When you have a swap file, your system will pretend to have more RAM than you actually have. The programs used in RAM and the list of files will be moved to the hard disk until needed. This makes it possible to increase RAM capacity with the help of a hard disk.

A swap file is the name of a file stored on the hard disk where the operating system takes data from RAM memory. A swap file functions to simulate a larger RAM capacity than the physical RAM on the computer.

Swap files allow computers with small amounts of RAM to run large, complex programs. When a computer’s RAM runs out of free space, the operating system can transfer some of the data stored in RAM to a special file on the hard disk, known as a swap file. This frees up space in RAM and allows the computer to continue running.

The size of the swap file can vary depending on your operating system and the amount of physical RAM on your computer. However, it is important to make sure that the swap file is on a hard disk with enough free space so that the system can swap data efficiently.

## 2. Using the swapctl and swapon Commands

The swap command on OpenBSD is almost the same as NetBSD, on OpenBSD the swapctl program is used to add, remove, list, and prioritize swap devices and files for the system. while the swapon program acts the same as swapctl -a, except if swapon itself is called with -a, in which case it acts as swapctl -A.

To run the swapctl command, you must understand some of the options that accompany it, as shown in the following table.

| Option       | Description          | 
| ----------- | -----------   | 
| -A          | This option causes swapctl to read the /etc/fstab file for devices and files with an “sw” type, and adds all these entries as swap devices. If no swap devices are configured, swapctl will exit with an error code.          | 
| -a          | The -a option requires that a path also be in the argument list. The path is added to the kernel's list of swap devices using the swapctl(2) system call. When using the swapon form of this command, the -a option is treated the same as the -A option, for backwards compatibility.      | 
| -c          | The -c option changes the priority of the listed swap device or file.     | 
| -d path          | The -d option removes the listed path from the kernel's list of swap devices or files.  | 
| -k          | The -k option uses 1024 byte blocks instead of the default 512 byte.  | 
| -l          | The -l option lists the current swap devices and files, and their usage statistics.  | 
| -p priority          | The -p option sets the priority of swap devices or files to the priority argument.  | 
| -s          | The -s option displays a single line summary of current swap statistics.  | 
| -t blk  noblk          | This flag modifies the function of the -A option. The -t option allows the type of device to add to be specified. An argument of blk causes all block devices in /etc/fstab to be added. An argument of noblk causes all non-block devices in /etc/fstab to be added. This option is useful in early system startup, where swapping may be needed before all file systems are available, such as during disk checks of large file systems.  | 

### 2.1. Creating a Swap File

To add a swap file to your hard disk you must create a swap file. Use the dd command to create a swap file to the hard disk. Below is the dd command used to create a swap file (/var/swap1) with a size of 32MB.

```
# dd if=/dev/zero of=/var/swap1 bs=1k count=32768
32768+0 records in
32768+0 records out
33554432 bytes transferred in 3.259 secs (10295928 bytes/sec)
```

After that, you set the file usage permission. The goal is so that not all users can use the swap file.

```
# chmod 0600 /var/swap1
```

Then you add the swap file to the kernel swap device list with the swapctl command, as in the following example.

```
# swapctl -a /var/swap1
```

Now you check whether the files have been added to the swap device correctly.

```
# swapctl -l
Device      512-blocks     Used        Avail    Capacity  Priority
/dev/wd0b      4160768         0     4160768         0%         0
/var/swap1       65536         0       65536         0%         0
Total          4226304         0      4226304        0%
```

On OpenBSD all swap files are stored in /etc/fstab. You can see the swap file that you have created above with the following command.

```
# cat /etc/fstab
3b48513b4b0fa04e.b none swap sw
3b48513b4b0fa04e.a / ffs rw 1 1
3b48513b4b0fa04e.k /home ffs rw,nodev,nosuid 1 2
3b48513b4b0fa04e.d /tmp ffs rw,nodev,nosuid 1 2
3b48513b4b0fa04e.f /usr ffs rw,nodev 1 2
3b48513b4b0fa04e.g /usr/X11R6 ffs rw,nodev 1 2
3b48513b4b0fa04e.h /usr/local ffs rw,wxallowed,nodev 1 2
3b48513b4b0fa04e.j /usr/obj ffs rw,nodev,nosuid 1 2
3b48513b4b0fa04e.i /usr/src ffs rw,nodev,nosuid 1 2
3b48513b4b0fa04e.e /var ffs rw,nodev,nosuid 1 2
```

### 2.2. Enabling Swap Files at Boot

On NetBSD and OpenBSD, the swapctl tool can be used to enable swap devices or files at boot time. The following two commands are often run by default at NetBSD and OpenBSD startup to enable all block-type swap devices and swap files listed in /etc/fstab (with "sw").

With the -t option the swapctl command can specify the type of device to be added. The blk argument causes all block devices in /etc/fstab to be added. The noblk argument causes all non-block devices in /etc/fstab to be added.

These options are useful at initial system startup, where swapping may be required before all filesystems are available, such as during a disk check on a large file system.

```
# swapctl -A -t blk
# swapctl -A -t noblk
```

### 2.3. Soft Update

Soft Updates were designed by Greg Ganger and Yale Patt, and developed for FreeBSD by Kirk McKusick. Soft Updates partially change the order of operations with the buffer cache without removing the FFS write synchronization code in the catalog. This results in a significant speedup of write operations.

The soft update mechanism must be enabled at the mount stage. When mounting using the mount command, you must specify whether soft updates should be applied to this partition. Here is an example of enabling soft updates for a single sd0a partition. Open the /etc/fstab file, type a script like the example below.

```
/dev/sd0a/ffsrw,softdep 1 1
```

### 2.4. Deleting Swap Files

If the swap file you created is no longer used or you want to modify its size. You can delete the existing swap file with the following command.

```
# swapctl -d /var/swap1
```

I think you now have a good understanding of the swap file concept in OpenBSD. Now you can easily create a swap file or resize it as per your requirement.
