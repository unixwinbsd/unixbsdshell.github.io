---
title: Using the Search File Command in FreeBSD OS
date: "2025-11-09 09:03:17 +0000"
updated: "2025-11-09 09:03:17 +0000"
id: using-search-file-command-infreebsd
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: WebServer
background: https://raw.githubusercontent.com/unixwinbsd/unixbsdshell.github.io/refs/heads/main/img/nop-25/nop-25-012.jpg
toc: true
comments: true
published: true
excerpt: The whereis command is used to find the source file location of a command and the manual section for a specific file on a FreeBSD system. If we compare the whereis command with the find command, both will look similar because both can be used for the same purpose, but the whereis command produces more accurate results in a shorter time.
keywords: search, file, which, command, copy, move, cp, freebsd, unix, bsd, whereis
---

If you're used to Windows and are new to FreeBSD, you'll likely have trouble finding files or programs. It's understandable, considering the FreeBSD server doesn't have graphics, only text and images. This contrasts with Windows, which has a graphical user interface (GUI) that makes things easier for users.

Don't worry, this article will guide you through how to find files and programs on the FreeBSD port system.
<br/>
<img alt="Command Find" width="99%" class="lazyload" style="display: block; margin: auto;" src="{{ 'https://raw.githubusercontent.com/unixwinbsd/unixbsdshell.github.io/refs/heads/main/img/nop-25/nop-25-012.jpg' | relative_url }}">
<br/>

## 1. which

A utility that allows you to search for programs in directories specified in the PATH environment variable. Generally, the PATH variable includes directories, allowing simple command-line instructions to be invoked. In other words, programs invoked from the command line are first searched through these directories.

Searching with this command is very fast. If you want to know where a program is located, it's best to use the which command. Here's an example of using which.

```console
root@ns1:~ # which cp
/bin/cp
```

The script above will search for the `"cp"` program, which is typically used to copy files or directories. The search results show that the `"cp"` program is located in the `/bin` directory.

```console
root@ns1:/bin # which gmake
/usr/local/bin/gmake
```

The script description above is used to search for the `"gmake"` program, and the `"gmake"` program is in the `/usr/local/bin` folder.

## 2. whereis

The whereis command is used to find the location of source/binary files for commands and manual sections for specific files on a FreeBSD system. If we compare the whereis command with the find command, they will appear similar because both can be used for the same purpose, but the whereis command produces more accurate results in a shorter time. Whereis does not require root privileges to run.

The following is an example of using the whereis program.

```console
root@ns1:~ # whereis squid
squid: /usr/ports/www/squid
```

In the example script above, it will search for a program named squid, after searching with the whereis command, the squid program is found in the `/usr/ports/www` folder.

```console
root@ns1:~ # whereis cp
cp: /bin/cp /usr/share/man/man1/cp.1.gz /usr/ports/emulators/linux_base-c7/work/linux_base-c7-7.9.2009_1/usr/bin/cp
```

The script above is used to search for the `"cp"` program, which is found in the `/bin`, `/usr/share/man/man1`, `/usr/ports/emulators/linux_base-c7/work/linux_base-c7-7.9.2009_1 /usr/bin` folders.

Another example of using the whereis command.

```console
root@ns1:~ # whereis -s date
date: /usr/ports/devel/date
```

```console
root@ns1:~ # whereis -b gunzip
gunzip: /usr/bin/gunzip
```

```console
root@ns1:~ # whereis -B /bin -f ls gcc
ls: /bin/ls /usr/share/man/man1/ls.1.gz /usr/ports/emulators/linux_base-c7/work/linux_base-c7-7.9.2009_1/usr/bin/ls
gcc: /usr/ports/lang/gcc
```

## 3. locate

The locate command is a Unix utility used to quickly find files and directories. This command is an easier and more efficient alternative to the whereis command, which is more aggressive and takes longer to complete searches.

The following is an example of using the `"locate"` command.

```console
root@ns1:~ # locate mysql
/usr/ports/www/mod_auth_mysql_another/Makefile
/usr/ports/www/mod_auth_mysql_another/distinfo
/usr/ports/www/mod_auth_mysql_another/files
/usr/ports/www/mod_auth_mysql_another/files/patch-mod__auth__mysql.c
/usr/ports/www/mod_auth_mysql_another/pkg-descr
/usr/ports/www/mysqlphp2postgres
/usr/ports/www/mysqlphp2postgres/Makefile
/usr/ports/www/mysqlphp2postgres/distinfo
/usr/ports/www/mysqlphp2postgres/pkg-descr
/usr/ports/www/p5-Apache-DBI/work/Apache-DBI-1.12/t/10mysql.t
/usr/ports/www/redmine50/files/mysql.rb
/usr/ports/www/seahub/files/patch-scripts_setup-seafile-mysql.py
/var/cache/pkg/mysql80-client-8.0.32_3.pkg
/var/cache/pkg/mysql80-client-8.0.32_3~b3289f6af7.pkg
/var/cache/pkg/mysql80-server-8.0.32_3.pkg
/var/cache/pkg/mysql80-server-8.0.32_3~8cf22267e9.pkg
/var/cache/pkg/p5-DBD-mysql-4.050_1.pkg
/var/cache/pkg/p5-DBD-mysql-4.050_1~a910b341b7.pkg
/var/cache/pkg/php82-mysqli-8.2.7.pkg
/var/cache/pkg/php82-mysqli-8.2.7~6b3735262c.pkg
/var/db/mysql
/var/db/mysql_secure
/var/db/mysql_tmpdir
/var/db/ports/databases_mysql80-client
/var/db/ports/databases_mysql80-client/options
/var/db/ports/databases_mysql80-server
/var/db/ports/databases_mysql80-server/options
/var/db/ports/databases_p5-DBD-mysql
/var/db/ports/databases_p5-DBD-mysql/options
/var/db/ports/databases_php82-mysqli
/var/db/ports/databases_php82-mysqli/options
/var/mail/mysql
```

```console
root@ns1:~ # locate mysql | less
/usr/local/include/php/ext/mysqlnd/mysqlnd_alloc.h
/usr/local/include/php/ext/mysqlnd/mysqlnd_auth.h
/usr/local/include/php/ext/mysqlnd/mysqlnd_ext_plugin.h
/usr/local/include/php/ext/mysqlnd/mysqlnd_libmysql_compat.h
/usr/local/include/php/ext/mysqlnd/mysqlnd_plugin.h
/usr/local/include/php/ext/mysqlnd/mysqlnd_portability.h
/usr/local/include/php/ext/mysqlnd/mysqlnd_priv.h
/usr/local/include/php/ext/mysqlnd/mysqlnd_protocol_frame_codec.h
/usr/local/include/php/ext/mysqlnd/mysqlnd_ps.h
/usr/local/include/php/ext/mysqlnd/mysqlnd_read_buffer.h
/usr/local/include/php/ext/mysqlnd/mysqlnd_result.h
/usr/local/include/php/ext/mysqlnd/mysqlnd_result_meta.h
/usr/local/include/php/ext/mysqlnd/mysqlnd_reverse_api.h
```

```console
root@ns1:~ # locate -c mysql
64818
```

## 4. find

The find command is used to recursively search for various files within a file system directory. The `"find"` command can select files or directories based on the keys and parameters you specify. This command is slower than other search commands, but its capabilities are remarkable.

Using the `"find"` command is a very basic but important FreeBSD lesson. The `"find"` command is very useful and can greatly enhance your work. Find not only searches for specific files, but also for files or directories that match certain criteria such as size, permissions, and type.

Although `"find"` doesn't have a specific command for searching file contents, and there's no specific key for searching files, you can apply its constructs.

In this quick tutorial, we'll use the `"find"` command with a few examples. We'll search for files or directories with a specific string in their name, for a specific file or directory type. We'll also search for files larger, smaller, or within a specific size, and we'll also search for files with specific permissions.

Take a look at the following examples for searching for files.

```console
root@ns1:~ # find / -type f -name "apache24"
root@ns1:~ # find / -type f -name "index.php"
```

Searching for directory

```console
root@ns1:~ # find / -type d -name "mysql"
root@ns1:~ # find / -type d -name "phpmyadmin"
root@ns1:~ # find / -type d -perm -1000 -ls
```

Search for files in a specified directory.

```console
root@ns1:~ # find /usr/local/etc -name "php.ini"
root@ns1:~ # find /usr/local/bin -name "php"
```

In this article, we've covered the which, whereis, and locate commands, which are valuable tools for quickly finding files and directories.

These utilities utilize databases to enable fast and efficient searches, making them ideal for finding files within large file systems.

Overall, mastering these commands and their various options can save you time and effort when searching for specific files or directories within a FreeBSD system.
