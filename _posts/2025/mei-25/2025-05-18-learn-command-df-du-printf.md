---
title: Learn FreeBSD Commands df du and printf
date: "2025-05-18 11:45:35 +0100"
updated: "2025-05-18 11:45:35 +0100"
id: learn-command-df-du-printf
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: SysAdmin
background: /img/Logo.png
toc: true
comments: true
published: true
excerpt: The du and df commands are two basic commands in FreeBSD that are often run by system administrators. In this article we will learn how to use the df, du, and printf commands.
keywords: freebsd, file, command, dd, du, printf, shell, kernel
---

The du and df commands are two basic commands in FreeBSD that are often run by system administrators. In this article, we will learn how to use the df, du, and printf commands. All content in this article is implemented using the FreeBSD 13.2 system.

## A. df Command

The df command is used to show the amount of free disk space on a file system. df reports how much disk space is used on a file system. The df command displays the amount of disk space available on a file system with each file name as an argument. For more details, see the following example.

```
root@ns1:~ # df
Filesystem         1K-blocks    Used     Avail Capacity  Mounted on
zroot/ROOT/default 223550888 7345232 216205656     3%    /
devfs                      1       1         0   100%    /dev
linprocfs                  4       4         0   100%    /compat/linux/proc
linsysfs                   4       4         0   100%    /compat/linux/sys
tmpfs                2245952       4   2245948     0%    /compat/linux/dev/shm
fdescfs                    1       1         0   100%    /dev/fd
procfs                     4       4         0   100%    /proc
zroot/tmp          216425096  219440 216205656     0%    /tmp
zroot/var/log      216206340     684 216205656     0%    /var/log
zroot/usr/ports    225758656 9553000 216205656     4%    /usr/ports
zroot/var/mail     216205784     128 216205656     0%    /var/mail
zroot/var/tmp      216205760     104 216205656     0%    /var/tmp
zroot/compat       216550388  344732 216205656     0%    /compat
zroot              216205752      96 216205656     0%    /zroot
zroot/var/crash    216205752      96 216205656     0%    /var/crash
zroot/usr/home     216206524     868 216205656     0%    /usr/home
zroot/var/audit    216205752      96 216205656     0%    /var/audit
zroot/usr/src      216205752      96 216205656     0%    /usr/src
devfs                      1       1         0   100%    /compat/linux/dev
fdescfs                    1       1         0   100%    /compat/linux/dev/fd
```

In the example, df is first called with no arguments. The default action is to display the used and free file space in blocks. In this particular case, the block size is 1K-blocks as shown in the output.

The first column displays the name of the disk partition or file system used by each directory, such as zroot/tmp, zroot/var/log, zroot/usr/ports, zroot/var/mail, zroot/var/tmp, and other directories. The second column shows the total space, allocated blocks, and available blocks. The third column shows the amount of capacity used as a percentage of the total file system capacity.

The Avail column is the amount of disk space available, the Capacity pool is the capacity used by the file system calculated as a percentage, and the last column shows where the file system is installed. This column is the directory where the file system is installed or placed in the file system tree.

You can see another example of the df command in the following script.

```
root@ns1:~ # df -i
Filesystem         1K-blocks    Used     Avail Capacity iused      ifree %iused  Mounted on
zroot/ROOT/default 223550912 7345248 216205664     3%  345029  432411328    0%   /
devfs                      1       1         0   100%       0          0     -   /dev
linprocfs                  4       4         0   100%       1          0  100%   /compat/linux/proc
linsysfs                   4       4         0   100%       1          0  100%   /compat/linux/sys
tmpfs                2301624       4   2301620     0%       1 2147483646    0%   /compat/linux/dev/shm
fdescfs                    1       1         0   100%       4      50343    0%   /dev/fd
procfs                     4       4         0   100%       1          0  100%   /proc
zroot/tmp          216425104  219440 216205664     0%     280  432411328    0%   /tmp
zroot/var/log      216206348     684 216205664     0%      47  432411328    0%   /var/log
zroot/usr/ports    225758664 9553000 216205664     4%  762640  432411328    0%   /usr/ports
zroot/var/mail     216205792     128 216205664     0%      26  432411328    0%   /var/mail
zroot/var/tmp      216205768     104 216205664     0%      10  432411328    0%   /var/tmp
zroot/compat       216550396  344732 216205664     0%    6111  432411328    0%   /compat
zroot              216205760      96 216205664     0%       7  432411328    0%   /zroot
zroot/var/crash    216205760      96 216205664     0%       8  432411328    0%   /var/crash
zroot/usr/home     216206532     868 216205664     0%      57  432411328    0%   /usr/home
zroot/var/audit    216205760      96 216205664     0%       9  432411328    0%   /var/audit
zroot/usr/src      216205760      96 216205664     0%       7  432411328    0%   /usr/src
devfs                      1       1         0   100%       0          0     -   /compat/linux/dev
fdescfs                    1       1         0   100%       4      50343    0%   /compat/linux/dev/fd
```

In the second example, df is called with the -i option. This option tells df to display information about inodes rather than block files.

If the output from the above script is too long and makes it difficult for you to read the meaning of each column, use the command below to make it easier for you to read the file system.

```
root@ns1:~ # df -h
Filesystem            Size    Used   Avail Capacity  Mounted on
zroot/ROOT/default    213G    7.0G    206G     3%    /
devfs                 1.0K    1.0K      0B   100%    /dev
linprocfs             4.0K    4.0K      0B   100%    /compat/linux/proc
linsysfs              4.0K    4.0K      0B   100%    /compat/linux/sys
tmpfs                 2.2G    4.0K    2.2G     0%    /compat/linux/dev/shm
fdescfs               1.0K    1.0K      0B   100%    /dev/fd
procfs                4.0K    4.0K      0B   100%    /proc
zroot/var/log         206G    684K    206G     0%    /var/log
zroot/usr/ports       215G    9.1G    206G     4%    /usr/ports
zroot/var/mail        206G    128K    206G     0%    /var/mail
zroot/var/tmp         206G    104K    206G     0%    /var/tmp
zroot/compat          207G    337M    206G     0%    /compat
zroot                 206G     96K    206G     0%    /zroot
zroot/var/crash       206G     96K    206G     0%    /var/crash
zroot/usr/home        206G    868K    206G     0%    /usr/home
zroot/var/audit       206G     96K    206G     0%    /var/audit
zroot/usr/src         206G     96K    206G     0%    /usr/src
devfs                 1.0K    1.0K      0B   100%    /compat/linux/dev
fdescfs               1.0K    1.0K      0B   100%    /compat/linux/dev/fd
```

Below are the df commands that are often used by system administrators.

```
root@ns1:~ # df -h /
Filesystem            Size    Used   Avail Capacity  Mounted on
zroot/ROOT/default    213G    7.0G    206G     3%    /
```

```
root@ns1:~ # df -ih
root@ns1:~ # df -a
```

## B. The du command

The du command or du command is an abbreviation of Disk Usage. du is used to check disk usage information for files and directories on the system. The du command will display all file names along with their respective sizes. By default the size given is written in kilobytes. The file name is used as an argument to get the file size.

The basic script for the du command is:

du [options] [directory/file]

The following is a description of the du command options:
- du -a : View all file and directory sizes.
- du -h : Display user-readable format.
- du -c : Display total output.
- du -s : Display only total count.
- du -0/td> : Final output with null bytes.
- du --block-size=<size> : Specify block size.
- du --time : Display modification time.

The following is an implementation of the du command:

```
root@ns1:~ # du
root@ns1:~ # du -a
root@ns1:~ # du -h
root@ns1:~ # du -c
```


## C. Printf command

On Unix-like operating systems like FreeBSD, the printf command is used to insert arguments into a user-defined text string, thus producing formatted output. In other words, we can say that printf is the successor to the echo command.

Basic script of printf command.

printf [format] [arguments]

Here is how to use the printf command.

**1. Create a file named /tmp/example.sh and type the script below in the file /tmp/example.sh**

```
root@ns1:~ # ee /tmp/contoh.sh
#!/bin/sh

# take user name
printf "Enter name: "
read name

# take user score
printf "Enter score: "
read score

# display result
echo "---Result---"
printf "Name: %s\n" "$name"
printf "Score: %d\n" "$score"

```

```
root@ns1:~ # chmod +x /tmp/contoh.sh
```

**2. Run the file /tmp/example.sh**


```
root@ns1:~ # cd /tmp
root@ns1:/tmp # ./contoh.sh
Enter name: gunung argopuro
Enter score: 100
---Result---
Name: gunung argopuro
Score: 100
```


**Another example of using printf.**
1. Create a file with the name /tmp/gunungargopuro.sh, then enter the script as in the example below.
2. Run the file /tmp/gunungargopuro.sh.

```
root@ns1:~ # ee /tmp/gunungargopuro.sh
#!/bin/sh

num=100

# output in decimal, octal, hex form
printf "Decimal: %d\n" "$num"
printf "Octal: %o\n" "$num"
printf "Hex: %X\n" "$num"
```

```
root@ns1:~ # chmod +x /tmp/gunungargopuro.sh
```

The output or result of the output file /tmp/gunungargopuro.sh.

```
root@ns1:~ # cd /tmp
root@ns1:/tmp # ./gunungargopuro.sh
Decimal: 100
Octal: 144
Hex: 64
```

The three commands above are basic commands in FreeBSD and you must master them if you want to jump straight in as a network system administrator or for those of you who want to deepen your knowledge of the UNIX BSD system.
