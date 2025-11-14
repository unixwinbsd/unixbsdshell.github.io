---
title: Learn How to Install MySQL Server on FreeBSD Machine
date: "2025-05-04 07:05:35 +0100"
updated: "2025-05-04 07:05:35 +0100"
id: learn-install-mysql-server-freebsd
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: DataBase
background: /img/Logo.png
toc: true
comments: true
published: true
excerpt: The word relational means that the databases are presented as related information and are described as a set of relationships. MySQL works with the SQL query language, which is traditionally used in databases.
keywords: mysql, server, freebsd, database, sql, query, mariadb
---

MySQL is a relational database management system (RDBMS) that is distributed as free software. It is one of the most popular, as it is flexible, lightweight, and easy to use.

The word "relational" means that the databases are presented as related information and are described as a set of relationships. MySQL works with the SQL query language, which is traditionally used in databases.

This article provides procedures for installing MySQL Server on FreeBSD Unix variants. The easiest way and many people like it is to install MySQL Sever using the mysql-server and mysql-client ports which are available in the **/usr/ports/databases/mysql80-server** and **/usr/ports/databases/mysql80-client** folders.

Installing MySQL Server using this port gives you the following benefits:
- Automatic configuration and build.
- The startup script is installed directly in /usr/local/etc/rc.d.
- Ability to use pkg_info -L to see which files are installed.
- Ability to use pkg_delete to remove MySQL if you no longer want it on your machine.

## 1. System Specifications
- OS: FreeBSD 13.2-STABLE
- CPU: AMD Phenom II X4 965 3400 MHz
- IP LAN: 192.168.5.2
- Domain: unixexplore.com
- Hostname: ns1
- MySQL version: mysql80-server

## 2. MySQL Server installation
In this material we will practice how to install and configure MySQL Server on a FreeBSD 13.2 stable machine. OK, let's just start the MySQL Server installation process:

```
root@router2:~ # cd /usr/ports/databases/mysql80-client
root@router2:/usr/ports/databases/mysql80-client # make install clean
root@router2:~ # cd /usr/ports/databases/mysql80-server
root@router2:/usr/ports/databases/mysql80-server # make install clean
```

To install MySQL Server on FreeBSD 13.2 using ports, it takes a long time for the installation process to complete. Alternatively, you can use the pkg package that comes with FreeBSD machines.

```
root@router2:~ # pkg install mysql80-client
root@router2:~ # pkg install mysql80-server
```

After the installation process is complete, delete the files in the **/var/db/mysql** folder.

```
root@router2:~ # rm -rf /var/db/mysql/
```

Create ownership rights for files and folders.

```
root@router2:~ # chown -R mysql:mysql /usr/local/etc/mysql
```

The chown command will assign users and groups to the files in /usr/local/etc/mysql. The next step is to create a startup script in the rc.conf file. This script will run automatically when the computer is turned off or restarted.

```
root@router2:~ # ee /etc/rc.conf
mysql_enable="YES"
mysql_dbdir="/var/db/mysql"
mysql_confdir="/usr/local/etc/mysql"
mysql_user="mysql"
mysql_optfile="/usr/local/etc/mysql/my.cnf"
mysql_rundir="/var/run/mysql"
```

Restart/reboot the FreeBSD server machine computer. After the computer engine returns to normal, you continue by restarting the MySQL server with a script "service mysql-server restart".

```
root@router2:~ # reboot
```

Once your computer is back to normal and ready to use, run the restart command once more. This is done to check whether MySQL is running on the FreeBSD server.

```
root@router2:~ # service mysql-server restart
```

## 3. Create and Change MySQL Server Root Password

### 3.1. Creating MySQL Password
The password is the most important thing on the MySQL Server, because to be able to enter the MySQL Server you need a password to open it. In the first discussion, we will try to create a new password on MySQL Server, use the mysql_secure_installation script to create and change the MySQL Server password.

```
root@router2:~ # mysql_secure_installation
mysql_secure_installation: [ERROR] unknown variable 'prompt=\u@\h [\d]>\_'.

Securing the MySQL server deployment.

Connecting to MySQL using a blank password.

VALIDATE PASSWORD COMPONENT can be used to test passwords
and improve security. It checks the strength of password
and allows the users to set only those passwords which are
secure enough. Would you like to setup VALIDATE PASSWORD component?

Press y|Y for Yes, any other key for No:    enter
Please set the password for root here.

New password:    enter a new password

Re-enter new password:    The password must be the same as above
By default, a MySQL installation has an anonymous user,
allowing anyone to log into MySQL without having to have
a user account created for them. This is intended only for
testing, and to make the installation go a bit smoother.
You should remove them before moving into a production
environment.

Remove anonymous users? (Press y|Y for Yes, any other key for No) : y
Success.


Normally, root should only be allowed to connect from
'localhost'. This ensures that someone cannot guess at
the root password from the network.

Disallow root login remotely? (Press y|Y for Yes, any other key for No) : y
Success.

By default, MySQL comes with a database named 'test' that
anyone can access. This is also intended only for testing,
and should be removed before moving into a production
environment.


Remove test database and access to it? (Press y|Y for Yes, any other key for No) : y
 - Dropping test database...
Success.

 - Removing privileges on test database...
Success.

Reloading the privilege tables will ensure that all changes
made so far will take effect immediately.

Reload privilege tables now? (Press y|Y for Yes, any other key for No) : y
Success.

All done!
root@router2:~ #
```

### 3.2. Change MySQL Password
After we have successfully created the MySQL server root password, now we continue with how to change the MySQL Server root password, the script is the same as above.

```
root@router2:~ # mysql_secure_installation
mysql_secure_installation: [ERROR] unknown variable 'prompt=\u@\h [\d]>\_'.

Securing the MySQL server deployment.

Enter password for user root: enter the old password

VALIDATE PASSWORD COMPONENT can be used to test passwords
and improve security. It checks the strength of password
and allows the users to set only those passwords which are
secure enough. Would you like to setup VALIDATE PASSWORD component?

Press y|Y for Yes, any other key for No:    enter
Using existing password for root.
Change the password for root ? ((Press y|Y for Yes, any other key for No) : y

New password: enter a new password

Re-enter new password: Enter a new password, it must be the same as above
By default, a MySQL installation has an anonymous user,
allowing anyone to log into MySQL without having to have
a user account created for them. This is intended only for
testing, and to make the installation go a bit smoother.
You should remove them before moving into a production
environment.

Remove anonymous users? (Press y|Y for Yes, any other key for No) : y
Success.


Normally, root should only be allowed to connect from
'localhost'. This ensures that someone cannot guess at
the root password from the network.

Disallow root login remotely? (Press y|Y for Yes, any other key for No) : y
Success.

By default, MySQL comes with a database named 'test' that
anyone can access. This is also intended only for testing,
and should be removed before moving into a production
environment.


Remove test database and access to it? (Press y|Y for Yes, any other key for No) : y
 - Dropping test database...
Success.

 - Removing privileges on test database...
Success.

Reloading the privilege tables will ensure that all changes
made so far will take effect immediately.

Reload privilege tables now? (Press y|Y for Yes, any other key for No) : y
Success.

All done!
root@router2:~ #
```

## 4. Test MySQL Server

Now we have to test whether the MySQL Server that we have configured can run well or there are still wrong scripts. See if the MySQL Server version has been read, if not, it means the configuration is wrong.

```
root@router2:~ # mysql -V
mysql  Ver 8.0.32 for FreeBSD13.2 on amd64 (Source distribution)
root@router2:~ #
```

We continue with the next test, using the MySQL Server root password that we created earlier.

```
root@router2:~ # mysql -u root -p
Enter password:  enter password
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 12
Server version: 8.0.32 Source distribution

Copyright (c) 2000, 2023, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

root@localhost [(none)]> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
| sys                |
+--------------------+
4 rows in set (0.06 sec)

root@localhost [(none)]>
```

## 5. Create database, Username and Password
Once we have access to the MySQL server prompt, we can create a database, username and password. Use the command below to create a database, username and password to connect to the MySQL server.

```
root@ns:~ # mysql -u root -p
root@localhost [(none)]> CREATE DATABASE kerinci;
Query OK, 1 row affected (0.05 sec)

root@localhost [(none)]> CREATE DATABASE leuser;
Query OK, 1 row affected (0.04 sec)

root@localhost [(none)]>
```

The command above is used to create a kerinci and leuser database. Now we will create a username and password.

```
root@localhost [(none)]> CREATE USER 'pendaki'@'localhost' IDENTIFIED BY 'semeru';
Query OK, 0 rows affected (0.05 sec)

root@localhost [(none)]> GRANT SELECT ON *.* TO 'pendaki'@'localhost';
Query OK, 0 rows affected (0.04 sec)

root@localhost [(none)]> CREATE USER 'merbabu'@'192.168.5.2' IDENTIFIED BY 'sindoro';
Query OK, 0 rows affected (0.05 sec)

root@localhost [(none)]> GRANT SELECT ON *.* TO 'merbabu'@'192.168.5.2';
Query OK, 0 rows affected (0.04 sec)

root@localhost [(none)]> CREATE USER 'rinjani'@'ns1' IDENTIFIED BY 'kelimutu';
Query OK, 0 rows affected (0.05 sec)

root@localhost [(none)]> GRANT SELECT ON *.* TO 'rinjani'@'ns1';
Query OK, 0 rows affected (0.04 sec)

root@localhost [(none)]>
```

The command above is used to create a username and password:
- Username: pendaki
- Password: semeru
  
- Username: merbabu
- Password: sindoro
  
- Username: rinjani
- Password: kelimutu

Localhost is the localhost IP, namely 127.0.0.1, ns1 is the host name of the computer we are using and 192.168.5.2 is the Private IP of the computer we are using.

If the display is exactly the same as above, congratulations, you have successfully installed MySQL Server on your FreeBSD 13.2 stable machine. Now you can use the MySQL program according to your needs and requirements.
