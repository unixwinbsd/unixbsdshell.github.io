---
title: Creating a Bootable Flashdisk on FreeBSD with Shell Commands
date: "2025-07-05 09:10:03 +0100"
updated: "2025-07-05 09:10:03 +0100"
id: creating-bootable-flashdisk-freebsd-shell
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: SysAdmin
background: https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/images/11belan_etcher.jpg
toc: true
comments: true
published: true
excerpt: Of the many software programs available for creating bootable flash drives, there are several well-known ones. Generally, each person has a different preference for which application to use to create a bootable flash drive; this depends on their preferences. However, Balena Etcher is worth a try. Balen Etcher can run on both Windows and Linux
keywords: bootable, flashdisk, dd, command, img, iso, freebsd
---

It seems the golden age of the CD-ROM is fading; its existence is slowly becoming less and less common, and people are even using it. Once essential for installation processes, CD-ROMs are now being phased out. People are turning to flash drives or other USB-compatible media.

Their small, slim design, easy portability, and ease of use have made flash drives highly sought after. Almost everyone involved in the computer world owns a flash drive. Furthermore, with the help of various utilities available for each operating system, flash drives are beginning to replace the role of CD-ROMs in operating system installation processes.

The rapid development of USB ports has also increased the data transfer speed of these devices, surpassing that of CD-ROMs. The development doesn't stop there; the capacity of flash drives has far surpassed that of CD-ROMs. It's no wonder, then, that these devices are now a loyal companion for programmers and computer users as backup or installation media.

## A. Bootable Flash Drive Software for img and iso

There is a wide variety of software you can use to create a bootable flash drive. Each operating system has its own unique characteristics. Some software only runs on Windows, while others can run on all operating systems, such as Linux, BSD, and macOS.

Of the many software programs available for creating bootable flash drives, there are several well-known ones. Generally, each person has a different preference for which application to use to create a bootable flash drive; this depends on their preferences. However, Balena Etcher is worth a try. Balen Etcher can run on both Windows and Linux.

The installation process is straightforward. It's visually appealing and easy to use. With just a few clicks, you can create a bootable flash drive. If you're interested in using this software, you can download it directly from [official website](https://etcher.balena.io/)

<br/>
<img alt="balena etcher" width="99%" class="lazyload" style="display: block; margin: auto;" src="{{ 'https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/images/11belan_etcher.jpg' | relative_url }}">
<br/>



GUI commands are very easy to use, but if you're using a Linux or FreeBSD server that doesn't support GUI applications, this tool won't work. However, it's not that server-based computers can't create bootable flash drives. Server-based systems support shell commands that are just as capable as GUI-based ones.

There are numerous applications that run with shell commands to create bootable flash drives. In fact, their capabilities are comparable to GUI-based applications. In fact, programs like Balena Etcher, Rufus, and others use almost identical shell commands on FreeBSD and Linux.

One shell application that can be used to create a bootable flash drive is the "dd" command. This command can read and write all data to a flash drive.

## B. About the dd Command

The `dd` Dataset Definition command is a shell command found in UNIX systems. Its use has been widely adopted by various operating systems. On FreeBSD, the dd command is one of the default commands built into the system. You don't need to install it; it can be used directly.

The dd command is a UNIX shell command that has been used by FreeBSD since its initial release. This command is a powerful utility for low-level data copying and conversion, primarily used for disk cloning, creating disk images, partition backups, and writing ISO files to USB drives. Mastering the dd command is essential for FreeBSD system administrators, as it allows precise control over data manipulation, backup processes, and disk recovery.

In UNIX commands, the dd command is often referred to as a disk or data duplicator, because it is capable of copying raw data from one source to another. The dd utility is widely used in FreeBSD tasks such as:

- Can be used with tape backup.
- Convert between systems that use different byte orders.
- Back up the boot sector.
- Read data from inaccessible or damaged file systems.

The dd command works by copying data byte by byte, allowing you to control the copying process down to the smallest detail. This feature makes it ideal for tasks like backing up disk partitions and cloning entire disks.

In this article, we'll focus solely on using the dd command to create a bootable flash drive. Let's get started! Please follow each step outlined below.


## C. Viewing a List of Disks Installed on the System

Since we're creating a bootable flash drive, the first step is to insert the flash drive into the USB slot on the FreeBSD server computer. Now, check if the system can read the flash drive. Use the camcontrol command to view all disks installed on FreeBSD.

```console
root@ns4:~ # camcontrol devlist
<WDC WD2500AAKX-753CA1 19.01H19>   at scbus1 target 0 lun 0 (pass0,ada0)
<JetFlash Transcend 16GB 1100>     at scbus3 target 0 lun 0 (da0,pass1)
```
Note the output from the camcontrol command above. From the output, we can see that your FreeBSD system has installed:

- A WDC (Western Digital) hard drive.
- A Transcend JetFlash flash drive with a size of 16GB.

FreeBSD considers USB devices to be SCSI devices. To view complete information about the installed disk, you can use the geom command, as shown in the following example.

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

Apart from using the `camcontrol` and `geom` commands, you can also use the `dmesg` command to see a list of installed disks.

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
In the `dmesg` command above, the Hard Disk is read as `ada0`, and the Flashdisk is read as `da0`. Meanwhile, to read the characteristics of the Transcend JetFlash Flash Disk, use the `diskinfo` command.

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
In the dmesg command above, the message displayed is too long. If you only want to display a few lines, add the tail option. This option will retrieve the number of messages you specify. Try the example below.

```console
root@ns4:~ # dmesg | tail -5
root@ns4:~ # dmesg | tail -9
```
In addition to the above command, you can also find information about the hard disks installed on FreeBSD by looking at the file `/var/run/dmesg.boot`. This file contains a snapshot of the buffer taken after the file system is mounted at boot time.


## D. Formatting a Flash Drive
In older versions of FreeBSD, the command to format a disk used the fdisk command. In newer versions of FreeBSD, such as FreeBSD 13 and 14, the fdisk command is no longer used. Instead, FreeBSD uses utilities like gpart to manage hard disk partitions. `gpart` is a utility commonly used to create, delete, and manipulate partition tables on hard disks or flash drives.

Before formatting a flash drive, first view the current partitions in use with the `gpart` command.

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
In the `gpart` command above, da0 is a USB disk drive formatted with the efi file system. To format a flash drive or other USB media, we provide several options in the example below.

### d.1. Formatting a Flash Drive with FAT32

The FAT32 file system is an advanced version of the FAT16 file system, first supported in Windows 95B. The FAT32 file system is also supported by Windows 98, Windows 2000, and Windows XP and 7. The main difference between the FAT32 and FAT16 file systems is that the FAT file allocation table can hold 268,435,445 entries, instead of 65,536 entries about individual clusters.

If you want to use a flash drive on a Windows system, use the FAT32 format. With the FAT32 format, all the contents of your flash drive can be read by Windows. The following is an example of a FAT32 format.


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

In the gpart command above, your flash drive has been partitioned with the FAT32 file system. If you connect the flash drive to a Windows system, Windows will automatically read all the files on the drive.

### d.2. Formatting the Flash Drive with UFS

Next, we will format the USB drive with the UFS file system.

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
The `gpart` show command above indicates that the flash drive has been formatted with a UFS file system partition.

### d.3. Formatting a Flash Drive with EFI

Next, we will demonstrate how to format a flash drive with the UFS file system. Follow these steps.

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

## E. Downloading the FreeBSD Master Installation File

The next step is to download the FreeBSD master installation file. In this step, ensure the FreeBSD file has a `*.img` extension, as if it has a `*.iso` extension, the dd command will not be able to create a bootable flash drive from your computer. For those familiar with Windows, you can download the FreeBSD file from the official FreeBSD website. Once the download is complete, transfer the file to the FreeBSD server computer using the `WINSCP` program.

If you want to download the FreeBSD file directly from the FreeBSD system, you can use the wget or lynx commands. In this example, we show you how to download the FreeBSD.img file using the wget command.

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
Wait for the download to complete. Once complete, the `FreeBSD-13.2-RELEASE-amd64-memstick.img` file will be saved in the `/tmp` folder. Next, we'll create a bootable flash drive. Follow the command below to create a bootable flash drive in FreeBSD using the `dd` command.

```console
root@ns4:~ # cd /tmp
root@ns2:/tmp # dd if=FreeBSD-13.2-RELEASE-amd64-memstick.img of=/dev/da0 bs=1M conv=sync status=progress
26214400 bytes (26 MB, 25 MiB) transferred 1.055s, 25 MB/s
31+0 records in
31+0 records out
32505856 bytes transferred in 1.522773 secs (21346492 bytes/sec)
```
The dd command above will copy the entire `FreeBSD-13.2-RELEASE-amd64-memstick.img` file to the flash drive and automatically create a bootable USB flash drive so the computer can boot directly and read the flash drive with the installation instructions.

To enable the flash drive to boot, you must configure the BIOS menu on your computer. Change the boot order and make the flash drive the first boot device.

After that, the FreeBSD installation process will begin automatically. Simply follow the instructions displayed by the system. Installing FreeBSD is very easy; just like installing Windows, there are installation guides and instructions.