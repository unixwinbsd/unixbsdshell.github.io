---
title: gpart Command To Manage Disk Partitions in FreeBSD - Part 2
date: "2025-07-18 09:11:21 +0100"
updated: "2025-07-18 09:11:21 +0100"
id: gpart-command-manage-disk-partition-freebsd-2
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

This article is a continuation of the previous section. In this article, we'll explore other gpart commands. To help you learn gpart easily, I recommend reading the previous article. If you want a deeper understanding of gpart and other commands, I recommend reading the book I wrote. [The FreeBSD Handbook - System Administrator](https://ko-fi.com/s/03a3074217).


In the previous article, at point `"C"` the gpart command was discussed up to point `"f"` In this article, we'll start at point `"g"`.

### g. Modifying Partition Attributes - gpart modify

The `gpart modify` command can only change the partition type and partition label. To change the partition type and label, you must specify the partition with the -i (index) option.

To use each gpart modify option, see the table below:


| Flags       | Description          | 
| ----------- | -----------   | 
| -f flags          | Additional operational flags. See the section titled "OPERATIONAL FLAGS" below for a discussion of their use.          | 
| -i index          | Specifies the partition index to be modified.      | 
| -l label          | Change partition label to label.     | 
| -t type          | Change the partition type to type.          | 


In the table above, we can see that the gpart modify command can only execute the -l and -t options in conjunction with the -i option.

#### g.1. Changing Partition Labels

In the example below, we'll show you how to change the label of a hard disk.

```console
root@ns4:~ # gpart show -l ada0
=>       40  488397088  ada0  GPT  (233G)
         40       1024     1  gptboot0  (512K)
       1064        984        - free -  (492K)
       2048    4194304     2  swap0  (2.0G)
    4196352  484200448     3  zfs0  (231G)
  488396800        328        - free -  (164K)
```

Note the message displayed by the gpart show command. The information above explains that the hard disk label name is `"zfs0"` with index 3. We will change this label name to "hard-disk-1" with the gpart modify command, as shown below.

```yml
root@ns4:~ # gpart modify -i 3 -l hard-disk-1 ada0
ada0p3 modified
```

After you change the label name to `hard-disk-1`, run the gpart show command to see whether the label name has been changed or not.

```console
root@ns4:~ # gpart show -l ada0
=>       40  488397088  ada0  GPT  (233G)
         40       1024     1  gptboot0  (512K)
       1064        984        - free -  (492K)
       2048    4194304     2  swap0  (2.0G)
    4196352  484200448     3  hard-disk-1  (231G)
  488396800        328        - free -  (164K)
```

In the command above we can see, the label name `"zfs0"` has been changed to `"hard-disk-1"`.

```yml
root@ns4:~ # diskinfo /dev/gpt/namalabel
/dev/gpt/namalabel      512     2147483648      4194304 0       1048576 261     255     63
```

#### g.2. Changing Partition Type

With `gpart modify`, you can also change the partition type of a hard disk. You can change the type of an existing partition; see the partitions on a flash drive below.

```console
root@ns4:~ # gpart show da0
=>      40  30834608  da0  GPT  (15G)
        40      2008       - free -  (1.0M)
      2048  14680064    1  freebsd-ufs  (7.0G)
  14682112   2097152    2  freebsd-ufs  (1.0G)
  16779264   4194304    3  freebsd-ufs  (2.0G)
  20973568   9861080       - free -  (4.7G)
```

There are three types of partitions: freebsd-ufs with index numbers 1, 2, and 3. Since you want to create a swap file, we'll convert one of the freebsd-ufs partitions to a swap partition. For example, we'll convert index number 2 to swap. To do this, simply run the command below.

```yml
root@ns4:~ # gpart modify -i 2 -t freebsd-swap da0
da0p2 modified
```

Now let's see the changes from the above command with gpart show.

```console
root@ns4:~ # gpart show da0
=>      40  30834608  da0  GPT  (15G)
        40      2008       - free -  (1.0M)
      2048  14680064    1  freebsd-ufs  (7.0G)
  14682112   2097152    2  freebsd-swap  (1.0G)
  16779264   4194304    3  freebsd-ufs  (2.0G)
  20973568   9861080       - free -  (4.7G)
```

### h. Changing Partition Size - gpart resize

Each partition has a predefined size, but you can resize it as desired. You can use the gpart resize command to resize an existing partition on a disk.

As always, before running the gpart command, check the currently active partition.

```console
root@ns4:~ # gpart show da0
=>      40  30834608  da0  GPT  (15G)
        40       512    1  freebsd-boot  (256K)
       552   2097152    2  freebsd-swap  (1.0G)
   2097704  12582912    3  freebsd-ufs  (6.0G)
  14680616  16154032       - free -  (7.7G)
```

In the command above, there is about 7.7G of free space at the end of the disk. Since partitions can only be resized to contiguous chunks of space, to resize the second partition (the root partition), we need to delete the third partition (which is safe because the swap partition only holds temporary data), resize the second partition, and then recreate the swap partition.

If you have enabled swap with the command `"swapon /dev/da0"` first disable the swap file on `da0`.

```yml
root@ns4:~ # swapoff /dev/da0
```

The next step is to delete the swap partition. Since the swap file is located at index number 2, you'll delete it with the `gpart delete` command.

```yml
root@ns4:~ # gpart delete -i 2 /dev/da0
```

See the changes from the swap partition deletion command.

```console
root@ns4:~ # gpart show /dev/da0
=>      40  30834608  da0  GPT  (15G)
        40       512    1  freebsd-boot  (256K)
       552   2097152       - free -  (1.0G)
   2097704  12582912    3  freebsd-ufs  (6.0G)
  14680616  16154032       - free -  (7.7G)
```

Next, we'll resize the freebsd-ufs partition to 12G. Note the index number of the freebsd-ufs partition. To resize the freebsd-ufs partition from 6.0G to 12G, run the command below.

```yml
root@ns4:~ # gpart resize -i 3 -s 12G -a 4k da0
da0p3 resized
```

As usual, view the results with the gpart show command.

```console
root@ns4:~ # gpart show da0
=>      40  30834608  da0  GPT  (15G)
        40       512    1  freebsd-boot  (256K)
       552   2097152       - free -  (1.0G)
   2097704  25165824    3  freebsd-ufs  (12G)
  27263528   3571120       - free -  (1.7G)
```

The command above shows that there's still 1.7G of free space. We'll use the remaining space to store the swap file. To create a swap partition, run the following command.

```yml
root@ns4:~ # gpart add -t freebsd-swap -a 4k da0
da0p2 added
```

### i. Installing Boot Code to a Partition - gpart bootcode

To install boot code to the partition scheme metadata on a disk, use the gpart bootcode command. For example, to install GPT boot code on da0, use:

```yml
root@ns4:~ # gpart bootcode -b /boot/pmbr -p /boot/gptboot -i 1 da0
partcode written to da0p1
bootcode written to da0
```
The above command will install the GPT boot code on the first partition (index 1) on disk da0. The -b option specifies the PMBR (Protective MBR) boot code, and the -p option specifies the GPT boot code.

If you want to use the ZFS boot code, replace gptboot with `gptzfsboot`.

```yml
root@ns4:~ # gpart bootcode -b /boot/pmbr -p /boot/gptzfsboot -i 1 da0
partcode written to da0p1
bootcode written to da0
```

### j. Creating a Backup Partition - gpart backup

Creating a backup partition is crucial to prevent system failure. With a backup partition, we can easily recover damaged or lost partitions.

You can create a backup partition with the gpart backup command. This command displays partition table information in a special text format. You can redirect this information to a file or pass it to the "gpart restore" command to restore the partition.

Here is a simple gpart backup command.

```console
root@ns4:~ # gpart backup ada0
GPT 128
1   freebsd-boot        40      1024 gptboot0
2   freebsd-swap      2048   4194304 swap0
3    freebsd-zfs   4196352 484200448 zfs0
```

To ensure the gpart backup command works optimally during recovery, it's recommended to create a dedicated file for the backup partition, as shown in the example below. 

```yml
root@ns4:~ # gpart backup da0 > /mnt/da0.backup
```

### k. Recovering a Partition - gpart restore

If you accidentally destroy a GPT partition table, you still have several options for recovering it. Make sure you've backed up your partition with the gpart backup command; otherwise, you'll have more work to do.

Now, if you've previously backed up your partition table using the gpart backup command, you're in luck, and it will likely only take a few shell commands to get your system back to normal.

We'll provide an example of running the gpart restore command to restore a deleted partition. Follow each command as we demonstrate.

#### k.1. Delete Partition

```yml
root@ns4:~ # gpart destroy -F /dev/da0
```

#### k.2. Create a table of partition schemes and partition types.

```yml
root@ns4:~ # gpart create -s gpt da0
root@ns4:~ # gpart add -s 64k -t freebsd-boot da0
root@ns4:~ # gpart add -s 6G -t freebsd-ufs da0
root@ns4:~ # gpart add -t freebsd-swap da0
root@ns4:~ # gpart bootcode -b /boot/pmbr -p /boot/gptboot -i 1 da0
```

Now you can see the contents of the partitions on `disk da0`.

```console
root@ns4:~ # gpart show da0
=>      40  30834608  da0  GPT  (15G)
        40       128    1  freebsd-boot  (64K)
       168  12582912    2  freebsd-ufs  (6.0G)
  12583080  18251568    3  freebsd-swap  (8.7G)
```

The commands above are exactly the same as the default FreeBSD installation settings.

- The first partition should be freebsd-boot and will most likely be 64k in size.
- The second partition is the root partition (freebsd-ufs).
- The third partition is the swap partition (freebsd-swap).
- The other partitions depend on your configuration.

#### k.3. Create a Backup Partition

```yml
root@ns4:~ # gpart backup da0 > /mnt/da0.backup
```

#### k.4. Delete Partition

```yml
root@ns4:~ # gpart destroy -F /dev/da0
```

#### k.5. Recover Partition

```yml
root@ns4:~ # gpart restore -F da0 < /mnt/da0.backup
```

In the restore command, the -F option will first completely wipe the partition table of data, then restore it from the file.

The main gpart commands, found in man gpart, are discussed in detail. Simply learn each command. If you have difficulty understanding the gpart commands, please leave a comment or visit the official gpart website.