---
title: gpart Command To Manage Disk Partitions in FreeBSD - Part 1
date: "2025-07-17 11:41:32 +0100"
updated: "2025-07-17 11:41:32 +0100"
id: gpart-command-manage-disk-partition-freebsd
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: UnixShell
background: https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/images/index_partisi.jpg
toc: true
comments: true
published: true
excerpt: Instead, FreeBSD has established the gpart command as the default command for managing and organizing disks. This command is incredibly capable of managing partitions on the latest hard drives, up to terabytes in size. In fact, gpart can create, modify, and delete partitions very effectively and quickly
keywords: gpart, disk, ssd, hard disk, command, partition, freebsd, manage, flashdisk, destroy
---

As if there's no stopping it, FreeBSD continues to update its system. Several command lines that are no longer suitable for the current environment have been replaced with newer, better commands. For example, the bsdlabel and fdisk commands are no longer usable. Even FreeBSD developers have abandoned these commands.

Instead, FreeBSD has established the gpart command as the default command for managing and organizing disks. This command is incredibly capable of managing partitions on the latest hard drives, up to terabytes in size. In fact, gpart can create, modify, and delete partitions very effectively and quickly.

This article provides a complete guide on how to use the gpart command to manage partitions in FreeBSD, covering its features, commands, and practical examples.

## A. About the gpart Command
Before you learn `gpart`, it's helpful to understand what gpart is. gpart GEOM Partitioning is a FreeBSD-embedded shell command line for managing or recovering disk partition tables, especially if the primary partition table has been damaged or lost. The gpart command works by scanning the disk sector-by-sector and using various file system recognition modules to identify potential partition boundaries and types.

This utility supports various partition schemes, including GPT (GUID Partition Table), MBR (Master Boot Record), and BSD labels. Essentially, gpart helps recover lost or damaged partition information, allowing users to access data or recreate partitions.

gpart has main features that you can enjoy, including:

- Support for Multiple Partitioning Schemes: gpart supports GPT, MBR, and BSD labels, making it versatile for a wide range of use cases.
- Partition Management: Easily create, delete, resize, and modify partitions.
- Attribute Management: Set and modify partition attributes, such as bootable flags and partition types.
- Boot Code Management: Install and manage boot code for various architectures.
- Scriptability: gpart commands can be scripted, making it suitable for automated tasks.

In its use, `gpart` is very flexible and allows users to create, modify, and delete partitions, as well as manage partition attributes and boot code very easily. gpart is capable of scanning disks sector by sector, looking for patterns and signatures that indicate the beginning of various file systems or partition types, because gpart is specifically designed to recover partition information when the primary partition table (located in sector 0 of the disk) is damaged or lost.

## B. Basic gpart Commands (flags)
gpart has a wide variety of options you can use. You must use all of these options appropriately, according to their intended function. Each gpart option is unique, and some options can even be combined.

You can see a list of all gpart commands and their options by typing gpart -h, as shown below.

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

From the command above, you should now understand how to use gpart and its options. However, we'll provide a more detailed explanation of how to use the gpart command.

For more detailed information on how to use gpart, run the command below.

```yml
root@ns4:~ # man gpart
```

## C. How to Use the gpart Command
Now that you understand what `gpart` is, its functions, and its various features, in this section, we'll demonstrate how to use each gpart command. In this article, we'll use a flash drive to demonstrate using gpart. However, each command we provide can also be run on a hard drive; simply change the disk name. For example, "da0" for a flash drive; if you're using a hard drive, replace "da0" with "ada0."

Before using the gpart command, determine the number of disks on your FreeBSD server. Run the following command to see the number of disks on your FreeBSD system.

```console
root@ns4:~ # camcontrol devlist
<WDC WD2500AAKX-753CA1 19.01H19>   at scbus1 target 0 lun 0 (pass0,ada0)
<JetFlash Transcend 16GB 1100>     at scbus3 target 0 lun 0 (da0,pass1)
root@ns4:~ #
```

The command above explains that your computer only has two disks installed.

- A WDC (Western Digital) hard drive labeled ada0, and
- A Transcend flash drive labeled da0.

In this article, we'll only use da0 for practical purposes. To view the file ownership and permissions on the da0 flash drive, use the ps command.

```console
root@ns4:~ # ls -l /dev/da0
crw-r-----  1 root operator 0x80 May 10 12:18 /dev/da0
```

### a. Displaying Partition Information - gpart show
To see what partitions are used by a flash drive, use the gpart show command. This command displays the current partition information for the specified geom, or all geoms if none are specified.

#### a.1. Displaying All Partitions
If you want to see all the disks installed on your FreeBSD computer, run the following command.

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
<br/>
#### a.2. Displaying a Single Disk (Partition)

The command below will display more specific information about the active disk.

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

The above command displays default output including the logical start block of each partition, the partition size in blocks, the partition index number, the partition type, and the human-readable partition size. The block size and location are based on the device's Sectorsize as shown by gpart list.

#### a.3. gpart show options

The gpart show command has several options, including:

- `-l :` For partition schemes that support partition labels, print the labels instead of the partition types.
- `-p :` Display the provider name instead of the partition index.
- `-r :` Display the raw partition type instead of the symbolic name.

Examples of how to use these options are shown below.

```yml
root@ns4:~ # gpart show -l
root@ns4:~ # gpart show -l da0
root@ns4:~ # gpart show -p ada0
root@ns4:~ # gpart show -r da0
```

### b. Creating a Partition Scheme - gpart create

The gpart create command is used to create a new partition scheme on a flash drive or hard drive. The scheme to be used must be specified with the -s scheme option. Therefore, before running the gpart add command, you must run the gpart create command first (do not reverse the commands).

For example, you want to create a new GPT partition on the da0 flash drive. The gpart create command will initialize da0 with the GPT partition scheme.

```yml
root@ns4:~ # gpart create -s gpt /dev/da0
da0 created
```

If you wish, you can replace GPT with MBR or BSD if you prefer those schemes.

```yml
root@ns4:~ # gpart create -s bsd da0
root@ns4:~ # gpart create -s mbr da0
```

After you've finished running the above command, continue with the gpart add command.

### c. Adding a New Partition - gpart add

Once the partition scheme is created, you can add a new partition to the flash drive. The partition type must be specified with the -t option. The partition location, size, and other attributes will be calculated automatically if the corresponding option is not specified.

The example command below will add a 10 GB partition to the flash drive (da0). Note the command syntax.

```yml
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

In the command above, we can see that a 10 GB partition of type freebsd-ufs (used for the UFS file system) has been added to da0. You can specify a different partition type, such as freebsd-zfs for ZFS or linux-data for Linux partitions.

If you're working with a hard disk larger than a flash drive, can you use gpart to create multiple partitions? gpart has many advantages, including the ability to create multiple partitions on a single disk.

In the example below, we'll create two partitions on a 16 GB flash drive. We'll create the first partition without specifying a starting LBA, but with a size of 1 GB (2097152 blocks). The second partition will be created without specifying a starting LBA and without specifying a size. This way, the partitions will be created on all free space.

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

The explanation of the commands above is as follows:

- The first command is used to create a 1 GB swap file (2097152 blocks).
- The second command is used to create a UFS file system, with the remaining size of the swap file.
- The third command displays the partitions.

The table below shows the gpart add command options you can use:


| OPTIONS       | DESCRIPTION          | 
| ----------- | -----------   | 
| -a alignment          | If specified, the gpart utility attempts to align the starting offset and partition size to be multiples of the alignment value.          | 
| -b start          | The logical block address where the partition will begin. SI unit suffixes are allowed.      | 
| -f flags          | Additional operational options     | 
| -i index          | The index in the partition table where the new partition will be placed. The index specifies the device-specific file name used to represent the partition.          | 
| -l label          | The label attached to the partition. This option is only valid when used with a partitioning scheme that supports partition labels.          | 
| -s size          | Create a partition with size size. SI unit suffixes are allowed.          | 
| -t type          | Create a partition of type . Partition types are discussed below in the section titled "PARTITION TYPES."          | 

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

### d. Deleting the Scheme and Partitions - gpart destroy

It's important to note that gpart destroy is not the same as gpart delete. The gpart destroy command is used to delete the partition scheme and all disk partitions. This means that the commands you run with gpart create and gpart add will be completely deleted by gpart destroy.

For example, in the section above, you learned how to create a GPT partition scheme and a UFS file system partition on a flash drive (ad0). With gpart destroy, everything you created will be destroyed. You can see how to run the gpart command to destroy the scheme and partitions on ad0 below.

```console
root@ns4:~ # gpart destroy -F da0

or

root@ns4:~ # gpart destroy -F /dev/da0
```

The above command deletes all partitions and the GPT scheme from da0. The -F option is used to force the destruction of the partition table, even if it is not empty. Use this command with caution, as it will erase all data on the disk.

### e. Deleting a Partition - gpart delete

Unlike the gpart destroy command, the gpart delete command only deletes existing partitions on the disk. This means that gpart delete will only delete the command you executed with gpart add. The partition scheme you created with gpart create will not be deleted. So, the difference between gpart destroy and gpart delete is clear.

Okay, so you don't get confused, here are the differences between gpart destroy and gpart delete.

- **gpart destroy :** Deletes the results of the gpart create and gpart add commands (schema or table and partitions).
- **gpart delete :** Only deletes the results of the gpart add command (disk partitions).

The `gpart delete` command has the -i (index) option; you should always use this option when deleting partitions. The example image below shows a flash drive with 6 index partitions.

<br/>
![Index Partition](https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/images/index_partisi.jpg)

<br/>

Note that in column da0, the numbers 1 through 6 are the partition indexes. This index number is crucial for deleting partitions. Here's an example of how to use the gpart delete command with the index shown in the image above. 

```
root@ns4:~ # gpart delete -i 3 da0
da0p3 deleted
```
The example command above deletes the 3rd index partition. This means the partition with serial number 3 has been deleted. To verify this, run the gpart show da0 command.

<br/>
<img alt="Delete partition index" width="99%" class="lazyload" style="display: block; margin: auto;" src="{{ 'https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/images/Delete_partition_index.jpg' | relative_url }}">
<br/>

### f. Confirming and Canceling Partition Changes - gpart commit undo

A useful feature of the gpart utility is its recognition of "pending" changes. This means that if you add the -f x option, the changes will not be written to disk immediately, but only after you issue the gpart commit command.

By default, FreeBSD runs gpart with the "C" option, meaning that every gpart command you run is immediately committed or executed. To prevent each gpart command from being immediately committed, you can specify the "-f x" option to cause each gpart command to produce pending changes. These pending changes can be immediately committed or undone with the gpart undo command.

#### f.1. The gpart undo command

So, in general, the gpart commit and gpart undo commands always go hand in hand. For clarity, we'll provide examples of the gpart commit and gpart undo commands.

```yml
root@ns4:~ # gpart create -f x -s gpt da0
```

The command above creates a partition scheme on the flash drive (da0). Note the -f x option; this option doesn't allow you to create the partition scheme yet, as it must be committed or canceled.

If you want to undo the command above, use gpart undo. Before running the undo command, view the partitions on the flash drive.

```console
root@ns4:~ # gpart show da0
=>      40  30834608  da0  GPT  (15G)
        40  30834608       - free -  (15G)
```

After that run the gpart undo command.

```yml
root@ns4:~ # gpart undo da0
```

Run the gpart show command again and review the results. The gpart create command to create the new partition scheme has been canceled.

#### f.2. The gpart commit command

Since our goal is to create a new partition scheme, the gpart create command can be committed immediately. Consider the example command below to create a new partition scheme with the -f x option and commit it immediately.

```yml
root@ns4:~ # gpart create -f x -s gpt da0
```

Since the above command uses the -f x option, to apply it, just run the gpart commit command.

```yml
root@ns4:~ # gpart show da0
```

If the gpart create command or any other gpart command has been committed, the gpart undo command cannot be used. For proof, run gpart undo.

```console
root@ns4:~ # gpart undo da0
gpart: Operation not permitted
```

The message `"Operation not permitted"` appears because the gpart create command above was executed or committed with gpart commit.

Because the discussion of gpart commands is quite lengthy, we've divided this article into two. In this first article, we'll end with the gpart commit and undo commands. We'll continue with other gpart commands in the second article.