---
title: Guide to Using the Chown Command in FreeBSD
date: "2025-07-12 08:55:21 +0100"
updated: "2025-07-12 08:55:21 +0100"
id: using-chown-command-freebsd
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: UnixShell
background: /img/Logo.png
toc: true
comments: true
published: true
excerpt: The chown command is used to change file ownership and group information. We run the chmod command to change file permissions, such as read, write, and access. If you're using a FreeBSD system, there may be times when you want to change the ownership and group information for a file or directory
keywords: chown, command, freebsd, shell, unix, chmod, ownership, permissions
---

Managing file and directory ownership is crucial when working with the FreeBSD operating system. Proper use of the chown command can prevent unauthorized users from making changes to your files and help keep them safe from unauthorized outsiders.

The chown command is used to change file ownership and group information. We run the chmod command to change file permissions, such as read, write, and access. If you're using a FreeBSD system, there may be times when you want to change the ownership and group information for a file or directory. Chown is the basic command for accomplishing this task. This is why chown is often referred to as "File Ownership."

As we know, UNIX-based systems like FreeBSD can run a large number of users and groups simultaneously. Each user and group in the FreeBSD operating system has ownership and permissions to ensure file security and limit who can change their contents.

In the FreeBSD operating system, there are many users and groups using the system simultaneously. We can classify each user and user group based on their rights and responsibilities, including:
- `Root User:` Often referred to as a superuser, a user has access to all directories and files in the operating system and can execute all system commands. It's important to note that only the root user can change the access rights or ownership of files that aren't theirs. Therefore, the root user has full control over the operating system.
- `Regular User:` Regular users, or guest users, have limited access to files and directories and can only modify files they own. For regular users, system file access is controlled by the root user.
This article will explain how to use the "chown" command on the FreeBSD operating system. You can also use this chown command on various operating systems, such as Ubuntu, CentOS, Debian, and other UNIX-like operating systems.

You can find a basic script for the chown command in the "FreeBSD System Administrator's Guide," as follows.


```console
NAME
     chown – change file owner and group

SYNOPSIS
     chown [-fhvx] [-R [-H | -L | -P]] owner[:group] file ...
     chown [-fhvx] [-R [-H | -L | -P]] :group file ...

DESCRIPTION
     The chown utility changes the user ID and/or the group ID of the
     specified files.  Symbolic links named by arguments are silently left
     unchanged unless -h is used.

     The options are as follows:

     -H      If the -R option is specified, symbolic links on the command line are followed and hence unaffected by the command.  (Symbolic links encountered during traversal are not followed.)

     -L      If the -R option is specified, all symbolic links are followed.

     -P      If the -R option is specified, no symbolic links are followed. This is the default.

     -R      Change the user ID and/or the group ID of the file hierarchies rooted in the files, instead of just the files themselves. Beware of unintentionally matching the “..” hard link to the parent directory when using wildcards like “.*”.

     -f      Do not report any failure to change file owner or group, nor modify the exit status to reflect such failures.

     -h      If the file is a symbolic link, change the user ID and/or the group ID of the link itself.

     -v      Cause chown to be verbose, showing files as the owner is modified.  If the -v flag is specified more than once, chown will print the filename, followed by the old and new numeric user/group ID.

     -x      File system mount points are not traversed.
```

Since the chown command is used to change the ownership and group of a file, we can simply write the chown command script as follows.

```console
chown owner-user namafile
chown owner-user:owner-group namafile
chown owner-user:owner-group namadirectory
chown options owner-user:owner-group namafile
```

Here's an example of using the chown command. In this example, we'll use the xmrig.json file. Note the user and group that own the file.

```console
root@ns1:~ # ls -l
-r--r-x---  1 root  wheel         0 Aug  4 09:23 xmrig.json
```

In the xmrig.json file example above, the owner-user is root and the owner-group is wheel. Now, let's chown the file. But first, we'll create a user and group. In this case, we'll create the user: `gunung` and the group: `semeru`. Consider the following example to create the user and group "gunung semeru".

```console
root@ns1:~ # pw add group semeru
root@ns1:~ # pw add user -n gunung -g semeru -s /sbin/nologin -c "gunung"
```

After we create the user and group “Gunung Semeru”, now we continue by giving file and group ownership rights to the `xmrig.json` file.


```console
root@ns1:~ # chown gunung xmrig.json
```

Now let's see the changes,

```console
root@ns1:~ # ls -l
-r--r-x---  1 gunung  wheel         0 Aug  4 09:23 xmrig.json
```

The owner-user has changed, and root has become "gunung." So, how do you change the owner-group? Here's an example of how to change the owner-group.


```console
root@ns1:~ # chown :semeru xmrig.json
root@ns1:~ # ls -l
-r--r-x---  1 gunung  semeru         0 Aug  4 09:23 xmrig.json
```

The script above has changed the owner-group from wheel to semeru. Easy, isn't it? Now let's practice changing the owner-user and owner-group of the putty.exe file.

```console
root@ns1:~ # ls -l
-rw-r--r--  1 root    wheel          0 Aug 11 07:28 putty.exe
```

The original user-owner and group-owner files of putty.exe before the chown command. Now we'll chown the user-owner and group-owner files. You should see the changes.

```console
root@ns1:~ # chown gunung:rinjani putty.exe
root@ns1:~ # ls -l
-rw-r--r--  1 gunung  rinjani   1647912 Feb 11 22:09 putty.exe
```

The user-owner and group-owner of the putty.exe file have changed from `root:wheel` to `gunung:rinjani`. Now, do you understand how to use the chown command? To better understand it, we'll practice using the chown command in a directory/folder. Note the information from the practice folder below.

```console
root@ns1:~ # ls -l
drwxr-xr-x  5 root    wheel         10 Aug  3 21:51 folderlatihan
```

Now we use the chown command,

```console
root@ns1:~ # chown danau:ranukumbolo folderlatihan
root@ns1:~ # ls -l
drwxr-xr-x  2 danau   ranukumbolo         2 Aug 11 07:39 folderlatihan
```

Another example, we will create a new folder named "folderbelajar" in the `/usr/local/etc` directory.

```console
root@ns1:/usr/local/etc # mkdir -p /usr/local/etc/folderbelajar
root@ns1:/usr/local/etc # ls -l
drwxr-xr-x   2  root     wheel       2 Aug 11 07:44 folderbelajar
```

Issue the chown command to the `/usr/local/etc/folderbelajar` folder.

```console
root@ns1:/usr/local/etc # chown gunung:semeru /usr/local/etc/folderbelajar
root@ns1:/usr/local/etc # ls -l
drwxr-xr-x   2 gunung   semeru       2 Aug 11 07:44 folderbelajar
```

To make it clearer, I will give one more example.

```console
root@ns1:~ # chown -R www:www /usr/local/www/apache24
root@ns1:~ # ls -l /usr/local/www
drwxr-xr-x   6 www  www   6 Aug  1 20:15 apache24
```

The -R option above will recursively change ownership of the directory and its contents.

With this article, hopefully, you understand the chown command and its application on FreeBSD systems. Pay attention to capitalization and lowercase letters, as almost all shell commands are case-sensitive. If you misspell a letter, the command you're using won't work.