---
title: How to Install Webmin on a FreeBSD System
date: "2025-09-15 07:35:11 +0100"
id: how-to-install-webmin-on-freebsd-machine
lang: en
layout: single
author_profile: true
categories:
  - FreeBSD
tags: SysAdmin
excerpt: Webmin is a web-based system administration tool for Unix-like servers, and a service with approximately 1,000,000 annual installations worldwide
keywords: webmin, freebsd, installation, process, pkg, package, system, remote
---

Webmin is a web-based system administration tool for Unix-like servers, and a service with approximately 1,000,000 annual installations worldwide. With webmin we are expected to be able to configure the internal operating system, such as users, disk quotas, services or configuration files, as well as modify and control open source applications, such as the BIND DNS Server, Apache HTTP Server, PHP, MySQL, and many more.

In this article we will explain how to install and use Webmin on a FreeBSD 13.2 Stable system. As with other applications, installing Webmin on a FreeBSD system can use Ports and PKG. In this article we will explain how to install Webmin using both. OK, let's just go ahead and install Webmin.

```
root@router2:~ # pkg update
root@router2:~ # pkg upgrade -y
root@router2:~ # pkg install webmin
```

When using FreeBSD Ports, use the following syntax.

```
root@router2:~ # cd /usr/ports/sysutils/webmin
root@router2:~ # make install clean
```

After the installation process is complete, there are several command-line prompts you must follow. These prompts must be followed to ensure Webmin runs properly.

Now we follow the instructions from the image above. Based on the image above Webmin is configured with the file `/usr/local/lib/webmin/setup.sh`.


```
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

```
root@router2:~ # ee /etc/rc.conf
webmin_enable="YES"
```

After we have activated Webmin in the `/etc/rc.conf` file, run Webmin with the following command.

```
root@router2:~ # service webmin restart
```

If Webmin is active on the FreeBSD system, run Webmin in the Web Browser, to open Webmin you can use the Yandex Browser, Chrome, Firefox and others. Run Webmin with the chrome browser and type http://192.168.9.3:10000/.

The IP address `192.168.9.3` is the FreeBSD system interface IP address and the Webmin port `10000` we created earlier, along with the username and password. After logging in with the admin username and password, Webmin will display the dashboard, indicating you have successfully installed Webmin on FreeBSD.

Webmin provides a variety of functions for server administration, including DNS configuration, user and group management, hardware and software, and more. Webmin has a user-friendly and intuitive interface, which makes it very easy to use, even for novice users. It also supports many plugins and modules, which allows you to expand its functionality. With its attractive graphic design, Webmin will make it easier for System Administrators to configure servers.