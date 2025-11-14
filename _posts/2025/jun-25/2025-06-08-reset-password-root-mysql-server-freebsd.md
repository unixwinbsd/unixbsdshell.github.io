---
title: How to Reset Root Password on MySQL Database Server
date: "2025-06-08 10:20:35 +0100"
updated: "2025-06-08 10:20:35 +0100"
id: reset-password-root-mysql-server-freebsd
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: DataBase
background: /img/Logo.png
toc: true
comments: true
published: true
excerpt: If you forget or lose the MySQL or MariaDB root user password, you can access your data by resetting the lost password. This requires access to the server and a user account to log in to super user.
keywords: reset, password, root, mysql, server, freebsd, openbsd, database, database server, client
---

System wise the MySQL server can be setup without a root password, however, this is not secure. The root password is used to secure data on the MySQL Server and to prevent irresponsible people from destroying our data.

If you forget or lose the MySQL or MariaDB root user password, you can access your data by resetting the lost password. This requires access to the server and a user account to log in to super user.

This article will provide instructions for resetting the root password on the MySQL Server application. You can use the discussion in this article on almost all operating systems such as Windows and Unix and Unix-like systems, as well as general instructions that apply to any system.

The first step you have to do to reset the MySQL server root password is to turn off the program, here's how.

```console
root@ns1:~ # service mysql-server stop
Stopping mysql.
Waiting for PIDS: 2076.
```

The above command is to shut down the running MySQL server. After the MySQL server is inactive,
continue with the following script.


```console
root@ns1:~ # cd /var/db/mysql/
root@ns1:/var/db/mysql # rm -Rf *
```

The `rm -Rf *` command deletes all data in the `/var/db/mysql` folder. After that, reactivate the MySQL server.

```console
root@ns1:/var/db/mysql # sysrc mysql_args="--skip-grant-tables"
mysql_args:  -> --skip-grant-tables
root@ns1:/var/db/mysql # service mysql-server start
Starting mysql.
```

After the MySQL server is active, we continue by creating a new password, here's how.

```console
root@ns1:/var/db/mysql # mysql -u root
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 7
Server version: 8.0.32 Source distribution

Copyright (c) 2000, 2023, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

root@localhost [(none)]> FLUSH PRIVILEGES;
Query OK, 0 rows affected (0.03 sec)

root@localhost [(none)]> ALTER USER 'root'@'localhost' IDENTIFIED BY 'router';
Query OK, 0 rows affected (0.05 sec)

root@localhost [(none)]> exit;
Bye
```

The script above will create a new MySQL root password with the name `Gunungrinjani`. After the new password has been created, save the password carefully and don't forget it. Now we continue with the script below.

```console
root@ns1:/var/db/mysql # service mysql-server stop
Stopping mysql.
Waiting for PIDS: 3379.
root@ns1:/var/db/mysql # sysrc -x mysql_args="--skip-grant-tables"
root@ns1:/var/db/mysql # service mysql-server start
Starting mysql.
```

Now it's time to test the password that we created above, whether it works or not. Follow the script below.

```console
root@ns1:/var/db/mysql # mysql -u root -p
Enter password: gunungrinjani
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 9
Server version: 8.0.32 Source distribution

Copyright (c) 2000, 2023, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

root@localhost [(none)]>
```

If **root@localhost [(none)]>** appears, it means you have successfully created a new MySQL server root password.

You must follow every instruction in this article in sequence, because it will cause the new MySQL server password to not work. As a result, you will not be able to log in with the new password.