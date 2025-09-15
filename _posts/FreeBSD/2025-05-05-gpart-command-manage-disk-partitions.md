---
title: gpart Command To Manage Disk Partitions in FreeBSD - Part 1
date: "2025-05-05 15:15:13 +0100"
id: gpart-command-manage-disk-partitions
lang: en
layout: single
author_profile: true
categories:
  - FreeBSD
tags: "SysAdmin"
excerpt: gpart GEOM Partitioning is a FreeBSD embedded shell command line for managing or recovering disk partition tables, especially if the primary partition table has been damaged or lost.
keywords: monitoring, disk, gpart, Partitions, freebsd, manage, activity, tools, ps, command, shell
---

As if there is no word stop, FreeBSD continues to update its system. Some command lines that are no longer suitable for current conditions are replaced with the latest, better commands. Like the bsdlabel and fdisk commands, they are currently no longer usable. Even FreeBSD developers have forgotten about both commands.

Instead, FreeBSD sets the gpart command as the default command to manage and organize Disks. This command is so amazingly capable of managing partitions on the latest Hard Disks with sizes reaching tera bytes. In fact, gpart is able to create, modify and delete partitions very effectively and quickly

This article provides a complete guide on how to use the gpart command to manage partitions in FreeBSD, covering its features, commands, and practical examples.

## A. About the gpart Command
Before you learn gpart, it's a good idea to know what gpart is. gpart GEOM Partitioning is a FreeBSD embedded shell command line for managing or recovering disk partition tables, especially if the primary partition table has been damaged or lost. The gpart command works by reading the disk sector by sector and using various file system recognition modules to identify potential partition boundaries and types.

This utility supports various partition schemes, including GPT (GUID Partition Table), MBR (Master Boot Record), and BSD labels. Basically, gpart helps recover lost or damaged partition information, allowing users to access data or recreate partitions.

gpart has the main features that you can enjoy, including:

- Support for Multiple Partitioning Schemes: gpart supports GPT, MBR, and BSD labels, making it versatile for a variety of use cases.
- Partition Management: Easily create, delete, resize, and modify partitions.
- Attribute Management: Set and modify partition attributes, such as bootable flags and partition types.
- Boot Code Management: Install and manage boot code for a variety of architectures.
- Scripting Capabilities: gpart commands can be scripted, making it suitable for automated tasks.

In its use, gpart is very flexible and allows users to create, modify, and delete partitions, as well as manage partition attributes and boot code very easily. gpart is capable of scanning disk sector by sector, looking for patterns and signatures that indicate the beginning of various file systems or partition types, because gpart is specifically designed to recover partition information when the primary partition table (located in sector 0 of the disk) is damaged or lost.

## B. Basic gpart Commands (flags)
gpart has many options that you can use. You must use all of these options correctly, according to the function of the option. Each option that gpart has is different, between one option and another. There are even options that can be combined.

You can see all the following gpart command lists with the options they have by typing the gpart -h command, as in the following example.

```console
root@ns4:~ # gpart help
usage: gpart add -t type [-a alignment] [-b start] [-s size] [-i index] [-l label] [-f flags] geom
       gpart backup geom
       gpart bootcode [-N] [-b bootcode] [-p partcode -i index] [-f flags] geom
       gpart commit geom
       gpart create -s scheme [-n entries] [-f flags] provider
       gpart delete -i index [-f flags] geom
       gpart destroy [-F] [-f flags] geom
       gpart modify -i index [-l label] [-t type] [-f flags] geom
       gpart set -a attrib [-i index] [-f flags] geom
       gpart show [-l | -r] [-p] [geom ...]
       gpart undo geom
       gpart unset -a attrib [-i index] [-f flags] geom
       gpart resize -i index [-a alignment] [-s size] [-f flags] geom
       gpart restore [-lF] [-f flags] provider [...]
       gpart recover [-f flags] geom
       gpart help
       gpart list [-a] [name ...]
       gpart status [-ags] [name ...]
       gpart load [-v]
       gpart unload [-v]
root@ns4:~ #
```

From the command display above, you should be able to understand how to use gpart and the options it has. However, we will provide a clearer explanation of how to use the gpart command.

To get more complete information on how to use gpart, run the command below.

```console
root@ns4:~ # man gpart
```

## C. How to Use the gpart Command
After you know what gpart is, its functions and various features, in this section we will give an example of how to use each command that gpart has. In this article we use Flashdisk media to practice using gpart. However, each command that we provide can also be run on a Hard disk, you only need to change the disk name, for example da0 for Flashdisk if you use a hard disk replace da0 with ada0.

Before you use the gpart command make sure how many disks your FreeBSD server computer has. Run the following command to see the number of disks on the FreeBSD system.

```console
root@ns4:~ # camcontrol devlist
<WDC WD2500AAKX-753CA1 19.01H19>   at scbus1 target 0 lun 0 (pass0,ada0)
<JetFlash Transcend 16GB 1100>     at scbus3 target 0 lun 0 (da0,pass1)
root@ns4:~ #
```

The command above explains that your computer only has 2 disks installed.
- A WDC (western digital) hard disk with the label ada0, and
- a Transcend flash disk with the label da0

In this article we only use da0 as a practice. If you want to see the ownership rights and file permissions on the da0 flash disk, use the ps command.

```console
root@ns4:~ # ls -l /dev/da0
crw-r-----  1 root operator 0x80 May 10 12:18 /dev/da0
```

### a. Displaying Partition Information - gpart show
To see what partitions are used by a flash drive, use the gpart show command. This command is used to display current partition information for a specified geom, or all geoms if none are specified.

#### a.1. Displaying All Partitions
If you want to see all disks installed on your FreeBSD computer, run the following command.

```console
root@ns4:~ # gpart show
=>       40  488397088  ada0  GPT  (233G)
         40       1024     1  freebsd-boot  (512K)
       1064        984        - free -  (492K)
       2048    4194304     2  freebsd-swap  (2.0G)
    4196352  484200448     3  freebsd-zfs  (231G)
  488396800        328        - free -  (164K)

=>      64  30834561  da0  GPT  (15G)
        64   2374232    1  ms-basic-data  (1.1G)
   2374296      8496    2  efi  (4.1M)
   2382792       600    3  ms-basic-data  (300K)
   2383392       480       - free -  (240K)
   2383872  28448768    4  linux-data  (14G)
  30832640      1985       - free -  (993K)

=>      64  30834561  iso9660/Runtu_LITE_24.04x64  GPT  (15G)
        64   2374232                            1  ms-basic-data  (1.1G)
   2374296      8496                            2  efi  (4.1M)
   2382792       600                            3  ms-basic-data  (300K)
   2383392       480                               - free -  (240K)
   2383872  28448768                            4  linux-data  (14G)
  30832640      1985                               - free -  (993K)

root@ns4:~ #
```

#### a.2. Displaying One Disk (Partition)
The command below will display more specific information from the active disk.

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

The above command displays default output including the logical start block of each partition, the partition size in blocks, the partition index number, the partition type, and the human-readable partition size. The block size and location are based on the device Sectorsize as shown by gpart list.

#### a.3. gpart show Options
The gpart show command has several options including:
> **-l :** For partition schemes that support partition labels, print the labels instead of partition types.
> 
> **-p :** Display provider names instead of partition indices.
> 
> **-r :** Display raw partition types instead of symbolic names.

Examples of using these options are as shown below.

```console
root@ns4:~ # gpart show -l
root@ns4:~ # gpart show -l da0
root@ns4:~ # gpart show -p ada0
root@ns4:~ # gpart show -r da0
```

### b. Creating a Partition Scheme - gpart create
The gpart create command is used to create a new partition scheme on a Flashdisk or Hard disk. The scheme to be used must be specified with the -s scheme option. So before you run the gpart add command. You must run the gpart create command first (don't reverse the command).

For example, you want to create a new partition, namely GPT on the da0 Flashdisk. The gpart create command will initialize da0 with the GPT partition scheme.

```console
root@ns4:~ # gpart create -s gpt /dev/da0
da0 created
```

If you wish, you can replace GPT with MBR or BSD if you prefer those schemes.

```console
root@ns4:~ # gpart create -s bsd da0
root@ns4:~ # gpart create -s mbr da0
```

After you have finished running the command above, continue with the gpart add command.

## c. Adding a New Partition - gpart add
After the partition scheme is created, you can add a new partition to the Flashdisk. The partition type must be specified with the -t option. The location, size, and other partition attributes will be calculated automatically if the related options are not specified.

The example command below will add a 10 GB partition to the Flashdisk `(da0)`, pay attention to the writing of the command.

```console
root@ns4:~ # gpart add -t freebsd-ufs -s 10G da0
da0p1 added
```

Let's see the results of the command above.

```console
root@ns4:~ # gpart show da0
=>      40  30834608  da0  GPT  (15G)
        40  20971520    1  freebsd-ufs  (10G)
  20971560   9863088       - free -  (4.7G)
```

In the command above we can see, a 10 GB partition with the type freebsd-ufs (used for UFS file systems) has been added to da0. You can specify a different partition type, such as freebsd-zfs for ZFS or linux-data for Linux partitions.

If you are working with a Hard disk that is larger than a Flashdisk. Can gpart create multiple partitions. gpart has many advantages, capable of creating multiple partitions on one disk.

In the example below, we will create two partitions on a 16 GB Flashdisk. We will create the first partition without specifying the initial LBA, but with a size of 1 GB (2097152 blocks). On the second partition without specifying the initial LBA and without specifying its size. In this way the partition will be created on all free space.

```console
root@ns4:~ # gpart add -t freebsd-swap -s 2097152 /dev/da0
da0p1 added
root@ns4:~ # gpart add -t freebsd-ufs /dev/da0
da0p2 added
root@ns4:~ # gpart show da0
=>      40  30834608  da0  GPT  (15G)
        40   2097152    1  freebsd-swap  (1.0G)
   2097192  28737456    2  freebsd-ufs  (14G)

root@ns4:~ #
```

The description of the above commands is:
- The first command is used to create a 1 GB swap file (2097152 blocks).
- The second command is used to create a UFS file system, with the remaining size of the swap file.
- The third command views the partition.

The table below shows the options of the gpart add command that you can use:

| Option       | description          | 
| ----------- | -----------   | 
| -a alignment          | If specified, the gpart utility attempts to align the starting offset and partition size to be multiples of the alignment values.          | 
| -b start          | The logical block address where the partition will start. SI unit suffixes are allowed.      | 
| -f flags          | Additional operational options     | 
| -i index          | The index in the partition table where the new partition will be placed. The index specifies the device-specific file name used to represent the partition.  | 
| -l label          | The label attached to the partition. This option is only valid when used on a partition scheme that supports partition labels.  | 
| -s size          | Create a partition with size size. SI unit suffixes are allowed.  | 
| -t type          | Create a partition of type type. Partition types are discussed below in the section titled "PARTITION TYPES".  | 

You can combine these options into one command.

```console
root@ns4:~ # gpart add -b 1058 -s 2G -l namalabel -a 1M -t freebsd-ufs da0
da0p1 added
```

To see the label name of the partition you created above, run the following command.

```console
root@ns4:~ # diskinfo /dev/gpt/namalabel
/dev/gpt/namalabel      512     2147483648      4194304 0       1048576 261     255     63
```

### d. Deleting Schemes and Partitions - gpart destroy

What you need to pay attention to is that gpart destroy is not the same as gpart delete. The gpart destroy command is used to delete partition schemes and all disk partitions. This means that the commands you run with gpart create and gpart add will all be deleted by gpart destroy.

For example, in the section above you have learned how to create a gpt partition scheme and create a UFS file system partition on a Flashdisk (ad0). With gpart destroy everything you create will be destroyed. How to run the gpart command to destroy the scheme and partitions in ad0 can be seen below.

```console
root@ns4:~ # gpart destroy -F da0

or

root@ns4:~ # gpart destroy -F /dev/da0
```

The above command removes all partitions and gpt schemes from da0. The -F option is used to force the destruction of the partition table even if it is not empty. Use this command with caution, as it will erase all data on the disk.

### e. Deleting Partitions - gpart delete
Unlike the gpart destroy command, the gpart delete command only deletes partitions on the disk. This means that gpart delete will only delete the command you ran with gpart add. While the partition scheme you created with gpart create is not deleted. So the difference between gpart destroy and gpart delete is very clear.

Okay, so you don't get confused, here are the differences between gpart destroy and gpart delete.
gpart destroy: Deletes the results of the gpart create and gpart add commands (schemes or tables and partitions).
gpart delete: Only deletes the results of the gpart add command (disk partitions)
The gpart delete command has the -i (index) option, this option must always be used when deleting partitions. The example image below shows a Flashdisk that has 6 partition indexes.

![index partitioning](https://gitflic.ru/project/unixbsdshell/ruby-static-page-jekyll-rb-openbsd/blob/raw?file=assets/images/7index%20partitioning.jpg&commit=1590e84c778a02e541259f58f1b9dcd6e433dc6a)

Pay attention to the `da0` column, the numbers 1 to 6 are the partition index. This index number is very important for deleting partitions. Here is an example of how to use the `gpart delete` command with the index according to the image above.

```console
root@ns4:~ # gpart delete -i 3 da0
da0p3 deleted
```

The example command above deletes the 3rd index partition. This means that the partition with serial number 3 has been deleted. To prove it, run the `gpart show da0` command.

![delete index partitioning](https://gitflic.ru/project/unixbsdshell/ruby-static-page-jekyll-rb-openbsd/blob/raw?file=assets/images/8delete%20index%20partitioning.jpg&commit=26e1c24f41bcf2e8cfc873211ce9708096edc51e)

### f. Confirming and Canceling

Partition Changes - gpart commit undo
A useful feature of the gpart utility is the recognition of "pending" changes. That is, if you add the -f x option, then the changes will not be written to disk immediately, but only after you issue the gpart commit command.

By default, the FreeBSD system runs the gpart command with the "C" option, meaning that every gpart command you run is immediately committed or executed. So that each gpart command is not immediately committed, you can specify the "-f x" option so that each gpart command produces pending changes. These pending changes can be immediately committed or canceled with the gpart undo command.

#### f.1. The gpart undo command
So in general the gpart commit and gpart undo commands are always paired in their use. To make it clearer, we will provide examples of the `gpart commit` and `gpart undo` commands.

```console
root@ns4:~ # gpart create -f x -s gpt da0
```

In the command above, create a partition scheme on Flashdisk (da0). Note the -f x option, with this option the partition scheme cannot be created, because it must be committed first or canceled.

If you want to cancel the command above, use gpart undo. Before you run the undo command. See the partition on the Flashdisk.

```console
root@ns4:~ # gpart show da0
=>      40  30834608  da0  GPT  (15G)
        40  30834608       - free -  (15G)
```

After that run the gpart undo command.

```console
root@ns4:~ # gpart undo da0
```

Run the gpart show command again, see the results. The gpart create command to create a new partition scheme has been canceled.

#### f.2. gpart commit command
Because our goal is to create a new partition scheme, the gpart create command can be committed directly. Consider the example command below to create a new partition scheme with the -f x option and commit it directly.

```console
root@ns4:~ # gpart create -f x -s gpt da0
```

Since the above command uses the -f x option, to apply it, just run the gpart commit command.

```console
root@ns4:~ # gpart show da0
```

If the gpart create command or other gpart command has been committed, then the gpart undo command cannot be used. As proof, run gpart undo.

```console
root@ns4:~ # gpart undo da0
gpart: Operation not permitted
```

The message "Operation not permitted" appears, because the gpart create command above has been applied or committed with gpart commit.

Because the discussion about the gpart command is quite long. In this article we divide it into two articles. For this first article we end with the gpart commit and undo commands. We continue with other gpart commands in the second article.
