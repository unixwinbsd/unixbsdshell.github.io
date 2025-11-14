---
title: How to Copy Move Delete Files and Directories in FreeBSD 14
date: "2025-05-03 06:55:45 +0100"
updated: "2025-05-03 06:55:45 +0100"
id: copy-move-delete-file-directory-freebsd
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: SysAdmin
background: /img/Logo.png
toc: true
comments: true
published: true
excerpt: In UNIX the command to copy files is written with the command cp which means copy. The cp command is used to copy directories and files using the command line.
keywords: copy, move, delete, cp, mv, rm, command, freebsd, shell, terminal
---

This article discusses how to use the copy move remove and rename commands on a FreeBSD system. The contents of this article can be run on almost all versions of FreeBSD. In writing this article, the FreeBSD 14 system is used.
<br/>

## 1. How to Copy Files in FreeBSD
In UNIX, the command to copy files is written with the command "cp" which means copy. The cp command is used to copy directories and files using the command line. With this command, you can transfer multiple files or folders, save attribute information, and back them up. The resulting cp command file is separate from the original file. So, it can be said that the cp command is useful for FreeBSD.

Maybe people who are new to FreeBSD still don't know how to use this command and are looking for answers on how to copy multiple files using cp in FreeBSD. That's why we wrote this article to briefly explain how to copy multiple files using the cp command in the FreeBSD system.

You can see the basic script for the cp command below.


```
cp [options] [source file] [target file]
cp [options] [source file] [target directory]
```
### 1.1. How to Copy Files From One Place to Another

```
root@ns1:~ # cp xmrig.json /usr/local/etc/xmrig
root@ns1:/usr/local/etc # cp /root/xmrig.json /usr/local/etc/xmrig
```
Both of the above commands will copy the xmrig.json file in the /root folder to the /usr/local/etc/xmrig folder.

```
root@ns1:/usr/local/etc # cp /usr/local/etc/xmrig/CMakeLists.txt /usr/local/etc/cpuminer/cpuminer.txt
root@ns1:~ # cp -R /usr/local/etc/xmrig/xmrig.json /usr/local/etc/cpuminer
```

The first command will copy the CMakeLists.txt file to the /usr/local/etc/cpuminer folder and rename the CMakeLists.txt file to the cpuminer.txt file. Meanwhile, the second command will copy the xmrig.json file in the /usr/local/etc/xmrig folder to the /usr/local/etc/cpuminer folder recursively. This means that the file and all its attributes (permissions and ownership) will be copied. The second command line is highly recommended and if you want to copy the file, use the "-R" option so that all file attributes are copied.

### 1.2. How to Copy Folders
To help you understand this command quickly, we will create a new folder and its contents. We will place the new folder in the /usr/local/etc folder and the /root folder. Follow these steps to create a folder and its contents.

#### 1.2.1. Create a training folder in /root
```
root@ns1:~ # mkdir latihan
root@ns1:~ # cd latihan
root@ns1:~/latihan # mkdir freebsd
root@ns1:~/latihan # mkdir dnsserver
root@ns1:~/latihan # mkdir webserver
root@ns1:~/latihan # touch named.conf
root@ns1:~/latihan # touch httpd.txt
root@ns1:~/latihan # touch unbound.conf
root@ns1:~/latihan # touch bind.txt
```
The above script will create folders /root/exercise, /root/exercise//freebsd, /root/exercise/dnsserver, /root/exercise/webserver and also create files in the /root/exercise folder with the names named.conf, httpd.txt, unbound.conf and bind.txt. If you are not sure, see the results with the "ls" command.


```
root@ns1:~ # ls /root/latihan
bind.txt	   freebsd		named.conf	   webserver
dnsserver	   httpd.txt	unbound.conf
```

#### 1.2.2. Create an "example" folder in /usr/local/etc

```
root@ns1:~ # mkdir /usr/local/etc/example
```

After the folder has been created, now we will practice how to copy the folder.


```
root@ns1:~ # cp /root/latihan/* /usr/local/etc/example
cp: /root/latihan/dnsserver is a directory (not copied).
cp: /root/latihan/freebsd is a directory (not copied).
cp: /root/latihan/webserver is a directory (not copied).
```

The above script only copies files, but the folder in /root/exercise is not copied. Use the "ls" command to see the contents of the /usr/local/etc/example folder.


```
root@ns1:~ # ls /usr/local/etc/example
bind.txt	httpd.txt	named.conf	unbound.conf
```

As explained earlier, the /usr/local/etc/example folder only contains files copied from /root/exercise. We continue with another method, but first we delete the files in the /usr/local/etc/example folder.

```
root@ns1:~ # rm -f /usr/local/etc/example/*
```

Once the /usr/local/etc/example folder is empty, we continue by copying the folder by adding the "-R" option.


```
root@ns1:~ # cp -R /root/latihan /usr/local/etc/example
```

The above script will copy the practice folder to the /usr/local/etc/example folder. Now let's see the contents of the /usr/local/etc/example folder.

```
root@ns1:~ # ls /usr/local/etc/example
latihan
```

The contents of the /usr/local/etc/example folder are just practice folders. Let's continue with another copy script. However, first, we delete the practice folder in the /usr/local/etc/example folder.

```
root@ns1:~ # rm -fr /usr/local/etc/example/*
```

Now try using the copy command below and see the difference with the copy command above.


```
root@ns1:~ # cp -R /root/latihan/* /usr/local/etc/example
```

The above script will copy files and folders in /root/exercise to /usr/local/etc/example. Let's see the contents of the /usr/local/etc/example folder.

```
root@ns1:~ # ls /usr/local/etc/example
bind.txt	dnsserver	freebsd		httpd.txt	named.conf	unbound.conf	webserver
```
Up to this point, do you understand how to use the copy command in FreeBSD? If you do, continue with the command to move the file "mv".

## 2. How to Move Files in FreeBSD
How to move files or move is almost the same as copying files, the difference is that in the copy command there is a "-R" option while in the move command there is no "-R" option. You can see the basic script for the move command below.

```
mv [-f | -i | -n] [-hv] source target
mv [-f | -i | -n] [-v] source ... directory
```

Using the mv script above, we will now practice how to move files in FreeBSD.

### 2.1. Moving Files Between Folders

```
root@ns1:~ # mv /root/latihan/unbound.conf /usr/local/etc/example
```
The above script simply moves the unbound.conf file to the /usr/local/etc/example folder.

### 2.2. Moving Files by Renaming

```
root@ns1:~ # mv /root/latihan/named.conf /usr/local/etc/example/cpuminer.txt
```

The above script will move the named.conf file to the /usr/local/etc/example folder, and rename the file to cpuminer.txt.

### 2.3. Move all file contents in a folder

```
root@ns1:~ # mv /root/latihan/* /usr/local/etc/example
```

The script above will move all the contents of the file from the /root/exercise folder to the /usr/local/etc folder. With the script above, the contents of the folder and files in /root/exercise will be moved. So in general, if you use this script, the /root/exercise folder will be empty.

### 2.4. Moving a Folder to Another Folder

```
root@ns1:~ # mv /root/latihan /usr/local/etc/example
```

The script above will move the training folder to the /usr/local/etc folder. When using this script, the /root/exercise folder will be moved to /usr/local/etc. So, in the /root folder there is no more training folder because it has been moved.



## 3. How to Delete Files and Folders

rm (short for remove) is a Unix command implemented in FreeBSD. The rm command is used to remove files from a file system. Typically, on most file systems, deleting a file requires write permission on the parent directory (and execute permission, to access that directory). In addition to deleting files, the rm command can also be used to remove directories/folders. Follow the steps below to remove files and directories.

### 3.1. How to Delete Files

```
root@ns1:~ # rm /root/latihan/unbound.conf
```

The above script will delete the unbound.conf file located in the /root/exercise folder.

### 3.2. Deleting Files with Confirmation

```
root@ns1:~ # rm -i /root/latihan/unbound.conf
remove /root/latihan/unbound.conf? y
```

### 3.3. How to Delete a Directory

```
root@ns1:~ # rm -rf /root/latihan
```

The above script will delete the practice folder in the /root folder.

### 3.4. Deleting Directories With Confirmation

```
root@ns1:~ # rm -I -r -f /root/latihan

recursively remove /root/latihan? y
```

### 3.5. Deleting Directory Contents

```
root@ns1:~ # rm -rf /root/latihan/*
```

The above script will delete all contents in the /root/exercise folder.


### 3.6. Deleting Files with File Letter Prefix

```
root@ns1:~ # rm /root/latihan/b*
```
The script above will delete all files in the /root/exercise folder that start with the letter "b". With the script above, all files that start with the letter "b" in the /root/exercise folder will be deleted.

### 3.7. Deleting Files with Specific Extensions

```
root@ns1:~ # rm /root/latihan/*.txt
```
The script above will delete all files in the /root/exercise folder that have the extension "txt", such as bind.txt, httpd.txt, book.txt. So everything with the extension "txt" will be deleted.

The commands "cp", "mv", and "rm" are basic and important commands in the FreeBSD system. A system administrator is required to master these commands. Because it is certain that these commands are commonly used on the FreeBSD system both when installing, configuring, and maintaining the system.
