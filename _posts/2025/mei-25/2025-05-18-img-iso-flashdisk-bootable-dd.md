---
title: FreeBSD Write img iso To Flashdisk For Bootable With dd Command
date: "2025-05-18 21:01:35 +0100"
updated: "2025-05-18 21:01:35 +0100"
id: img-iso-flashdisk-bootable-dd
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: SysAdmin
background: /img/Logo.png
toc: true
comments: true
published: true
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

In the above display da0 is a USB disk drive and is formatted with the efi file system. To format the USB disk, we will provide several options.

### 2.1. Format With FAT32

For Windows systems, it only reads the FAT32 file system format, so that the contents of the files on our USB disk can be read in Windows, the format used is FAT32, the following is an example of the FAT32 format.

```
root@ns2:~ # gpart destroy -F /dev/da0
da0 destroyed
root@ns2:~ # gpart create -s mbr /dev/da0
da0 created
root@ns2:~ # gpart add -t fat32 /dev/da0
da0s1 added
root@ns2:~ # newfs_msdos -L FILES -F 32 /dev/da0s1
/dev/da0s1: 30827008 sectors in 481672 FAT32 clusters (32768 bytes/cluster)
BytesPerSec=512 SecPerClust=64 ResSectors=32 FATs=2 Media=0xf0 SecPerTrack=63 Heads=255 HiddenSecs=0 HugeSectors=30834625 FATsecs=3764 RootCluster=2 FSInfo=1 Backup=2
```

Now let's see the USB disk partition, whether it uses the FAT32 system.

```
root@ns2:~ # gpart show da0
=>      63  30834625  da0  MBR  (15G)
        63  30834625    1  fat32  (15G)
```

In the gpat show command above, our USB disk has been partitioned with the FAT32 file system, if our USB disk contains files, automatically when opened in Windows it will immediately read the contents of the files on the USB disk.

### 2.2. Format with UFS

Next, we will format the USB Disk with the UFS file system.

```
root@ns2:~ # gpart destroy -F /dev/da0
da0 destroyed
root@ns2:~ # gpart create -s gpt da0
da0 created
root@ns2:~ # gpart add -t freebsd-boot -s 512k da0
da0p1 added
root@ns2:~ # gpart bootcode -b /boot/pmbr -p /boot/gptboot -i 1 da0
partcode written to da0p1
bootcode written to da0
root@ns2:~ # gpart add -t freebsd-ufs -b 1M -s 7G da0
da0p2 added
root@ns2:~ # gpart add -t freebsd-swap da0
da0p3 added
root@ns2:~ # newfs -U /dev/da0p2
/dev/da0p2: 7168.0MB (14680064 sectors) block size 32768, fragment size 4096
	using 12 cylinder groups of 625.22MB, 20007 blks, 80128 inodes.
	with soft updates
super-block backups (for fsck_ffs -b #) at:
 192, 1280640, 2561088, 3841536, 5121984, 6402432, 7682880, 8963328, 10243776, 11524224, 12804672, 14085120
```

Check if the USB disk is partitioned with UFS file system, use the gpart show script.

```
root@ns2:~ # gpart show da0
=>      40  30834608  da0  GPT  (15G)
        40      1024    1  freebsd-boot  (512K)
      1064       984       - free -  (492K)
      2048  14680064    2  freebsd-ufs  (7.0G)
  14682112  16152536    3  freebsd-swap  (7.7G)
```

The gpart show command shows that our USB disk has been partitioned with the UFS file system.

### 2.3. Format With EFI

Next, we will format the USB Disk with the UFS file system. Follow these steps.

```
root@ns2:~ # gpart destroy -F /dev/da0
da0 destroyed
root@ns2:~ # gpart create -s gpt /dev/da0
da0 created
root@ns2:~ # gpart add -t efi -l efiboot -a 4k -s 100M /dev/da0
da0p1 added
root@ns2:~ # newfs_msdos -F 16 -c 1 /dev/da0p1
newfs_msdos: warning: FAT type limits file system to 66069 sectors
/dev/da0p1: 65524 sectors in 65524 FAT16 clusters (512 bytes/cluster)
BytesPerSec=512 SecPerClust=1 ResSectors=1 FATs=2 RootDirEnts=512 Media=0xf0 FATsecs=256 SecPerTrack=63 Heads=255 HiddenSecs=0 HugeSectors=66069
root@ns2:~ # mount -t msdosfs /dev/da0p1 /mnt
root@ns2:~ # mkdir -p /mnt/EFI/BOOT
root@ns2:~ # cp /boot/loader.efi /mnt/EFI/BOOT/BOOTX64.efi
root@ns2:~ # umount /mnt
root@ns2:~ #
```

Check disk partition

```
root@ns2:~ # gpart show da0
=>      40  30834608  da0  GPT  (15G)
        40    204800    1  efi  (100M)
    204840  30629808       - free -  (15G)
```

## 3. Download FreeBSD img file

The next step is to download the FreeBSD parent file. In this step, try to make sure the FreeBSD file has the extension "img", because if it has the extension "iso" the dd command will not be able to create a bootable USB disk. You can download the FreeBSD file from Windows, then after it is finished we transfer it to the FreeBSD computer with WINSCP.

If you want to download the FreeBSD file directly from the FreeBSD system, you can use the wget or lynx command. In this case, an example of downloading the FreeBSD.img file using the wget command will be given.

```
root@ns2:~ # cd /tmp
root@ns2:/tmp # wget https://download.freebsd.org/ftp/releases/ISO-IMAGES/13.2/FreeBSD-13.2-RELEASE-amd64-memstick.img
--2023-07-04 12:42:17--  https://download.freebsd.org/ftp/releases/ISO-IMAGES/13.2/FreeBSD-13.2-RELEASE-amd64-memstick.img
Resolving download.freebsd.org (download.freebsd.org)... 203.80.16.151, 2404:a8:3ff::15:0
Connecting to download.freebsd.org (download.freebsd.org)|203.80.16.151|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 1280627200 (1.2G) [application/octet-stream]
Saving to: ‘FreeBSD-13.2-RELEASE-amd64-memstick.img’

FreeBSD-13.2-RELEASE-amd64-memstick.img      2%[=>             ]  29.63M  4.83MB/s    eta 3m 17s
```

Wait until the download process is complete, if it is complete the FreeBSD-13.2-RELEASE-amd64-memstick.img file will be saved in the /tmp folder. Next, we create a bootable USB disk. Follow the command below to create a Bootable USB Flash Disk.

```
root@ns2:~ # cd /tmp
root@ns2:/tmp # dd if=FreeBSD-13.2-RELEASE-amd64-memstick.img of=/dev/da0 bs=1M conv=sync status=progress
  26214400 bytes (26 MB, 25 MiB) transferred 1.055s, 25 MB/s
31+0 records in
31+0 records out
32505856 bytes transferred in 1.522773 secs (21346492 bytes/sec)
```

After finishing making Bootable USB Disk, install it on FreeBSD computer. Insert Flash Disk Drive in USB slot, turn on computer and enter BIOS. In bios menu, select boot or first boot is directed to Flash Disk, then save bios changes. Computer will automatically read Flash Disk Drive, follow the instructions in FreeBSD installation process, if still confused about how to install FreeBSD, can read article that reviews FreeBSD installation.
