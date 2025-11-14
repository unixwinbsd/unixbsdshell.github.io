---
title: How to Install Sudo on a FreeBSD System
date: "2025-08-06 07:15:25 +0100"
updated: "2025-08-06 07:15:25 +0100"
id: how-to-install-sudo-on-a-freebsd-system
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: SysAdmin
background: /img/Logo.png
toc: true
comments: true
published: true
excerpt: So, what is sudo and what does it do? If you prefix sudo to any FreeBSD command, it will run with elevated privileges. Elevated privileges are required to perform certain administrative tasks. One day
keywords: sudo, sudoer, user, group, create, permission, add, chmod, chown, freebsd, wheel, all
---

Sudo is a command-line utility for Unix-based operating systems such as FreeBSD, OpenBSD, DragonFLY BSD, Linux, and macOS. The sudo utility provides an efficient way to grant privileged access to system resources to a user or group of users, allowing them to run commands they wouldn't otherwise be able to run under their regular account. Users can even be granted permission to run commands under the root account, the most powerful account on Unix-like systems. Sudo also logs all commands and arguments so administrators can track which users use sudo.


So, what is sudo and what does it do? If you prefix "sudo" to any FreeBSD command, it will run with elevated privileges. Elevated privileges are required to perform certain administrative tasks. One day, you might want to run a LAMP (Linux, Apache, MySQL, PHP) server and have to manually edit your configuration files. You might also need to restart or reset the Apache web server or other service daemons.

Or you might even need elevated privileges to shut down or restart your computer. **"Hey, who shut this thing down?!"** If you're familiar with Windows, this is very similar to the Windows User Account Control dialog box that appears when you're trying to do something important, only not as user-friendly.

On Windows, if you try to perform an administrative task, a dialog box will ask you if you want to continue ("Are you sure you want to run the program you just clicked?"). The task is then executed. On a Mac, a security dialog box will appear, prompting you to enter your password and click OK. This is a more dramatic scenario on FreeBSD.

Many sources state that `sudo` stands for superuser do. However, the group that developed sudo stopped using that description over 10 years ago. According to the group's website, sudo now stands for su `"does"` indicating a tool that provides su-like capabilities. Su is a command-line utility and stands for switch user or alternate user. Like sudo, it allows users to run commands under different accounts. However, sudo has several important advantages over `su`.

## 1. How Sudo Works

With the sudo command, you must enter "sudo" before each command. This means you don't have to remember to switch back to regular user mode, and fewer errors will occur.

With sudo, when a user runs a command, they will be prompted to enter their password to log in. After entering the password correctly, the user can then run other commands without providing the password each time, but there is a limit to how long this will last. By default, the session expires after five minutes of inactivity, and the user must re-enter the password. However, administrators can set a time other than five minutes when configuring sudo.

Sudo allows regular users to run commands with elevated privileges. This is a great way to temporarily grant administrative privileges to users without sharing root account credentials. But how does sudo management work? What best practices should you follow before adding a user to sudo?

There are two ways to escalate your privileges on a Unix system like FreeBSD. You can log in as root or the superuser, or you can use sudo. The first method is not recommended, as it violates the principle of least privilege. The second method is a safer approach, as it allows for fine-grained access control and individual accountability.

Sudo management is a technique for limiting and managing privileged access, using sudo configuration files. Administrators can use a single configuration file `(/usr/local/etc)` or create multiple configuration files per user in the `/usr/local/etc/sudoers.d` directory.

This configuration file contains rules that govern which users can run which commands with root privileges. It also contains other configurable parameters, such as whether to require a password for authentication, a list of valid hostnames and networks, and where to report incorrect password attempts.

## 2. How to Install Sudo on FreeBSD

This article will discuss how to use the sudo utility on a FreeBSD system. This article uses **FreeBSD 13.2**.

Okay, let's practice using sudo on a FreeBSD system. By default, FreeBSD doesn't include sudo in its system. For sudo to run on FreeBSD, it must be installed first. Here's how to install sudo on FreeBSD.


```
root@ns1:~ # cd /usr/ports/security/sudo
root@ns1:/usr/ports/security/sudo # make install clean
===> SECURITY REPORT: 
      This port has installed the following binaries which execute with
      increased privileges.
/usr/local/bin/sudo

      This port has installed the following files which may act as network
      servers and may therefore pose a remote security risk to the system.
/usr/local/bin/sudo
/usr/local/sbin/sudo_logsrvd

      If there are vulnerabilities in these programs there may be a security
      risk to the system. FreeBSD makes no guarantee about the security of
      ports included in the Ports Collection. Please type 'make deinstall'
      to deinstall the port if this is a concern.

      For more information, and contact details about the security
      status of this software, see the following webpage: 
https://www.sudo.ws/
===>  Cleaning for sudo-1.9.14p3
```

From the installation process above, we can see that the sudo version used is sudo-1.9.14p3. The main file for sudo configuration is called sudoers which is located in the `/usr/local/etc` and `/usr/local/etc/sudoers.d` folders. Why... why are there two sudo configuration file folders? As explained above, these two folders have different functions. In this article, we will configure sudo in the `/usr/local/etc/sudoers` folder, because we will be using multiple users to configure sudo.

In this article, we'll create several users that can access the FreeBSD system. For more details on creating users in FreeBSD, please read the previous article, ["How to Create Users and Groups in FreeBSD"](https://unixwinbsd.site/freebsd/how-to-create-users-and-groups-in-freebsd/)

For example, let's say we've created users named bromo, rinjani, semeru, argopuro, and so on. Now, let's edit the `/usr/local/etc/sudoers` configuration file. In the `/usr/local/etc/sudoers` file, remove the **"#"** symbol before the script. The following script must be activated.


```console
root@ns1:~ # ee /usr/local/etc/sudoers
Defaults secure_path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
root ALL=(ALL:ALL) ALL
semeru ALL=(ALL:ALL) ALL
rinjani ALL=(ALL:ALL) ALL
bitcoin ALL=(ALL:ALL) ALL
argopuro ALL=(ALL) ALL
%wheel ALL=(ALL:ALL) ALL
```

In the example script above, semeru, rinjani, bitcoin and argopuro are users.

## 3. How to Run Sudo on FreeBSD

After completing the sudo configuration, we will now test sudo by updating pkg and installing unbound.


```
root@ns1:~ # su semeru
$ pkg update
pkg: Insufficient privileges to update the repository catalogue.
$ pkg install unbound
pkg: Insufficient privileges to install packages
```

In the above script, the Semeru user cannot update pkg and cannot install unbundled applications. Now let's add the sudo command.

```
root@ns1:~ # su semeru
$ sudo pkg upgrade
Updating FreeBSD repository catalogue...
FreeBSD repository is up to date.
All repositories are up to date.
Checking for upgrades (0 candidates): 100%
Processing candidates (0 candidates): 100%
Checking integrity... done (0 conflicting)
Your packages are up to date.
$ sudo pkg install unbound
Updating FreeBSD repository catalogue...
FreeBSD repository is up to date.
All repositories are up to date.
The following 1 package(s) will be affected (of 0 checked):

New packages to be INSTALLED:
	unbound: 1.17.1_2

Number of packages to be installed: 1

The process will require 8 MiB more space.
2 MiB to be downloaded.

Proceed with this action? [y/N]: y
```

Adding sudo allows the update and installation process to run. Here's an example of another sudo command routinely run by system administrators.

```
root@ns1:~ # su semeru
$ su argopuro
Password: masukkan password
$ sudo su
root@ns1:~ # 
```

In the first script, we log in as the Semeru user, then in the second script, we log in as the Argopuro user. For the Argopuro user, we must enter a password. And in the final script, we log in as the root user.

We often need to run various commands as the root user to perform operations on Unix-based systems. However, we don't always have root access, and thanks to sudo, we can do that.

Getting familiar with sudo is easy, although it takes time. Hopefully, this tutorial is enough to help you get started with sudo.