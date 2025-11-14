---
title: Using the chmod Command in FreeBSD Granting File and Directory Permissions
date: "2025-05-01 15:25:45 +0100"
updated: "2025-05-01 15:25:45 +0100"
id: using-chmod-command-in-freebsd
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: SysAdmin
background: /img/Logo.png
toc: true
comments: true
published: true
excerpt: The chmod command is used to change the read, write, and execute permissions on a file or directory. Read permission, as it applies to files, means the ability to read the contents of the file.
keywords: chown, chmod, freebsd, shell, command, rw, 0600, 0777
---

This article discusses how to use the chmod and chown commands on a FreeBSD system. The contents of this article can be run on almost all versions of FreeBSD. In writing this article, the FreeBSD 13.2 system is used.

## 1. Chmod Command

The chmod command is used to change the read, write, and execute permissions on a file or directory. Read permission, as it applies to a file, means the ability to read the contents of the file. Read permission, as it applies to a directory, means the ability to list its contents (files or anything in the directory). Write permission, as it applies to files and directories, means the ability to change or delete its contents. Execute permission, as it applies to files, means the ability to load and run application programs.

By executing permission or permission, as it applies to a directory, means the ability to navigate with the cd command. Just like the chown command, you must be the superuser or owner of the file you want to change for this command to work.

On a FreeBSD system, each file and directory has a set of permissions and several utilities are provided to view and change those permissions. Understanding how file permissions work is necessary to ensure that users can access the files they need and cannot improperly access files that are used by the operating system or belong to other users.

FreeBSD, as a direct descendant of BSD UNIX, is based on several key UNIX concepts. The first and most prominent is that FreeBSD is a multi-user operating system. It can handle multiple users all working simultaneously on completely unrelated tasks. It is responsible for properly sharing and managing the demands of hardware, peripherals, memory, and CPU time among each user.

## 2. Permission Values

Because the system is capable of supporting multiple users, everything the system manages has a set of permissions that govern who can read, write, and execute resources. A total of nine bits represent the permissions on a file or directory. The nine bits are then divided into 3 octets so that they become 3 parts.

1. Permissions granted to the file owner (user).
2. Permissions granted to the group.
3. Permissions granted to others.

Permissions are stored in the file's inode mode field. Every user must have permission to change or modify a file.

| Value       | Permission          | Directory Listing        | 
| ----------- | -----------   | ----------- |
| 0          | No read, no write, no execute          | ---          |
| 1          | No read, no write, execute      | --x          |
| 2          | No read, write, no execute     | -w-          |
| 3          | No read, write, execute  | -wx          |
| 4          | Read, no write, no execute  | r--          |
| 5          | Read, no write, execute  | r-x          |
| 6          | Read, write, no execute  | rw-          |
| 7          | Read, write, execute  | rwx          |

## 3. Symbolic Permissions

Symbolic permissions, sometimes referred to as symbolic expressions, use characters instead of octal values ​​to assign permissions to a file or directory. Symbolic expressions use the syntax (who) (action) (permission), which provides the following values.

| Option       | Letter          | Represents        | 
| ----------- | -----------   | ----------- |
| (who)          | u          | User (owner)          |
| (who)          | g      | Group          |
| (who)          | o     | Other          |
| (who)          | a  | All (user, group, and other)          |
|           |   |           |
| (operation)          | +  | Increase permissions          |
| (operation)          | -  | Removing permissions          |
| (operation)          | =  | Setting permissions explicitly          |
|           |   |           |
| (permissions)          | r  | Read          |
| (permissions)          | w  | Write          |
| (permissions)          | x  | Execute          |
| (permissions)          | t  | Sticky bit          |
| (permissions)          | s  | Set UID or GID          |

To see a long directory listing that includes columns with information about file permissions for the owner, file permissions for the group, and file permissions for everyone else, try looking at the contents of the /root directory below.

```
root@ns1:~ # ls -l
total 51
drwxr-xr-x  2 root  wheel      3 Aug  3 13:25 .config
-rw-r--r--  2 root  wheel   1023 Apr  7 11:19 .cshrc
-rw-r--r--  1 root  wheel     80 Apr  7 11:29 .k5login
-rw-r--r--  1 root  wheel    328 Apr  7 11:19 .login
-rw-r--r--  2 root  wheel    507 Apr  7 11:19 .profile
-rw-r--r--  1 root  wheel   1186 Apr  7 11:19 .shrc
drwx------  2 root  wheel      3 Jul 26 06:36 .ssh
drwxr-xr-x  5 root  wheel     10 Aug  3 21:51 latihan
-rw-r--r--  1 root  wheel      0 Aug  3 16:23 xmrig.json
```

## 4. How to Use chmod

To further deepen the discussion of the chmod command, here are some examples of how to use the chmod command.

Removing the write permission of the xmrig.json file.

```
root@ns1:~ # chmod -w xmrig.json
-r--r--r--  1 root  wheel      0 Aug  3 16:23 xmrig.json
```

Enable read, write, and execute mode permissions, and disable the set-user-ID bit, set-group-ID bit, and sticky bit attributes in the xmrig.json file. (This command is almost the same as 777).

```
root@ns1:~ # chmod a=rwx xmrig.json
-rwxrwxrwx  1 root  wheel      0 Aug  3 16:23 xmrig.json
```

Remove write permission for others on the xmrig.json file.

```
root@ns1:~ # chmod o-w xmrig.json
-rwxrwxr-x  1 root  wheel      0 Aug  4 09:23 xmrig.json
```

Grants the xmrig.json file execution permission for the group.

```
root@ns1:~ # chmod g=x xmrig.json
-rwx--xr-x  1 root  wheel      0 Aug  4 09:23 xmrig.json
```

Does not grant permission to read the xmrig.json file for the user (owner).

```
root@ns1:~ # chmod u-r xmrig.json
--wx--xr-x  1 root  wheel      0 Aug  4 09:23 xmrig.json
```

Give group read/write/execute permissions to the /root/latihan directory. The following files and their subdirectories.

```
root@ns1:~ # chmod -R g+rwx /root/latihan
```

Give the group read and execute permissions to the /root/latihan folder.

```
root@ns1:~ # chmod g=rx /root/latihan
drwxr-xr-x  5 root  wheel     10 Aug  3 21:51 latihan
```

So that you understand better how to use the chmod command, look at the example below.

```
root@ns1:~ # chmod 644 xmrig.json
-rw-r--r--  1 root  wheel      0 Aug  4 09:23 xmrig.json
```

The chmod 644 xmrig.json script has meaning.
1. Give read and write permissions to the xmrig.json file for the user (owner).
2. Give read permission only to the xmrig.json file for the group.
3. Give read-only permissions to the xmrig.json file for other people.

```
root@ns1:~ # chmod 755 xmrig.json
-rwxr-xr-x  1 root  wheel      0 Aug  4 09:23 xmrig.json
```

The script chmod 755 xmrig.json has meaning
1. Give read, write and execute permissions to the xmrig.json file for the user (owner)
2. Grant read and execute permissions to the xmrig.json file for the group
2. Give read and execute permissions to the xmrig.json file to other people

```
root@ns1:~ # chmod 450 xmrig.json
-r--r-x---  1 root  wheel      0 Aug  4 09:23 xmrig.json
```

The chmod 450 script has meaning.
1. Give read permission only to the xmrig.json file for the user (owner).
2. Grant read and execute permissions to the xmrig.json file for the group.
3. Do not give read, write and execute permissions to the xmrig.json file to other people.

From all the examples described above, you most likely already understand how to use the chmod command on FreeBSD. If you don't understand, please read other articles that discuss chmod to deepen your knowledge of the chmod command.
