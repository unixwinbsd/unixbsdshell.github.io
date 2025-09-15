---
title: gpart Command To Manage Disk Partitions in FreeBSD - Part 2
date: "2025-05-05 17:45:33 +0100"
id: gpart-command-manage-disk-partitions-2
lang: en
layout: single
author_profile: true
categories:
  - FreeBSD
tags: "SysAdmin"
excerpt: gpart GEOM Partitioning is a FreeBSD embedded shell command line for managing or recovering disk partition tables, especially if the primary partition table has been damaged or lost.
keywords: monitoring, disk, gpart, Partitions, freebsd, manage, activity, tools, ps, command, shell
---
This article is a continuation of the previous article. In this article we will continue with other gpart commands. So that you do not have difficulty in learning the gpart command, I suggest reading the previous article. If you want a deeper understanding of the gpart command and others, I suggest reading the book I wrote ["The FreeBSD Handbook - System Administrator"](https://gitflic.ru/project/iwanse1212/the-freebsd-handbook-system-administrator).

In the previous article, namely at point "C", the discussion of the gpart command reached point "f". In this article we will start from point "g".

### g. Modifying Partition Attributes - `gpart modify`

The gpart modify command can only change the partition type and partition label. To change the partition type and label you must identify it with the -i (index) option.

To be able to use each gpart modify option, you can read it in the table below:

| Flags       | Description          | 
| ----------- | -----------   | 
| -f flags          | Additional operational flags. See the section titled "OPERATIONAL FLAGS" below for a discussion of their use.          | 
| -i index          | Specifies the index of the partition to be modified.      | 
| -l label          | Change the partition label to label.     | 
| -t type          | Change the partition type to type.          | 

In the table above, we can see that the gpart modify command can only work on the -l and -t options with reference to the -i option.

#### g.1. Changing Partition Labels
In the example below we will provide a way to change the label of a hard disk.

```console
root@ns4:~ # gpart show -l ada0
=>       40  488397088  ada0  GPT  (233G)
         40       1024     1  gptboot0  (512K)
       1064        984        - free -  (492K)
       2048    4194304     2  swap0  (2.0G)
    4196352  484200448     3  zfs0  (231G)
  488396800        328        - free -  (164K)
```

Pay attention to the message displayed by the gpart show command. The description above explains that the hard disk label name is `"zfs0"` with the index number 3. We will change the label name to "hard-disk-1" with the gpart modify command as in the example below.

```console
root@ns4:~ # gpart modify -i 3 -l hard-disk-1 ada0
ada0p3 modified
```
After you change the label name to hard-disk-1, run the gpart show command to see whether the label name has been changed or not.

```console
root@ns4:~ # gpart show -l ada0
=>       40  488397088  ada0  GPT  (233G)
         40       1024     1  gptboot0  (512K)
       1064        984        - free -  (492K)
       2048    4194304     2  swap0  (2.0G)
    4196352  484200448     3  hard-disk-1  (231G)
  488396800        328        - free -  (164K)
```

In the command above we can see, the label name "zfs0" has been changed to "hard-disk-1".

```console
root@ns4:~ # diskinfo /dev/gpt/namalabel
/dev/gpt/namalabel      512     2147483648      4194304 0       1048576 261     255     63
```

#### g.2. Changing Partition Type
With gpart modify you can also change the hard disk partition type. You can change the type of existing partitions, see the partition of a Flashdisk below.

```console
root@ns4:~ # gpart show da0
=>      40  30834608  da0  GPT  (15G)
        40      2008       - free -  (1.0M)
      2048  14680064    1  freebsd-ufs  (7.0G)
  14682112   2097152    2  freebsd-ufs  (1.0G)
  16779264   4194304    3  freebsd-ufs  (2.0G)
  20973568   9861080       - free -  (4.7G)
```

There are three types of partitions, namely freebsd-ufs with index numbers 1, 2 and 3. Because you want to create a swap file, one of the freebsd-ufs partitions will be changed into a swap partition, for example index no. 2 will be changed to swap. To do this, you simply run the command below.

```console
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

### h. Changing Partition Size - `gpart resize`
Each partition has a predetermined size, but you can change the size of the partition as desired. The gpart resize command can be used to change the size of an existing partition on a disk.

As usual, before running the gpart command, see the currently active partition.

```console
root@ns4:~ # gpart show da0
=>      40  30834608  da0  GPT  (15G)
        40       512    1  freebsd-boot  (256K)
       552   2097152    2  freebsd-swap  (1.0G)
   2097704  12582912    3  freebsd-ufs   (6.0G)
  14680616  16154032       - free -      (7.7G)
```
In the above command, there is free space at the end of the disk of about 7.7G. Since partitions can only be resized to contiguous chunks of space, to resize the second partition (i.e. the root partition), we need to delete the third partition (which is safe because the swap partition only holds temporary data), resize the second partition, and then recreate the swap partition.

If you have enabled swap with the command "swapon /dev/da0", first turn off the swap file in da0.

```console
root@ns4:~ # swapoff /dev/da0
```

The next step is to delete the swap partition. Since the swap file is in index no. 2, you delete the swap file with the gpart delete command.

```console
root@ns4:~ # gpart delete -i 2 /dev/da0
```

See the changes from the swap partition deletion command.

```console
root@ns4:~ # gpart show /dev/da0
=>      40  30834608  da0  GPT  (15G)
        40       512    1  freebsd-boot  (256K)
       552   2097152       - free -      (1.0G)
   2097704  12582912    3  freebsd-ufs   (6.0G)
  14680616  16154032       - free -      (7.7G)
```

Then we change the size of the freebsd-ufs partition to 12G. Note the index number of the freebsd-ufs partition. To change the size of the freebsd-ufs partition from 6.0G to 12G, run the command below.

```console
root@ns4:~ # gpart resize -i 3 -s 12G -a 4k da0
da0p3 resized
```

As usual, view the results with the gpart show command.

```console
root@ns4:~ # gpart show da0
=>      40  30834608  da0  GPT  (15G)
        40       512    1  freebsd-boot  (256K)
       552   2097152       - free -      (1.0G)
   2097704  25165824    3  freebsd-ufs   (12G)
  27263528   3571120       - free -      (1.7G)
```

From the command above there is still 1.7G of free space. The remaining size will be used to store the swap file. To create a swap partition you can run the following command.

```console
root@ns4:~ # gpart add -t freebsd-swap -a 4k da0
da0p2 added
```

### i. Installing Boot Code to Partitions - `gpart bootcode`
To install boot code to the partition scheme metadata on a disk, use the gpart bootcode command. For example, to install GPT boot code on da0, use:

```console
root@ns4:~ # gpart bootcode -b /boot/pmbr -p /boot/gptboot -i 1 da0
partcode written to da0p1
bootcode written to da0
```

The above command will install GPT boot code on the first partition -i (index 1) on disk da0. The -b option specifies PMBR (Protective MBR) boot code, and the -p option specifies GPT boot code.

If you want to use ZFS boot code, replace gptboot with gptzfsboot.

```console
root@ns4:~ # gpart bootcode -b /boot/pmbr -p /boot/gptzfsboot -i 1 da0
partcode written to da0p1
bootcode written to da0
```

### j. Creating a Backup Partition - `gpart backup`
Creating a backup partition is very important, to anticipate system failure. With a backup partition, we can easily recover damaged or lost partitions.

Creating a backup partition can be done with the gpart backup command. This command displays information about the partition table in a special text format. You can direct this information to a file, or send it to the "gpart restore" command to restore the partition.

Here is a simple gpart backup command.

```console
root@ns4:~ # gpart backup ada0
GPT 128
1   freebsd-boot        40      1024 gptboot0
2   freebsd-swap      2048   4194304 swap0
3    freebsd-zfs   4196352 484200448 zfs0
```

In order for the gpart backup command to operate optimally, during recovery. It is recommended to create a special file for the backup partition, as in the following example.

```console
root@ns4:~ # gpart backup da0 > /mnt/da0.backup
```

### k. Recovering Partitions - `gpart restore`
If you accidentally destroy the GPT partition table, you still have a few options to recover it. Note that you have already backed up the partition using the gpart backup command, otherwise you have a lot more work to do.

Now, if you have previously backed up the partition table using the gpart backup command, then you are in luck and most likely only need a few shell commands to get the system back to normal.

We will give an example of running the gpart restore command to restore a deleted partition. Follow each command that we show.

#### k.1. Delete Partition

```console
root@ns4:~ # gpart destroy -F /dev/da0
```

#### k.2. Create a table of partition schemes and partition types.

```console
root@ns4:~ # gpart create -s gpt da0
root@ns4:~ # gpart add -s 64k -t freebsd-boot da0
root@ns4:~ # gpart add -s 6G -t freebsd-ufs da0
root@ns4:~ # gpart add -t freebsd-swap da0
root@ns4:~ # gpart bootcode -b /boot/pmbr -p /boot/gptboot -i 1 da0
```

Now you can see the contents of the partitions on disk `da0`.

```console
root@ns4:~ # gpart show da0
=>      40  30834608  da0  GPT  (15G)
        40       128    1  freebsd-boot  (64K)
       168  12582912    2  freebsd-ufs  (6.0G)
  12583080  18251568    3  freebsd-swap  (8.7G)
```

The above commands are exactly the same as the default FreeBSD setup during installation.
- The first partition should be freebsd-boot and its size will most likely be 64k.
- The second partition is the root partition (freebsd-ufs).
- The third partition is the swap (freebsd-swap).
- The other partitions depend on your configuration.

#### k.3. Create Backup Partition

```console
root@ns4:~ # gpart backup da0 > /mnt/da0.backup
```

#### k.4. Delete Partition

```console
root@ns4:~ # gpart destroy -F /dev/da0
```

#### k.5. Recover Partition

```console
root@ns4:~ # gpart restore -F da0 < /mnt/da0.backup
```

In the recovery command, the -F option will first completely wipe the existing data from the partition table, then restore the table from the file.

The main gpart commands in man gpart have been discussed in detail. You just need to learn each command that is executed. If you have difficulty learning the gpart command, you can comment or visit the official `gpart` website directly.
