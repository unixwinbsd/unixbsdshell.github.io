---
title: Setup FreeBSD Quota for Limiting HDD Space Usage by Users or Groups
date: "2025-07-19 07:13:21 +0100"
updated: "2025-07-19 07:13:21 +0100"
id: freebsd-quota-limiting-hdd-by-user-group
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: UnixShell
background: https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/images/Example_FreeBSD_Disk_Quota.jpg
toc: true
comments: true
published: true
excerpt: Disk Quota is designed to limit the amount of disk space used for users and user groups. Almost all operating systems have a Disk Quota application that is included when you first install the operating system
keywords: hdd, quota, limiting, gpart, disk, ssd, hard disk, command, user, group, partition, freebsd, manage, flashdisk, destroy
---

If your computer is used by many people, or for example VPS Hosting which uses one computer for many customers. So limiting storage space on the Hard Disk Drive is very important. This is to ensure that the storage space on a particular HDD or partition is not used by one user or one VPS Hosting customer, but can be used by many people. Each person or VPS Hosting customer has their own personal space to fill, and must not exceed the specified capacity. On the FreeBSD system, this is called Disk Quota.

Disk Quota is designed to limit the amount of disk space used for users and user groups. Almost all operating systems have a Disk Quota application that is included when you first install the operating system. Here we will see how to set a system running on FreeBSD to use Disk quota. Applying Disk quota on FreeBSD is not too complicated, you just need to activate Disk quota in the rc.conf file.

There's nothing wrong with that, in this article we will review the use of disk quotas in FreeBSD 13.2 to limit the amount of disk space used by each user and group. In implementing Disk Quota we will use the "ZFS" file system

To make it easier for you to learn about disk quotas in FreeBSD, see the image illustration below.

<br/>
<img alt="Example FreeBSD Disk Quota" width="99%" class="lazyload" style="display: block; margin: auto;" src="{{ 'https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/images/Example_FreeBSD_Disk_Quota.jpg' | relative_url }}">
<br/>

Before we explain the illustration in the image above, run the following command to see the hard disk partition you are using.

```console
root@ns3:~ # gpart show
=>       40  488394976  ada0  GPT  (233G)
         40       1024     1  freebsd-boot  (512K)
       1064        984        - free -  (492K)
       2048    4194304     2  freebsd-swap  (2.0G)
    4196352  484198400     3  freebsd-zfs  (231G)
  488394752        264        - free -  (132K)
```
In this article we use the ZFS partition system, which we have implemented in the FreeBSD installation process. So we will use "freebsd-zfs" to manage disk space usage for each user and group. Pay attention to the table below.

<br/>
<img alt="hard disk space limitations in freebsd" width="99%" class="lazyload" style="display: block; margin: auto;" src="{{ 'https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/images/hard_disk_space_limitations_in_freebsd.jpg' | relative_url }}">
<br/>

## 1. Create User and Group

Because users and groups are the main objects of disk quota, creating users and groups is the first step. We will divide it into 2 groups, namely "hostingjoomla" and "hostingdrupal".

```console
root@ns3:~ # pw add group hostingjoomla
root@ns3:~ # pw add group hostingdrupal
```

After that we continue by creating a user, to share disk space. First we will create a user who is in the `"hostingjoomla"` group.

```yml
root@ns3:~ # pw add user -m -n Jhon -d /usr/home/Jhon -g hostingjoomla -s /sbin/nologin -c "group Joomla"
root@ns3:~ # pw add user -m -n Mary -d /usr/home/Mary -g hostingjoomla -s /sbin/nologin -c "group Joomla"
root@ns3:~ # pw add user -m -n Jack -d /usr/home/Jack -g hostingjoomla -s /sbin/nologin -c "group Joomla"
```

We continue by creating a user in the `"hostingdrupal"` group.

```yml
root@ns3:~ # pw add user -m -n Thomas -d /usr/home/Thomas -g hostingdrupal -s /sbin/nologin -c "Hosting Drupal"
root@ns3:~ # pw add user -m -n Charles -d /usr/home/Charles -g hostingdrupal -s /sbin/nologin -c "Hosting Drupal"
root@ns3:~ # pw add user -m -n Bob -d /usr/home/Bob -g hostingdrupal -s /sbin/nologin -c "Hosting Joomla"
```


## 2. HDD Storage Space Limitations

Before we apply Disk quota to FreeBSD, you must activate Disk quota first. The convenience provided by FreeBSD, you don't need to install it. Just activate it in the "rc.conf" file. In your "/etc/rc.conf" file, type the command below.

```yml
quota_enable="YES"
```

Run Disk quota with the "service" command.

```yml
root@ns3:~ # service quota restart
```

Now your disk quota is active on the FreeBSD server. We start by dividing disk space between each user and group.

We use collection quotas to limit the amount of space that can be used by a particular dataset. Reference Quota works in much the same way, but only counts the space used by the dataset itself, excluding snapshots and child datasets. Similarly, user and group quotas can be used to prevent users or groups from using all the space in a pool or dataset.

We start with the `"hostingjoomla"` group

```yml
root@ns3:~ # zfs create -o compression=on -o mountpoint=/usr/home/Jhon zroot/usr/home/Jhon
root@ns3:~ # zfs set quota=1G zroot/usr/home/Jhon
root@ns3:~ # zfs allow -u bob send,snapshot zroot/usr/home/Jhon
```

Create links and permissions.

```yml
root@ns3:~ # mkdir -p /mnt/home
root@ns3:~ # ln -s /usr/home/Jhon /mnt/home
root@ns3:~ #  chmod 1777 /usr/home/Jhon
```

We do a test. We assume that the `"/var/test"` folder has a **"GhostBSD-23.iso"** file with a capacity of 2,883,613 KB.

```console
root@ns3:~ # cd /var/Test
root@ns3:/var/Test # ls -l
total 3256028
-rw-r--r--  1 root  wheel      438288 Oct 24 19:48 25654.pdf
-rw-r--r--  1 root  wheel      377130 Oct 24 19:48 36201.pdf
-rw-r--r--  1 root  wheel  1280627200 Oct  1 00:43 FreeBSD-13.img
-rw-r--r--  1 root  wheel  2952939520 Oct  1 00:20 GhostBSD-23.iso
-rw-r--r--  1 root  wheel      681324 Mar 21  2023 WiFi.pdf
-rw-r--r--  1 root  wheel     4765824 May 25  2023 blog.psd
-rw-r--r--  1 root  wheel     2383508 Jul 12  2023 ultimate.pdf
```

To test, we copy the **"GhostBSD-23.iso"** file to the **"/usr/home/Jhon"** folder.

```console
root@ns3:/var/Test # cp GhostBSD-23.iso /usr/home/Jhon
cp: GhostBSD-23.iso: Disc quota exceeded
```

The blue text `"Disc quota exceeded"` indicates that the file capacity exceeds the maximum quota limit

To further clarify, we limit disk capacity usage for users Mary and Thomas.

```console
root@ns3:~ # zfs create -o compression=on -o mountpoint=/usr/home/Mary zroot/usr/home/Mary
root@ns3:~ # zfs set quota=2G zroot/usr/home/Mary
root@ns3:~ # zfs allow -u Mary send,snapshot zroot/usr/home/Mary

root@ns3:~ # zfs create -o compression=on -o mountpoint=/usr/home/Mary zroot/usr/home/Thomas
root@ns3:~ # zfs set quota=4G zroot/usr/home/Thomas
root@ns3:~ # zfs allow -u Thomas send,snapshot zroot/usr/home/Thomas
```

Create links and permissions for users Mary and Thomas.

```console
root@ns3:~ # ln -s /usr/home/Mary /mnt/home
root@ns3:~ # chmod 1777 /usr/home/Mary

root@ns3:~ # ln -s /usr/home/Thomas /mnt/home
root@ns3:~ # chmod 1777 /usr/home/Thomas
```

For users Jack, Charles and Bob, just follow the guidelines that we have implemented for users John, Mary and Thomas. Because it's the same way.

With the `"zfs list"` command you can check the amount of quota used by the user. Run the following command to check quota.

```console
root@ns3:~ # zfs list -o quota zroot/usr/home/Jhon zroot/usr/home/Jhon
QUOTA
   1G

root@ns3:~ # zfs list -o quota zroot/usr/home/Mary zroot/usr/home/Mary
QUOTA
   2G

root@ns3:~ # zfs list -o quota zroot/usr/home/Thomas zroot/usr/home/Thomas
QUOTA
   4G
```

With the Disk Quota application on FreeBSD, it will make it easier for a system administrator to divide hard disk space among each user and group. We no longer worry that the hard disk is overloaded in storing data, everything has been managed properly with the help of disk quota.