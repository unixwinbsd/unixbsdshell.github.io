---
title: Using the chmod Command in FreeBSD Granting File and Directory Permissions
date: "2025-05-01 15:25:45 +0100"
id: using-chmod-command-in-freebsd
lang: en
layout: single
author_profile: true
categories:
  - FreeBSD
tags: "SysAdmin"
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
| 04          | Udin sedunia  | 47          |
| 04          | Udin sedunia  | 47          |
| 04          | Udin sedunia  | 47          |
| 04          | Udin sedunia  | 47          |
| 04          | Udin sedunia  | 47          |




2025-05-01-using-chmod-command-in-freebsd.md


Menggunakan Perintah chmod di FreeBSD Memberikan Izin File dan Direktori




