---
title: How to Install Webmin on a FreeBSD System
date: "2025-09-15 07:35:11 +0100"
updated: "2025-09-15 07:35:11 +0100"
id: how-to-install-webmin-on-freebsd-machine
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: SysAdmin
background: data:image/jpeg;base64,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
toc: true
comments: true
published: true
excerpt: Webmin is a web-based system administration tool for Unix-like servers, and a service with approximately 1,000,000 annual installations worldwide
keywords: webmin, freebsd, installation, process, pkg, package, system, remote
---

Webmin is a web-based system administration tool for Unix-like servers, and a service with approximately 1,000,000 annual installations worldwide. With webmin we are expected to be able to configure the internal operating system, such as users, disk quotas, services or configuration files, as well as modify and control open source applications, such as the BIND DNS Server, Apache HTTP Server, PHP, MySQL, and many more.

In this article we will explain how to install and use Webmin on a `FreeBSD 13.2 Stable` system. As with other applications, installing Webmin on a FreeBSD system can use Ports and PKG. In this article we will explain how to install Webmin using both. OK, let's just go ahead and install Webmin.

```yml
root@router2:~ # pkg update
root@router2:~ # pkg upgrade -y
root@router2:~ # pkg install webmin
```

When using FreeBSD Ports, use the following syntax.

```yml
root@router2:~ # cd /usr/ports/sysutils/webmin
root@router2:~ # make install clean
```

After the installation process is complete, there are several command-line prompts you must follow. These prompts must be followed to ensure Webmin runs properly.

Now we follow the instructions from the image above. Based on the image above Webmin is configured with the file `/usr/local/lib/webmin/setup.sh`.


```console
root@router2:~ # /usr/local/lib/webmin/setup.sh
***********************************************************************
        Welcome to the Webmin setup script, version 2.013
***********************************************************************
Webmin is a web-based interface that allows Unix-like operating
systems and common Unix services to be easily administered.

Installing Webmin in /usr/local/lib/webmin

***********************************************************************
Webmin uses separate directories for configuration files and log files.
Unless you want to run multiple versions of Webmin at the same time
you can just accept the defaults.

Config file directory [/usr/local/etc/webmin]:
Log file directory [/var/db/webmin]:

***********************************************************************
Webmin is written entirely in Perl. Please enter the full path to the
Perl 5 interpreter on your system.

Full path to perl (default /usr/local/bin/perl):

Testing Perl ..
.. done

***********************************************************************
Operating system name:    FreeBSD
Operating system version: 13.2

***********************************************************************
Webmin uses its own password protected web server to provide access
to the administration programs. The setup script needs to know :
 - What port to run the web server on. There must not be another
   web server already using this port.
 - The login name required to access the web server.
 - The password required to access the web server.
 - If the web server should use SSL (if your system supports it).
 - Whether to start webmin at boot time.

Web server port (default 10000):
Login name (default admin):
Login password: admin
Password again: admin
Use SSL (y/n): n

***********************************************************************
Creating web server config files ..
.. done

Creating access control file ..
.. done

Creating start and stop init scripts ..
.. done

Creating start and stop init symlinks to scripts ..
.. done

Copying config files ..
.. done

Changing ownership and permissions ..
.. done

Running postinstall scripts ..
.. done

Enabling background status collection ..
.. done

root@router2:~ #
```

When executing the file `/usr/local/lib/webmin/setup.sh`, we configure Webmin with username admin, password admin, use SSL NO and Webmin runs on port 10000. Now activate Webmin by adding the following command to the `/etc/rc file .conf`.

```yml
root@router2:~ # ee /etc/rc.conf
webmin_enable="YES"
```

After we have activated Webmin in the `/etc/rc.conf` file, run Webmin with the following command.

```yml
root@router2:~ # service webmin restart
```

If Webmin is active on the FreeBSD system, run Webmin in the Web Browser, to open Webmin you can use the Yandex Browser, Chrome, Firefox and others. Run Webmin with the chrome browser and type http://192.168.9.3:10000/.

The IP address `192.168.9.3` is the FreeBSD system interface IP address and the Webmin port `10000` we created earlier, along with the username and password. After logging in with the admin username and password, Webmin will display the dashboard, indicating you have successfully installed Webmin on FreeBSD.

Webmin provides a variety of functions for server administration, including DNS configuration, user and group management, hardware and software, and more. Webmin has a user-friendly and intuitive interface, which makes it very easy to use, even for novice users. It also supports many plugins and modules, which allows you to expand its functionality. With its attractive graphic design, Webmin will make it easier for System Administrators to configure servers.