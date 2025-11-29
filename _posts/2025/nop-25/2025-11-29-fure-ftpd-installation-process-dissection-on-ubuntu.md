---
title: Pure FTPD Installation Process Dissection on Ubuntu Linux Server
date: "2025-11-29 06:05:37 +0000"
updated: "2025-11-29 06:05:37 +0000"
id: fure-ftpd-installation-process-dissection-on-ubuntu
lang: en
author: Iwan Setiawan
robots: index, follow
categories: linux
tags: SysAdmin
background: https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/img/nop-25-036.jpg
toc: true
comments: true
published: true
excerpt: On an Ubuntu server, installing PureFTPd is very easy. Start by updating your Ubuntu system using the update command to ensure all packages are up-to-date.
keywords: linux, ubuntu, fure, ftpd, installation, process, dissection, server, client, unix
---

Pure-FTPd is a free, secure, and actively developed FTP server software popular in the Unix and Linux communities. It is designed with a focus on simplicity, efficiency, and security. Pure-FTPd supports various authentication methods, including Unix system accounts, virtual users, and LDAP. It also offers comprehensive features such as TLS/SSL encryption, IPv6 support, bandwidth limiting, and virtual hosting.

Its configuration options are flexible, making it suitable for both personal and corporate use. Additionally, Pure-FTPd provides logging capabilities to track FTP activity for security and auditing purposes. Overall, this software is a reliable choice for setting up FTP services on Unix-like operating systems.

This server software is admired for its lightweight nature and compatibility with a wide range of operating systems, including various Linux distributions like Ubuntu. Installing PureFTPd is a straightforward process. For those using Ubuntu Server, the command sudo apt install pure-ftpd will start the process. But before we discuss the Pure-FTPD installation process, it's a good idea to first get to know some of the features it has.

<figure class="figure">
 <img src="https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/img/nop-25-036.jpg" class="figure-img lazyload img-fluid rounded" alt="Fure FTPD Installation Process Dissection on Ubuntu Linux Server">
 <figcaption class="figure-caption text-center">
 Fure FTPD Free FTP server with high level security system
 </figcaption>
 </figure>

 <br/>

## 1. Pure-FTPd Features

- Supports SSL/TLS encryption to protect passwords and commands.
- Runs on most Unix-like systems: Linux, BSD, Solaris, Darwin, HPUX, AIX, and even the iPhone.
- Available in 21 languages.
- Allows you to monitor active sessions.
- Supports a virtual quota system.
- Easy installation process.

## 2. Installing and Managing Pure FTPd on Ubuntu

On an Ubuntu server, installing PureFTPd is very easy. Start by updating your Ubuntu system using the update command to ensure all packages are up to date.

```yml
$ sudo apt update
```

After the update process is complete, you can immediately continue with the Pure-FTPD installation process, run the command below to start the installation process.

```yml
$ sudo apt install pure-ftpd
```

Once installed, Pure-FTPd will automatically start, you can check Ubuntu systemd with the following command to check the status of Pure-FTPD.

```yml
$ systemctl status pure-ftpd
```

You can also run Pure-FTPD manually with the following command.

```yml
$ sudo systemctl start pure-ftpd
```

Once the Pure-FTPD server is running normally, to be sure, check whether port 21 is open. If it is, Pure-FTPD is ready to use.

```yml
$ sudo ss -lnpt | grep pure-ftpd
```

### 2.1. Create a User and Group

Once Pure-FTPD is installed, you may want to add an FTP user separate from your system account. Run the commands below to create a Pure-FTPD user and group.

```yml
$ sudo groupadd ftpgroup
```

```yml
$ sudo useradd -g ftpgroup -d /dev/null -s /etc ftpuser
```

After that, you run the `chown` command to give file ownership rights, as follows.

```yml
$ sudo chown -R ftpuser:ftpgroup /home/ftpuser
```

### 2.2. Pure-FTPd Configuration

Now it's time to configure it. After installing the server, you can find all Pure-FTPd configuration files in the `/etc/pure-ftpd/conf` directory. Furthermore, one of the main differences between Pure-FTPd and other FTP servers is that there is no single configuration file for Pure-FTPd. Instead, different settings have their own files.

We can run the command below to configure Pure-FTPd and enable basic security. This command will also set individual settings for the server.

```yml
$ sudo bash
$ echo â€œyesâ€ > /etc/pure-ftpd/conf/Daemonize
$ echo â€œyesâ€ > /etc/pure-ftpd/conf/NoAnonymous
$ echo â€œyesâ€ > /etc/pure-ftpd/conf/ChrootEveryone
$ echo â€œyesâ€ > /etc/pure-ftpd/conf/IPV4Only
$ echo â€œyesâ€ > /etc/pure-ftpd/conf/ProhibitDotFilesWrite
```

After you run the command above, the individual files below will be created in the default `conf` directory.

- **Daemonize** = Runs Pure-FTPd as a daemon
- **NoAnonymous** = Disables anonymous logins
- **ChrootEveryone** = Keep everyone in their home directory
- **IPV4Only** = Only allow IPv4 connections
- **ProhibitDotFilesWrite** = Don't edit dot files

Then, run the command below to restart the Pure-FTPD server.

```yml
$ sudo systemctl restart pure-ftpd
```

Now, we can connect using the server's hostname or IP address. Here are some configuration files we can create.

```yml
$ echo â€˜yesâ€™ > BrokenClientsCompatibility
$ echo â€™50â€™ > MaxClientsNumber
$ echo â€˜5â€™ > MaxClientsPerIP
$ echo â€˜noâ€™ > VerboseLog
$ echo â€˜yesâ€™ > DisplayDotFiles
$ echo â€˜yesâ€™ > NoChmod
$ echo â€˜noâ€™ > AnonymousOnly
$ echo â€˜noâ€™ > PAMAuthentication
$ echo â€˜noâ€™ > UnixAuthentication
$ echo â€˜/etc/pure-ftpd/pureftpd.pdbâ€™ > PureDB
$ echo â€˜yesâ€™ > DontResolve
$ echo â€™15â€™ > MaxIdleTime
$ echo â€˜2000 8â€™ > LimitRecursion
$ echo â€˜yesâ€™ > AntiWarez
$ echo â€˜noâ€™ > AnonymousCanCreateDirs
$ echo â€˜4â€™ > MaxLoad
$ echo â€˜noâ€™ > AllowUserFXP
$ echo â€˜noâ€™ > AllowAnonymousFXP
$ echo â€˜noâ€™ > AutoRename
$ echo â€˜yesâ€™ > AnonymousCantUpload
$ echo â€˜yesâ€™ > NoChmod
$ echo â€™80â€™ > MaxDiskUsage
$ echo â€˜yesâ€™ > CustomerProof
```

  <script type="text/javascript">
	atOptions = {
		'key' : '88e2ead0fd62d24dc3871c471a86374c',
		'format' : 'iframe',
		'height' : 250,
		'width' : 300,
		'params' : {}
	};
</script>
<script type="text/javascript" src="//www.highperformanceformat.com/88e2ead0fd62d24dc3871c471a86374c/invoke.js"></script>


## 3. Create a self-signed SSL/TLS certificate

Next, you need to create a self-signed certificate for Pure FTPd. You can create one with the following command.

```yml
$ Create a Self-signed SSL/TLS certificateopenssl req -x509 -nodes -newkey rsa:2048 -keyout /etc/ssl/private/pure-ftpd.pem -out /etc/ssl/private/pure-ftpd.pem -days 365
```

### 3.1. Configuring Pure FTPd to use an SSL/TLS certificate

To run the Pure-FTPD server with an SSL/TLS certificate, you need to configure Pure FTPd to use the certificate we created above. You can configure this by editing the `pure-ftpd.conf` file with the nano command.

```console
$ nano /etc/pure-ftpd/pure-ftpd.conf
TLS                          2
TLSCipherSuite               HIGH:MEDIUM:+TLSv1:!SSLv2:!SSLv3
CertFile                     /etc/ssl/private/pure-ftpd.pem
```

Save and close the file when finished. Then, restart the Pure FTPd service to apply the changes.

```yml
$ sudo systemctl restart pure-ftpd
```

## 4. How to Connect to an FTP Server from a Client

Next, you need to connect to the Pure FTPd server from the client machine using the FileZilla FTP client. First, open the FileZilla client and click on Site Manager. You will see the following screen.


<figure class="figure">
 <img src="https://raw.githubusercontent.com/unixwinbsd/unixbsdshell.github.io/refs/heads/main/img/nop-25/nop-25-037.jpg" class="figure-img lazyload img-fluid rounded" alt="Fure FTPD Installation Process Dissection on Ubuntu Linux Server">
 <figcaption class="figure-caption text-center">
 Process of Connecting FTPD Server with Client
 </figcaption>
 </figure>

<br/>

Provide your Pure FTPd server IP address, select the FTP protocol, select `"Require explicit FTP over TLS"` provide your FTP username and password, and click the Connect button. You will be prompted to accept the certificate, after which you can simply click the OK button.

Congratulations! You have successfully installed Pure FTPd with SSL/TLS support on your Ubuntu server. You can also deploy the installed Pure-FTPD server in Remmin, Putty, or WinSCP.
