---
title: FreeBSD MySQL - Resolving ERROR 1819 (HY000) Your password does not meet the requirements of the current policy
date: "2025-10-21 07:45:12 +0100"
updated: "2025-10-21 07:45:12 +0100"
id: freebsd-mysql-server-resolving-error-1819
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: DataBase
background: /img/oct-25/oct-25-120.jpg
toc: true
comments: true
published: true
excerpt: In this article, we've written a guide that will provide you with a simple, step-by-step solution to this problem, helping you get back on track with your MySQL database project.
keywords: freebsd, myswl, mysql server, error, 1819, resolving, password, root, server, requirements, current, policy
---

Encountering the "Your password does not meet the requirements of the current policy" error in MySQL can be a daunting task for both beginners and professionals.

Password errors often occur when you create a MySQL user account with a relatively weak password; you might encounter the error "MySQL ERROR 1819 (HY000): Your password does not meet the requirements of the current policy." Technically, this isn't an error, but rather a notification that you're using a password that doesn't meet the recommended password policy requirements.

As seen on the screen in the Shell menu, you'll be prompted to enable the VALIDATE PASSWORD component when setting a password for the MySQL root user. When enabled, the Validate Password component will automatically check the strength of the password provided and force users to only set sufficiently strong ones.

If you provide a weak password, you'll encounter an error like this: ERROR 1819 (HY000): Your password does not meet the requirements of the current policy.

In other words, you're using a weak password that's easy to guess or crack. Built-in security mechanisms prevent users from creating weak passwords that could leave your database vulnerable to breaches.

In this article, we've written a guide that will provide you with a simple, step-by-step solution to this problem, helping you get back on track with your MySQL database project.


## 1. ERROR 1819 (HY000)

To resolve the error code above, we will provide an example, for example, you experience an error when creating a user as shown in the image.


```
root@hostname1:~ # mysql -u root -p
Enter password:
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 11
Server version: 9.0.1 Source distribution

Copyright (c) 2000, 2024, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql>
```

Create a user with the name `"ghostuser"` and the password `"router_firewall123"`.


```
mysql> CREATE USER 'ghostuser'@'localhost' IDENTIFIED BY 'router_firewall123';
ERROR 1819 (HY000): Your password does not satisfy the current policy requirements
mysql>
```

The error code `"1819"` appears. How do I resolve this error code?.

<br/>

![current policy requirements](/img/oct-25/oct-25-120.jpg)

<br/>

Technically, this isn't actually an error. It's a built-in security mechanism that forces users to only provide strong passwords based on the requirements of the MySQL server password policy in effect on your FreeBSD system.

In the example error code above, the Password Validation component doesn't allow you to create a user with a weak password (e.g., "router_firewall123" in this article).

Error code 1819 will continue to appear if the password you created doesn't meet the requirements of the current password policy or if you've disabled the Password Validation component.


## 2. What you need to know about MySQL error 1819 (HY000)

MySQL databases come with the validate_password plugin. When enabled, it enforces the password validation policy.

The MySQL plugin enforces three levels of password validation policy:

- **LOW:** Allows users to set passwords with 8 characters or less.

- **MEDIUM:** Allows users to set passwords with 8 characters or less, with a mix of uppercase and special characters.

- **STRONG:** Allows users to set passwords that have all the attributes of a medium-level password by including a dictionary file.

The password policy is set to MEDIUM by default. We run the command below to confirm the password policy level.


```
mysql> SHOW VARIABLES LIKE 'validate_password%'; 
```

<br/>

![validate password](https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/img/oct-25-121.jpg)

<br/>

As you can see in the example script above, the current password level is Medium. Therefore, our password must be 8 characters long, consisting of numbers, uppercase letters, and special characters.

Now let's try the password `Password4235#@!` and see the results.


```
mysql> create user 'ghostuser'@'localhost' identified by 'Password4235#@!';
Query OK, 0 rows affected (0.04 sec)
```

Now, with the password `Password4235#@!`, you've successfully created a user and password. So, to fix the `ERROR 1819 (HY000)` error, you need to enter the password according to the current password validation policy.


## 3. How to fix MySQL error 1819 (HY000) on FreeBSD

The MySQL server database management system has many authentication plugins for authenticating users with the database. You can install MySQL plugins in MySQL using the INSTALL PLUGIN statement.

The first step is to run the command below to remove the `validate_password` plugin.


```
mysql> uninstall plugin validate_password;
```

If the above deletion does not work, you can run the following delete command.

```
mysql> UNINSTALL COMPONENT 'file://component_validate_password';
```

To enable the `validate_password plugin`, you can run the command below.


```
mysql> select plugin_name, plugin_status from information_schema.plugins where plugin_name like 'validate%';
Empty set (0.02 sec)

mysql> install plugin validate_password soname 'validate_password.so';
Query OK, 0 rows affected, 1 warning (0.02 sec)
```

Before running a plugin, ensure that the specified plugin file is available in the directory path specified as the value of the plugin_dir variable. You can verify the value of this variable with the following command.


```
mysql> show variables like 'plugin_dir';
+---------------+------------------------------------+
| Variable_name | Value                                    |
+---------------+------------------------------------+
| plugin_dir        | /usr/local/lib/mysql/plugin/  |
+---------------+-------------------------------------+
1 row in set (0.02 sec)
```

Once you have finished installing the `validate_password` plugin, you can verify the details as shown below.


```
mysql> select plugin_name, plugin_status from information_schema.plugins where plugin_name like 'validate%';
+----------------------+-----------------+
| plugin_name          | plugin_status |
+----------------------+-----------------+
| validate_password | ACTIVE        |
+----------------------+-----------------+
1 row in set (0.00 sec)
```

If you want to see a list of plugins present on the MySQL server, run the command `SHOW PLUGINS;`.

```
mysql> SHOW PLUGINS; 
```

<br/>

![display mysql plugin](https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/img/oct-25-122.jpg)

<br/>

To fix the `"1819 (HY000)"` error, you'll need to set the password validation policy to low. I don't recommend this, as it will expose your database to hackers. However, if you insist on doing what you want, here's what you can do.


```
mysql> SET GLOBAL validate_password_policy=0;
OR
mysql> SET GLOBAL validate_password_policy=LOW;
```

Then check whether the password validation policy has been changed to low or 0.

```
mysql> SHOW VARIABLES LIKE 'validate_password%';
```

The result should be like the image below `validate_password_policy = LOW`.

<br/>

![validate_password_policy](https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/img/oct-25-123.jpg)

<br/>


If the results of the command above are like the image below,

<br/>

![password validation OK](https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/img/oct-25-124.jpg)

<br/>


If the `validate_password_policy` plugin removal process is unsuccessful, you must repeat the removal process with the UNINSTALL COMPONENT `file://component_validate_password` command;

After that, repeat the plugin installation process as described above.

After modifying the `validate_password_policy`, you can now create users with weak passwords, as shown below.


```
mysql> CREATE USER 'ghostuser'@'localhost' IDENTIFIED BY 'router_firewall123';
Query OK, 0 rows affected (0.04 sec)
```

Finally, enable the `validate_password_policy` component.

```
mysql> INSTALL COMPONENT "file://component_validate_password";
Query OK, 0 rows affected (0.02 sec)
```

In this guide, you learned about one of the common MySQL errors: ERROR 1819 (HY000): Your password does not meet the current policy requirements, and how to fix it on FreeBSD.

This article also explains how to disable the password policy to allow weak passwords in some cases. Personally, I recommend using strong passwords.