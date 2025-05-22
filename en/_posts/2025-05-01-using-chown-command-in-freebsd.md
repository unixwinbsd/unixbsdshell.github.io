---
title: Using the Chown Command in FreeBSD
date: "2025-05-01 08:15:35 +0100"
id: using-chown-command-in-freebsd.md
lang: en
layout: single
author_profile: true
categories:
  - FreeBSD
tags: "SysAdmin"
excerpt: Managing file and directory ownership is very important when working with the FreeBSD operating system. Correct use of the chown command can prevent unwanted users from making changes to your files.
keywords: chown, chmod, freebsd, shell, command, rw
---

Managing file and directory ownership is very important when working with the FreeBSD operating system. Proper use of the chown command can prevent unwanted users from making changes to your files and help keep them safe from unauthorized outsiders.

The chown command is used to change file ownership and group information. We run the chmod command to change file permissions such as read, write, and access. If you are using a FreeBSD system, there may be times when you want to change the ownership and group-related information for a file or directory, chown is the basic command to accomplish this task. Therefore chown is often referred to as "File Ownership".

As we know, UNIX-based systems like FreeBSD are capable of running a large number of users and groups at the same time. Each different user and group in the FreeBSD operating system has ownership and permissions to ensure that files are safe and limit who can change the contents of those files.

In the FreeBSD operating system, there are many users and groups that use the system simultaneously. We can classify each user and user group of the system based on their rights and duties, including:
- **Root User:** Often called super user is a person who has access to all directories and files on the operating system and can run all operating commands on the system. The important thing to note is that only root users can change access rights or ownership of files that are not theirs. So root users are people who have full control over the operating system.
- **Regular User:** Regular users or guest users, only have limited access to files and directories and can only change files that they own. For Regular Users, access rights to files in the system are set by the Root User.

This article will explain how to use the "chown" command on the FreeBSD operating system. You can also apply this chown command to various operating systems such as Ubuntu, Centos, Debian, and others that use UNIX-like operating systems.

You can see the basic script for the chown command in the "FreeBSD System Administrator's Guide", as follows.

```
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

Since the chown command is used to change the ownership and group of a file, we simply write the chown command script as follows.

```
chown owner-user namafile
chown owner-user:owner-group namafile
chown owner-user:owner-group namadirectory
chown options owner-user:owner-group namafile
```

Here is an example of using the chown command. In this example we will use the xmrig.json file, pay attention to the user and group that owns the file.

```
root@ns1:~ # ls -l
-r--r-x---  1 root  wheel         0 Aug  4 09:23 xmrig.json
```

In the xmrig.json file example above, owner-user: root and owner-group: wheel. Now we give the chown command to the file. But first we will create the user and group beforehand. In this case we will create a user: gunung and group: semeru. Consider the following example to create a user and group "gunung semeru".

```
root@ns1:~ # pw add group semeru
root@ns1:~ # pw add user -n gunung -g semeru -s /sbin/nologin -c "gunung"
```

After we create the “Gunung Semeru” user and group, now we continue by giving file and group ownership rights to the xmrig.json file.

```
root@ns1:~ # chown gunung xmrig.json
```

Now let's see the changes,

```
root@ns1:~ # ls -l
-r--r-x---  1 gunung  wheel         0 Aug  4 09:23 xmrig.json
```

owner-user has changed and root becomes "mountain". Then how to change owner-group, here is an example of how to change owner-group.

```
root@ns1:~ # chown :semeru xmrig.json
root@ns1:~ # ls -l
-r--r-x---  1 gunung  semeru         0 Aug  4 09:23 xmrig.json
```

The script above has changed the owner-group from wheel to semeru, easy right? Now let's practice again to change the owner-user and owner-group of the putty.exe file.

```
root@ns1:~ # ls -l
-rw-r--r--  1 root    wheel          0 Aug 11 07:28 putty.exe
```

The original user-owner and group-owner files of the putty.exe file before the chown command. Now we will give the chown command to the user-owner and group-owner files. You will see the changes.

```
root@ns1:~ # chown gunung:rinjani putty.exe
root@ns1:~ # ls -l
-rw-r--r--  1 gunung  rinjani   1647912 Feb 11 22:09 putty.exe
```

The user-owner and group-owner of the putty.exe file have changed from root:wheel to gunung:rinjani. Now, do you understand how to use the chown command? To better understand it, we will practice the chown command in a directory/folder. Pay attention to the information from the following practice folder.

```
root@ns1:~ # ls -l
drwxr-xr-x  5 root    wheel         10 Aug  3 21:51 folderlatihan
```

Now we use the chown command,

```
root@ns1:~ # chown danau:ranukumbolo folderlatihan
root@ns1:~ # ls -l
drwxr-xr-x  2 danau   ranukumbolo         2 Aug 11 07:39 folderlatihan
```

Another example, we will create a new folder named "learning folder" in the /usr/local/etc directory.

```
root@ns1:/usr/local/etc # mkdir -p /usr/local/etc/folderbelajar
root@ns1:/usr/local/etc # ls -l
drwxr-xr-x   2  root     wheel       2 Aug 11 07:44 folderbelajar
```

Give the chown command to the /usr/local/etc/learning folder.

```
root@ns1:/usr/local/etc # chown gunung:semeru /usr/local/etc/folderbelajar
root@ns1:/usr/local/etc # ls -l
drwxr-xr-x   2 gunung   semeru       2 Aug 11 07:44 folderbelajar
```

To make it clearer, I will give one more example.

```
root@ns1:~ # chown -R www:www /usr/local/www/apache24
root@ns1:~ # ls -l /usr/local/www
drwxr-xr-x   6 www  www   6 Aug  1 20:15 apache24
```

The -R option above will change the ownership of the directory and its contents recursively.

With the article above, hopefully you can understand the chown command and its application on the FreeBSD system. What you need to pay attention to is the writing of capital and lowercase letters, because almost all Shell Command-based commands are case sensitive, if you are wrong in writing capital and lowercase letters, the command you use will not work.
