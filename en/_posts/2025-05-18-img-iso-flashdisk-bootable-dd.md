---
title: FreeBSD Write img iso To Flashdisk For Bootable With dd Command
date: "2025-05-18 21:01:35 +0100"
id: img-iso-flashdisk-bootable-dd
lang: en
layout: single
author_profile: true
categories:
  - FreeBSD
tags: "SysAdmin"
excerpt: In Unix commands, the dd utility is often referred to as a disk/data duplicator, it allows us to copy raw data from one source to another.
keywords: img, iso, flashdisk, write, bootable, dd, command. shell, create
---

The dd utility can be used to create a bootable USB Disk, the dd command copies standard input to standard output. Input data is read and written in 512-byte blocks. If the input read is short, the input from multiple reads is combined to form an output block. When finished, dd displays the number of complete input and output blocks and a portion of the truncated input record to the output.

In Unix commands, the dd utility is often referred to as a disk/data duplicator, it allows us to copy raw data from one source to another. The dd utility is widely used in Unix tasks such as:
- Can work with tape backups.
- Convert between systems that use different byte orders.
- Back up boot sectors.
- Read data from inaccessible or damaged file systems.

To create a bootable USB, we usually use GUI applications like Linux Live USB Creator and other applications available for Linux, FreeBSD, and Windows. A bootable USB is required whenever there is a need to install a new operating system or if we want to run an operating system live.

In Unix-like operating systems, dd is a command-line utility used to convert and copy files. It is a great tool that can be used for various purposes like backing up and restoring disks, converting data formats, converting file cases, etc. The best thing is that it comes pre-installed in many Linux distributions.

In this article, we will discuss how to create a bootable USB disk using the dd utility on a FreeBSD system.

## 1. Display USB Disk List

Before creating a bootable USB disk, view the USB Disk list, so that we do not create a wrong bootable disk. Type the following command to view the USB Disk.

```
root@ns2:~ # dmesg
da0: <JetFlash Transcend 16GB 1100> Removable Direct Access SPC-4 SCSI device
da0: Serial Number 17TYRSE65DEAAUTI
da0: 40.000MB/s transfers
da0: 15056MB (30834688 512 byte sectors)
da0: quirks=0x12<NO_6_BYTE,NO_RC16>
```

In the dmesg command above, it reads the USB Flash Drive named "da0". FreeBSD stores the USB Disk data in the /dev/da0 folder branded Transcend 16 GB in size. To read the characteristics of the Transcend Flash Disk, use the diskinfo script.

```
root@ns2:/dev # diskinfo -v da0
da0
	512         	# sectorsize
	15787360256 	# mediasize in bytes (15G)
	30834688    	# mediasize in sectors
	0           	# stripesize
	0           	# stripeoffset
	1919        	# Cylinders according to firmware.
	255         	# Heads according to firmware.
	63          	# Sectors according to firmware.
	JetFlash Transcend 16GB	# Disk descr.
	17TYRSE65DEAAUTI	# Disk ident.
	umass-sim0  	# Attachment
	No          	# TRIM/UNMAP support
	Unknown     	# Rotation rate in RPM
	Not_Zoned   	# Zone Mode
```

FreeBSD considers USB devices as SCSI devices, camcontrol script can be used to view a list of USB Stick Disk device information, use the script below.

```
root@ns2:/dev # camcontrol devlist
<ST3120813AS 3.AAD>                at scbus1 target 0 lun 0 (pass0,ada0)
<JetFlash Transcend 16GB 1100>     at scbus6 target 0 lun 0 (da0,pass1)
```

Or you can also use the geom command.

```
root@ns2:/dev # geom disk list
Geom name: ada0
Providers:
1. Name: ada0
   Mediasize: 120034123776 (112G)
   Sectorsize: 512
   Mode: r2w2e3
   descr: ST3120813AS
   ident: 5LS10CHW
   rotationrate: unknown
   fwsectors: 63
   fwheads: 16

Geom name: da0
Providers:
1. Name: da0
   Mediasize: 15787360256 (15G)
   Sectorsize: 512
   Mode: r0w0e0
   descr: JetFlash Transcend 16GB
   lunname: USB MEMORY BAR
   lunid: 2020030102060804
   ident: 17TYRSE65DEAAUTI
   rotationrate: unknown
   fwsectors: 63
   fwheads: 255
```

## 2. Formatting USB Disk

Before formatting the USB disk, first view the USB disk partition with the gpart command.

```
root@ns2:/dev # gpart show da0
=>       3  30834683  da0  GPT  (15G)
         3        26    1  freebsd-boot  (13K)
        29        51       - free -  (26K)
        80      4096    2  efi  (2.0M)
      4176  30830510       - free -  (15G)
```









