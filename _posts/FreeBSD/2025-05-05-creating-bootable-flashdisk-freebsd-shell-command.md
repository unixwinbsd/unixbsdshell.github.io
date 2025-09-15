---
title: Creating a Bootable Flashdisk on FreeBSD with Shell Commands
date: "2025-05-05 07:45:10 +0100"
id: creating-bootable-flashdisk-freebsd-shell-command
lang: en
layout: single
author_profile: true
categories:
  - FreeBSD
tags: "SysAdmin"
excerpt: The rapid development of USB slots has also increased the data transfer speed of this device. Its speed can exceed CD-Rom
keywords: bootable, disk, flashdisk, cdrom, freebsd, iso, img, memstick, create, bios
---
It seems that the era of the glory of CD-Rom is starting to collapse, slowly its existence is starting to be undiscussed and even people rarely use it. CD-Rom which was once so needed for the installation process, is now starting to be abandoned. People are starting to switch to Flashdisk or other media that can be inserted into the USB slot.

Its small and slim shape and easy to carry and use make Flashdisk so popular with everyone. Almost everyone who is involved in the world of computers must have an object called Falsdisk. Not only that, with the help of several utilities owned by each operating system, Flashdisk is starting to replace the role of CD-Rom for the operating system installation process.

The rapid development of USB slots has also increased the data transfer speed of this tool. Its speed can exceed CD-Rom. Its development does not stop here, the capacity of Flashdisk has far exceeded CD-Rom. So it is very reasonable, if this tool is currently a loyal friend of programmers or computer users as a backup or installation media.

## 1. Bootable Flashdisk Software For img and iso

There are many software that you can use to create a bootable Flashdisk. Each operating system has its own characteristics. There is software that can only run on Windows, there is even bootable software that can be used on all operating systems such as Linux, BSD and MacOS.

Of the many software that can be used to create a bootable Flashdisk, there are some that are well-known. Generally, each person is different in choosing which application to use to create a bootable Flashdisk, this depends on taste. However, Balena Etcher is worth a try. Balen Etcher can run on Windows and Linux.

The installation process is easy. The display is attractive and easy to use. With just a few clicks, you have successfully created a bootable Flashdisk. If you are interested in using this software, you can download it directly from the [official website](https://etcher.balena.io/).

![Balena Etcher](https://gitflic.ru/project/unixbsdshell/ruby-static-page-jekyll-rb-openbsd/blob/raw?file=assets/images/6belan%20etcher.jpg&commit=37309a3ef08508603ff7852d40d1df5c87f477a6)

GUI commands are very easy to use, but if you are using Linux or FreeBSD based on a server that does not support GUI applications, this tool cannot be used. However, it is not that server-based computers are unable to create a bootable Flashdisk. Server-based systems support shell commands that are no less capable than GUI.

There are many applications that run with shell commands to create a bootable Flashdisk. Even its capabilities are no less than GUI-based applications. Even if we dissect it, programs such as Balena Etcher, Rufus or others are shell instructions that are almost exactly the same in FreeBSD and Linux.

One of the shell applications that can be used to create a bootable Flashdisk is the "dd" command. This command is capable of reading and writing all data to the Flashdisk.

## 2. About the dd Command

The `dd` `Dataset Definition` command is one of the shell commands in the UNIX system. Its use has been widely adopted by various operating systems. On the FreeBSD system, the dd command is one of the default commands embedded in the system. You don't need to install it, the dd command can be used directly.

The dd command is a UNIX shell command that has been used by FreeBSD since its initial release. This command is a powerful utility for low-level data copying and conversion, mainly used for disk cloning, creating disk images, partition backups, and writing ISO files to USB drives. Mastering the dd command is essential for FreeBSD system administrators, as it allows precise control over data manipulation, backup processes, and disk recovery.

In UNIX commands, the dd command is often referred to as a disk or data duplicator, because it is capable of copying raw data from one source to another. The dd utility is widely used in FreeBSD tasks such as:
- Can be used with tape backup.
- Conversion between systems that use different byte orders.
- Backing up the boot sector.
- Reading data from an inaccessible or damaged file system.

The dd command works by copying data byte by byte, so you can control the copying process down to the smallest level. This feature makes it ideal for tasks such as backing up disk partitions precisely and cloning entire disks.

In this article, we only focus on using the dd command to create a bootable Flashdisk. Okay, let's start the lesson. Please follow each step explained below.

## 3. Viewing the List of Disks Installed on the System

Because we are going to create a bootable Flashdisk, the first step that must be done is to insert the Flashdisk into the USB slot of the FreeBSD server computer. Now you check whether the system can read the Flashdisk. Use the camcontrol command to see all the Disks installed on FreeBSD.

```console
root@ns4:~ # camcontrol devlist
<WDC WD2500AAKX-753CA1 19.01H19>   at scbus1 target 0 lun 0 (pass0,ada0)
<JetFlash Transcend 16GB 1100>     at scbus3 target 0 lun 0 (da0,pass1)
```

Pay attention to the output of the camcontrol command above. From the output produced we can read, your FreeBSD system has been installed:
- Hard Disk with the brand WDC (Western Digital).
- Flashdisk with the brand JetFlash Transcend with a size of 16GB

FreeBSD considers USB devices as SCSI devices, to see complete information about the installed Disk you can use the `geom` command, as in the following example.

```console
root@ns4:~ # geom disk list
Geom name: ada0
Providers:
1. Name: ada0
   Mediasize: 250059350016 (233G)
   Sectorsize: 512
   Mode: r2w2e3
   descr: WDC WD2500AAKX-753CA1
   lunid: 50014ee159e9ece4
   ident: WD-WCAYV1684481
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

root@ns4:~ #
```

In addition to using the camcontrol and geom commands, you can also use the dmesg command to see a list of installed disks.

```console
root@ns4:~ # dmesg
Trying to mount root from zfs:zroot/ROOT/default []...
uhub3: 2 ports with 2 removable, self powered
uhub1: 2 ports with 2 removable, self powered
uhub4: 2 ports with 2 removable, self powered
uhub0: 2 ports with 2 removable, self powered
Root mount waiting for: usbus4 CAM
Root mount waiting for: usbus4 CAM
ada0 at ata2 bus 0 scbus1 target 0 lun 0
ada0: <WDC WD2500AAKX-753CA1 19.01H19> ATA8-ACS SATA 3.x device
ada0: Serial Number WD-WCAYV1684481
ada0: 150.000MB/s transfers (SATA, UDMA5, PIO 8192bytes)
ada0: 238475MB (488397168 512 byte sectors)
uhub2: 8 ports with 8 removable, self powered
ichsmb0: <Intel 82801GB (ICH7) SMBus controller> port 0x400-0x41f irq 19 at device 31.3 on pci0
smbus0: <System Management Bus> on ichsmb0
lo0: link state changed to UP
vr0: link state changed to DOWN
vr0: link state changed to UP
usb_msc_auto_quirk: UQ_MSC_NO_PREVENT_ALLOW set for USB mass storage device JetFlash Mass Storage Device (0x8564:0x1000)
ugen4.2: <JetFlash Mass Storage Device> at usbus4
umass0 on uhub2
umass0: <JetFlash Mass Storage Device, class 0/0, rev 2.10/11.00, addr 2> on usbus4
umass0:  SCSI over Bulk-Only; quirks = 0x8000
umass0:3:0: Attached to scbus3
da0 at umass-sim0 bus 0 scbus3 target 0 lun 0
da0: <JetFlash Transcend 16GB 1100> Removable Direct Access SPC-4 SCSI device
da0: Serial Number 17TYRSE65DEAAUTI
da0: 40.000MB/s transfers
da0: 15056MB (30834688 512 byte sectors)
da0: quirks=0x12<NO_6_BYTE,NO_RC16>
root@ns4:~ #
```

In the `dmesg` command above, the Hard Disk is read as ada0, and the Falshdisk is read as da0. While to read the characteristics of the Transcend JetFlash Flash Disk, use the diskinfo command.

```console
root@ns4:~ # diskinfo -v da0
da0
        512             # sectorsize
        15787360256     # mediasize in bytes (15G)
        30834688        # mediasize in sectors
        0               # stripesize
        0               # stripeoffset
        1919            # Cylinders according to firmware.
        255             # Heads according to firmware.
        63              # Sectors according to firmware.
        JetFlash Transcend 16GB # Disk descr.
        17TYRSE65DEAAUTI        # Disk ident.
        umass-sim0      # Attachment
        No              # TRIM/UNMAP support
        Unknown         # Rotation rate in RPM
        Not_Zoned       # Zone Mode

root@ns4:~ #
```

If you want to see complete information about the Hard Disk, just replace `da0` above with `ada0`.

```console
root@ns4:~ # diskinfo -v ada0
ada0
        512             # sectorsize
        250059350016    # mediasize in bytes (233G)
        488397168       # mediasize in sectors
        0               # stripesize
        0               # stripeoffset
        484521          # Cylinders according to firmware.
        16              # Heads according to firmware.
        63              # Sectors according to firmware.
        WDC WD2500AAKX-753CA1   # Disk descr.
        WD-WCAYV1684481 # Disk ident.
        ata2            # Attachment
        No              # TRIM/UNMAP support
        Unknown         # Rotation rate in RPM
        Not_Zoned       # Zone Mode

root@ns4:~ #
```

In the dmesg command above, the message displayed is too long, if you only want a few lines to be displayed, add the tail option. This option will take the number of messages you specify. Try practicing the example below.

```console
root@ns4:~ # dmesg | tail -5
root@ns4:~ # dmesg | tail -9
```

In addition to the above command, to find out information about the hard disk installed on FreeBSD, you can look at the `/var/run/dmesg.boot` file. This file contains a snapshot of the buffer taken after the file system is mounted at boot.

## 4. Formatting Flashdisk

In older versions of FreeBSD, the command to format a disk uses the fdisk command. In the latest versions of FreeBSD such as FreeBSD 13 and 14, the fdisk command is no longer used. Instead, FreeBSD uses utilities such as gpart to manage hard disk partitions. gpart is a utility that is usually used to create, delete, and manipulate partition tables on hard disks or flashdisks.

Before formatting a flashdisk, first see the current flashdisk partition with the `gpart` command.

```console
root@ns4:~ # gpart show da0
=>      64  30834561  da0  GPT  (15G)
        64   2374232    1  ms-basic-data  (1.1G)
   2374296      8496    2  efi  (4.1M)
   2382792       600    3  ms-basic-data  (300K)
   2383392       480       - free -  (240K)
   2383872  28448768    4  linux-data  (14G)
  30832640      1985       - free -  (993K)

root@ns4:~ #
```

In the `gpart` command display above da0 is a USB disk drive and is formatted with the efi file system. To format a Flashdisk or other USB media, in the example below we provide several options.

### a. Formatting Flashdisk With FAT32

The FAT32 file system is an advanced version of the FAT16 file system, which was first supported in Windows 95B. The FAT32 file system is also supported by Windows 98, Windows 2000, and Windows XP, 7. The main difference between the FAT32 and FAT16 file systems is that the FAT file allocation table can accommodate 268,435,445, not 65,536 entries about individual clusters.

If you want to use a Flashdisk on a Windows system, use the FAT32 format. With the FAT32 format all the contents of your Flashdisk can be read by Windows. The following is an example of the FAT32 format.

```console
root@ns4:~ # gpart destroy -F /dev/da0
da0 destroyed

root@ns4:~ # gpart create -s mbr /dev/da0
da0 created

root@ns4:~ # gpart add -t fat32 /dev/da0
da0s1 added

root@ns4:~ # newfs_msdos -L FILES -F 32 /dev/da0s1
/dev/da0s1: 30827008 sectors in 481672 FAT32 clusters (32768 bytes/cluster)
BytesPerSec=512 SecPerClust=64 ResSectors=32 FATs=2 Media=0xf0 SecPerTrack=63 Heads=255 HiddenSecs=0 HugeSectors=30834625 FATsecs=3764 RootCluster=2 FSInfo=1 Backup=2
```

Now let's look at the Flashdisk partition, whether it uses the FAT32 system.

```console
root@ns4:~ # gpart show da0
=>      63  30834625  da0  MBR  (15G)
        63  30834625    1  fat32  (15G)
```

In the `gpart` command above, your Flashdisk has been partitioned with the FAT32 file system. If you connect the Flashdisk to the Windows system, the Windows system will automatically read all the contents of the files on the Flashdisk disk.

### b. Formatting Flashdisk With UFS
Next, we will format the USB Disk with the UFS file system.

```console
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

Now we check whether the Flashdisk that we formatted above has been partitioned with the UFS file system, use the gpart show command to display the Flashdisk partition.

```console
root@ns2:~ # gpart show da0
=> 40 30834608 da0 GPT (15G)
40 1024 1 freebsd-boot (512K)
1064 984 - free - (492K)
2048 14680064 2 freebsd-ufs (7.0G)
14682112 16152536 3 freebsd-swap (7.7G)
```

The `gpart` show command above provides information that the Flashdisk has been formatted with a UFS file system partition.

### c. Formatting a Flashdisk with EFI
The next step, we will show you how to format a Flashdisk with the UFS file system. Follow these steps.

```console
root@ns4:~ # gpart destroy -F /dev/da0
da0 destroyed
root@ns4:~ # gpart create -s gpt /dev/da0
da0 created
root@ns4:~ # gpart add -t efi -l efiboot -a 4k -s 100M /dev/da0
da0p1 added
root@ns4:~ # newfs_msdos -F 16 -c 1 /dev/da0p1
newfs_msdos: warning: FAT type limits file system to 66069 sectors
/dev/da0p1: 65524 sectors in 65524 FAT16 clusters (512 bytes/cluster)
BytesPerSec=512 SecPerClust=1 ResSectors=1 FATs=2 RootDirEnts=512 Media=0xf0 FATsecs=256 SecPerTrack=63 Heads=255 HiddenSecs=0 HugeSectors=66069
root@ns4:~ # mount -t msdosfs /dev/da0p1 /mnt
root@ns4:~ # mkdir -p /mnt/EFI/BOOT
root@ns4:~ # cp /boot/loader.efi /mnt/EFI/BOOT/BOOTX64.efi
root@ns4:~ # umount /mnt
root@ns4:~ #
```

Perform a check on the Flashdisk partition formatted above.

```console
root@ns2:~ # gpart show da0
=> 40 30834608 da0 GPT (15G)
40 204800 1 efi (100M)
204840 30629808 - free - (15G)
```

## 5. Downloading the FreeBSD Installation Master File
The next step is to download the FreeBSD installation master file. In this step, try to make sure the FreeBSD file has the extension *.img, because if it has the extension *.iso the dd command will not be able to create a bootable Flashdisk from the computer. For those who are used to using Windows, you can download the FreeBSD file from the official FreeBSD website, then after the download is complete, you move the file to the FreeBSD server computer with the WINSCP program.

If you want to download the FreeBSD file directly from the FreeBSD system, you can use the wget or lynx command. In this example, we provide an example of downloading the FreeBSD.img file using the `wget` command.

```console
root@ns4:~ # cd /tmp
root@ns2:/tmp # wget https://download.freebsd.org/ftp/releases/ISO-IMAGES/13.2/FreeBSD-13.2-RELEASE-amd64-memstick.img
--2023-07-04 12:42:17-- https://download.freebsd.org/ftp/releases/ISO-IMAGES/13.2/FreeBSD-13.2-RELEASE-amd64-memstick.img
Resolving download.freebsd.org (download.freebsd.org)... 203.80.16.151, 2404:a8:3ff::15:0
Connecting to download.freebsd.org (download.freebsd.org)|203.80.16.151|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 1280627200 (1.2G) [application/octet-stream]
Saving to: ‘FreeBSD-13.2-RELEASE-amd64-memstick.img’

FreeBSD-13.2-RELEASE-amd64-memstick.img 2%[=> ] 29.63M 4.83MB/s eta 3m 17s
```

Wait until the download process is complete, if it is complete the `FreeBSD-13.2-RELEASE-amd64-memstick.img` file will be saved in the `/tmp` folder. Next, we create a bootable Flashdisk. Follow the command below to create a Bootable Flashdisk on FreeBSD with the dd command.

```console
root@ns4:~ # cd /tmp
root@ns2:/tmp # dd if=FreeBSD-13.2-RELEASE-amd64-memstick.img of=/dev/da0 bs=1M conv=sync status=progress
26214400 bytes (26 MB, 25 MiB) transferred 1.055s, 25 MB/s
31+0 records in
31+0 records out
32505856 bytes transferred in 1.522773 secs (21346492 bytes/sec)
```

The dd command above will copy the entire `FreeBSD-13.2-RELEASE-amd64-memstick.img` file to the Flashdisk and automatically make it bootable to be able to boot the computer so that it can directly read the Flashdisk that has been installed.

In order for the Flashdisk to start the booting process, you must set the BIOS menu on the computer. Change the boot order. Make the Flashdisk the first boot. After that, the FreeBSD installation process will automatically take place. You just follow each instruction displayed by the system. Installing FreeBSD is very easy, just like installing Windows, there are installation guides and instructions.
